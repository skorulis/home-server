//  Created by Alexander Skorulis on 23/6/2024.

import Foundation

final class NotionJournalConverter {
    
    func convert(page: Notion.ObjectList, month: String) throws -> Journal.Month {
        var context = Context(month: month)
        for block in page.results {
            if let heading = block.heading_2 {
                context.newDay(heading: heading.htmlText)
            } else if let bullet = block.bulleted_list_item {
                try context.addEntry(text: bullet.htmlText)
            } else if let todo = block.to_do {
                if !todo.checked {
                    continue
                }
                try context.addEntry(text: todo.htmlText)
            } else if block.type == "paragraph" {
                // Ignore
            } else {
                throw Error.unexpectedItem(block.type)
            }
        }
        
        return .init(title: month, days: context.allDays)
    }
    
}

private extension NotionJournalConverter {
    
    enum Error: LocalizedError {
        case unexpectedItem(String)
        case noDay(String)
        
        var errorDescription: String? {
            switch self {
            case let .unexpectedItem(type):
                return "Recived unexpected block type: \(type)"
            case let .noDay(text):
                return "Received text outside of a day: \(text)"
            }
        }
    }
    
    // Conversion context
    struct Context {
        let month: String
        var days: [Journal.Day] = []
        var currentDay: Journal.Day?
        
        mutating func addEntry(text: String) throws {
            guard currentDay != nil else {
                throw Error.noDay(text)
            }
            currentDay?.entries.append(.init(text: text))
        }
        
        mutating func newDay(heading: String) {
            if let currentDay {
                days.append(currentDay)
            }
            currentDay = Journal.Day(date: dayDate(heading: heading), entries: [])
        }
        
        private func dayDate(heading: String) -> Date {
            let full = "\(heading.dropLast(2)) \(month)"
            return dateFormatter.date(from: full)!
        }
        
        var allDays: [Journal.Day] {
            var days = days
            if let currentDay {
                days.append(currentDay)
            }
            return days
        }
        
        private let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "EEEE dd MMMM yyyy"
            return df
        }()
    }
}
