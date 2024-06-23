//  Created by Alexander Skorulis on 23/6/2024.

import Foundation

// Namespace
enum Journal {
    
    struct Month: Codable {
        let days: [Day]
    }
    
    struct Day: Codable {
        let date: Date
        
        let entries: [Entry]
    }
    
    struct Entry: Codable {
        let text: String
    }
    
}
