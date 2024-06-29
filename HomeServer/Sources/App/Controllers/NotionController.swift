//  Created by Alexander Skorulis on 23/6/2024.

import Vapor

struct NotionController: RouteCollection {
    
    private let secrets: Secrets
    private let converter = NotionJournalConverter()
    private let r2Service: JournalR2Service
    
    init(secrets: Secrets, r2Service: JournalR2Service) {
        self.secrets = secrets
        self.r2Service = r2Service
    }
    
    func boot(routes: any RoutesBuilder) throws {
        let notion = routes.grouped("notion")
        notion.get(":year", ":month", use: fetch)
    }
    
    @preconcurrency
    private func fetch(req: Request) async throws -> Journal.Month {
        let year = req.parameters.get("year")!
        let month = req.parameters.get("month")!
        guard let page = index.page(year: year, month: month) else {
            throw Error.invalidPage(year, month)
        }
        
        let response = try await req.client.get(
            "https://api.notion.com/v1/blocks/\(page.notionID)/children?page_size=100",
            headers: headers
        )
        
        // print(response.body?.readFullString() ?? "ERROR")
        
        let entryList = try response.content.decode(Notion.ObjectList.self)
        let converted = try converter.convert(page: entryList, month: page.title)
        
        try await uploadIndex(index: Journal.Index.shared)
        try await uploadToR2(month: converted, indexPath: page)
        
        return converted
    }
    
    private var index: Journal.Index { .shared }
    
    private func uploadToR2(month: Journal.Month, indexPath: Journal.Page) async throws {
        let data = try JSONEncoder().encode(month)
        let text = String(data: data, encoding: .utf8)!
        try await r2Service.uploadFile(text: text, path: indexPath.cachePath)
    }
    
    private func uploadIndex(index: Journal.Index) async throws {
        let data = try JSONEncoder().encode(index)
        let text = String(data: data, encoding: .utf8)!
        try await r2Service.uploadFile(text: text, path: "index.json")
    }
    
    private var headers: HTTPHeaders {
        let authHeader = ("Authorization", "Bearer \(secrets.notionKey)")
        let versionHeader = ("Notion-Version", "2022-06-28")
        return .init([authHeader, versionHeader])
    }
}

extension NotionController {
    enum Error: LocalizedError {
        case invalidPage(String, String)
        
        var errorDescription: String? {
            switch self {
            case let .invalidPage(year, month):
                return "Could not find page for \(month) \(year)"
            }
        }
    }
}

extension ByteBuffer {
    func readFullString() -> String {
        var copy = self
        var result = ""
        while copy.readableBytes > 0 {
            result += copy.readString(length: copy.readableBytes) ?? ""
        }
        return result
    }
}

extension Journal.Month: Content {}
