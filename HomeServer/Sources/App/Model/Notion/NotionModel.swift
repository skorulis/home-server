//  Created by Alexander Skorulis on 23/6/2024.

import Foundation

// Notion Namespace
enum Notion {

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
    
    struct CommonTextItem: Codable {
        let rich_text: [RichText]?
    }
    
    struct TodoItem: Codable {
        let rich_text: [RichText]?
        let checked: Bool
    }
    
    struct RichText: Codable {
        let type: String
        let text: Text
        let plain_text: String
    }
    
    struct Text: Codable {
        let content: String
    }
    
    
}


