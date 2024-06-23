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
        "Test"
    }
}

