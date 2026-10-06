import XCTest
@testable import OpenStore

final class CatalogTests: XCTestCase {
    func testSearchFindsTheSoftwareBeingReplaced() {
        XCTAssertEqual(Catalog.search("PHOTOSHOP").map(\.id), ["gimp"])
        XCTAssertEqual(Set(Catalog.search("notion").map(\.id)), ["appflowy", "affine"])
    }

    func testCategoryAndQueryIntersect() {
        XCTAssertEqual(Catalog.search("ChatGPT", category: .ai).count, 2)
        XCTAssertTrue(Catalog.search("ChatGPT", category: .privacy).isEmpty)
    }

    func testWhitespaceAndMultipleWords() {
        // Search includes descriptions: Joplin contains both "open-source" and "notebooks".
        let expected: Set<String> = ["open-notebook", "joplin"]
        XCTAssertEqual(Set(Catalog.search("  Open   Notebook  ").map(\.id)), expected)
        XCTAssertEqual(Set(Catalog.search("Notebook Open").map(\.id)), expected)
        XCTAssertEqual(Catalog.search(" \n ").count, Catalog.projects.count)
        XCTAssertTrue(Catalog.search("no-such-project-123").isEmpty)
    }

    func testSavedSubsetDoesNotLeakOtherProjects() {
        let saved = Catalog.projects.filter { $0.id == "gimp" }
        XCTAssertTrue(Catalog.search("notion", in: saved).isEmpty)
        XCTAssertEqual(Catalog.search("", in: saved).map(\.id), ["gimp"])
    }

    func testCatalogHasUniqueIDsAndHTTPSLinks() {
        XCTAssertEqual(Set(Catalog.projects.map(\.id)).count, Catalog.projects.count)
        for project in Catalog.projects {
            XCTAssertEqual(project.websiteURL.scheme, "https")
            XCTAssertNotNil(project.websiteURL.host)
            XCTAssertEqual(project.repositoryURL.scheme, "https")
            XCTAssertNotNil(project.repositoryURL.host)
        }
    }
}
