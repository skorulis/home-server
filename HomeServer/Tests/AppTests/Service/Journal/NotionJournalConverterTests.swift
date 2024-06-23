//  Created by Alexander Skorulis on 23/6/2024.

@testable import App
import XCTest

final class NotionJournalConverterTests: XCTestCase {
    
    private let sut = NotionJournalConverter()
     
    func testConvertEmptyPage() throws {
        let input = Notion.ObjectList(object: "object", results: [])
        let result = try sut.convert(page: input, month: "June 2024")
        XCTAssertEqual(result.title, "June 2024")
        XCTAssertEqual(result.days.count, 0)
    }
    
    func testConvertSingleDayHeading() throws {
        let input = Notion.ObjectList(object: "object", results: [
            Factory.headingBlock(text: "Saturday 22nd")
        ])
        let result = try sut.convert(page: input, month: "June 2024")
        XCTAssertEqual(result.title, "June 2024")
        XCTAssertEqual(result.days.count, 1)
    }
    
    func testConvertDayWIthEntries() throws {
        let input = Notion.ObjectList(object: "object", results: [
            Factory.headingBlock(text: "Saturday 22nd"),
            Factory.bulletBlock(text: "Something I did")
        ])
        let result = try sut.convert(page: input, month: "June 2024")
        XCTAssertEqual(result.days.count, 1)
        let day1 = try XCTUnwrap(result.days.first)
        XCTAssertEqual(day1.entries.count, 1)
        XCTAssertEqual(day1.entries.first?.text, "Something I did")
    }
}

private enum Factory {
    
    static func headingBlock(text: String) -> Notion.Object {
        .init(
            object: "block",
            type: "heading_2",
            heading_2: .init(rich_text: [
                .init(plainText: text)
            ]),
            bulleted_list_item: nil,
            to_do: nil
        )
    }
    
    static func bulletBlock(text: String) -> Notion.Object {
        .init(
            object: "block",
            type: "heading_2",
            heading_2: nil,
            bulleted_list_item: .init(rich_text: [
                .init(plainText: text)
            ]),
            to_do: nil
        )
    }
}
