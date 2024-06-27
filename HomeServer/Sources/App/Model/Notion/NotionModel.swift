//  Created by Alexander Skorulis on 23/6/2024.

import Foundation

// Notion Namespace
enum Notion {
    
    protocol TextContainer {
        var rich_text: [RichText]? { get }
    }

    struct ObjectList: Codable {
        let object: String
        let results: [Object]
    }
    
    struct Object: Codable {
        let object: String
        let type: String
        let heading_2: CommonTextItem?
        let bulleted_list_item: CommonTextItem?
        let to_do: TodoItem?
    }
    
    struct CommonTextItem: Codable, TextContainer {
        let rich_text: [RichText]?
    }
    
    struct TodoItem: Codable, TextContainer {
        let rich_text: [RichText]?
        let checked: Bool
    }
    
    struct RichText: Codable {
        let type: String
        let text: Text
        let plain_text: String
        let href: String?
        
        init(type: String = "text", text: Text, plain_text: String, href: String? = nil) {
            self.type = type
            self.text = text
            self.plain_text = plain_text
            self.href = href
        }
        
        init(plainText: String, href: String? = nil) {
            self.type = "text"
            self.text = .init(content: plainText)
            self.plain_text = plainText
            self.href = href
        }
    }
    
    struct Text: Codable {
        let content: String
    }
}

extension Notion.RichText {
    var markdownText: String {
        guard let href else {
            return plain_text
        }
        return "[\(plain_text)](\(href))"
    }
    
    var htmlText: String {
        guard let href else {
            return plain_text
        }
        return "<a href=\"\(href)\">\(plain_text)</a>"
    }
}

extension Notion.TextContainer {
    var plainText: String {
        guard let rich_text else { return "" }
        return rich_text.map { $0.plain_text }.joined()
    }
    
    var markdownText: String {
        guard let rich_text else { return "" }
        return rich_text.map { $0.markdownText }.joined()
    }
    
    var htmlText: String {
        guard let rich_text else { return "" }
        return rich_text.map { $0.htmlText }.joined()
    }
}
