//  Created by Alexander Skorulis on 23/6/2024.

import Vapor

struct NotionController: RouteCollection {
    
    private let secrets: Secrets
    
    init(secrets: Secrets) {
        self.secrets = secrets
    }
    
    func boot(routes: any RoutesBuilder) throws {
        let notion = routes.grouped("notion")
        notion.get(use: fetch)
    }
    
    @preconcurrency
    private func fetch(req: Request) async throws -> String {
        let response = try await req.client.get(
            "https://api.notion.com/v1/blocks/90070adc-6caf-4604-a31a-f2b7bcbd3bdd/children?page_size=100",
            headers: headers
        )
        
        let entryList = try response.content.decode(Notion.ObjectList.self)
        
        print(entryList.results)
        return response.body?.readFullString() ?? "ERROR"
    }
    
    private var headers: HTTPHeaders {
        let authHeader = ("Authorization", "Bearer \(secrets.notionKey)")
        let versionHeader = ("Notion-Version", "2022-06-28")
        return .init([authHeader, versionHeader])
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
