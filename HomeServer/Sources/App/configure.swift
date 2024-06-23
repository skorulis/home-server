import Vapor
import Foundation

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
    
    let secrets = RealSecrets()
    
    try app.register(collection: NotionController(secrets: secrets))
    
    BonjourService.shared.start()
}
