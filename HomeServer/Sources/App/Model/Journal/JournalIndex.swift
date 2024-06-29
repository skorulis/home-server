//  Created by Alexander Skorulis on 29/6/2024.

import Foundation

extension Journal {

    struct Index: Codable {
        let pages: [Page]
        
        func page(year: String, month: String) -> Page? {
            return pages.first { $0.month == month && $0.year == year }
        }
    }
    
    struct Page: Codable {
        let notionID: String
        let month: String
        let monthNumber: Int
        let year: String
        
        var title: String {
            "\(month.capitalized) \(year)"
        }
        
        var cachePath: String {
            "\(year)/\(month.lowercased()).json"
        }
    }
    
}

extension Journal.Index {
    static let shared: Self = .init(
        pages: [
            .init(
                notionID: "90070adc-6caf-4604-a31a-f2b7bcbd3bdd",
                month: "june",
                monthNumber: 6,
                year: "2024"
            ),
            .init(
                notionID: "43b9d563-1a5a-45ed-8f8d-d49a0fd5559c",
                month: "july",
                monthNumber: 7,
                year: "2024"
            ),
        ]
    )
}
