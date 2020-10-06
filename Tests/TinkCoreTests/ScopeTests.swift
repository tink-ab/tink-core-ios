import XCTest
@testable import TinkCore

class ScopeTests: XCTestCase {
    func testScopeDescription() {
        let scopes: [Scope] = [
            .statistics(.read),
            .transactions(.read),
            .categories(.read),
            .accounts(.read)
        ]
        XCTAssertEqual(scopes.scopeDescription, "statistics:read,transactions:read,categories:read,accounts:read")
    }

    func testNestedScopeDescription() {
        let testScopes: [Scope] = [
            .statistics(.read),
            .transactions(.read, .categorize),
            .calendar(.read),
            .categories(.read),
            .accounts(.read),
            .user(.read),
            .insights(.read, .write),
            .budgets(.read, .write)
        ]

        let targetScopes: [Scope] = [
            .statistics(.read),
            .transactions(.read),
            .transactions(.categorize),
            .calendar(.read),
            .categories(.read),
            .accounts(.read),
            .user(.read),
            .insights(.read, .write),
            .budgets(.read, .write)
        ]

        XCTAssertEqual(testScopes.scopeDescription, targetScopes.scopeDescription)
        XCTAssertEqual(testScopes.scopeDescription, "statistics:read,transactions:read,transactions:categorize,calendar:read,categories:read,accounts:read,user:read,insights:read,insights:write,budgets:read,budgets:write")
        XCTAssertEqual(targetScopes.scopeDescription, "statistics:read,transactions:read,transactions:categorize,calendar:read,categories:read,accounts:read,user:read,insights:read,insights:write,budgets:read,budgets:write")
    }
}
