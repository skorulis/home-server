//  Created by Alexander Skorulis on 23/6/2024.

import Foundation

final class NotionJournalConverter {
    
    func convert(page: Notion.ObjectList) -> Journal.Month {
        return .init(days: [])
    }
}
