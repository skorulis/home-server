//  Created by Alexander Skorulis on 27/6/2024.

@testable import App
import XCTest

final class NotionModelTests: XCTestCase {
    
    func test_rich_text_join() {
        let element = Notion.CommonTextItem(rich_text: [
            Notion.RichText(plainText: "Create the "),
            Notion.RichText(plainText: "repository"),
        ])
        XCTAssertEqual(element.plainText, "Create the repository")
    }
    
    func test_rich_text_markdown() {
        let element = Notion.CommonTextItem(rich_text: [
            Notion.RichText(plainText: "Create the "),
            Notion.RichText(plainText: "journal", href: "http://link.com"),
            Notion.RichText(plainText: " repository"),
        ])
        XCTAssertEqual(element.markdownText, "Create the [journal](http://link.com) repository")
    }
}
