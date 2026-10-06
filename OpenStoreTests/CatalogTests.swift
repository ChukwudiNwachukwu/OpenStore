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
        XCTAssertEqual(Catalog.search("  Open   Notebook  ").map(\.id), ["open-notebook"])
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
