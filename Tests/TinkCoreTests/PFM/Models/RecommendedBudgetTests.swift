@testable import TinkCore
import XCTest

final class RecommendedBudgetTests: XCTestCase {
    func testMapping() throws {
        let sut = try RecommendedBudget(restRecommendedBudget: RESTRecommendedBudget.instanceFromJson())

        XCTAssertTrue(sut.amount == CurrencyDenominatedAmount(10.5, currencyCode: "EUR"))
        if case Budget.Filter.category(let cat) = sut.filter[0] {
            XCTAssertTrue(cat == "expenses:food.coffee")
        } else {
            XCTFail()
        }
        XCTAssertTrue(sut.name == "Coffee budget")
        XCTAssertTrue(sut.recurringPeriodicity?.periodUnit == Budget.RecurringPeriodicity.PeriodUnit.week)
    }
}

extension RecommendedBudget {
    static func dummyInstance() throws -> Self { try RecommendedBudget(restRecommendedBudget: RESTRecommendedBudget.instanceFromJson()) }
}
