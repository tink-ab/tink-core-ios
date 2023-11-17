@testable import TinkCore
import XCTest

final class RESTRecommendedBudgetTests: XCTestCase {
    func testDecodable() throws {
        let sut0 = try RESTRecommendedBudget.instanceFromJson()

        XCTAssertEqual(sut0.amount.currencyCode, "EUR")
        XCTAssertEqual(sut0.amount.scale, 2)
        XCTAssertEqual(sut0.amount.unscaledValue, 1050)

        XCTAssertNil(sut0.filter.tags)
        XCTAssertNil(sut0.filter.freeTextQuery)
        XCTAssertNil(sut0.filter.accounts)
        XCTAssertEqual(sut0.filter.categories?.count, 1)
        XCTAssertEqual(sut0.filter.categories?[0].code, "expenses:food.coffee")

        XCTAssertEqual(sut0.name, "Coffee budget")

        XCTAssertEqual(sut0.recurringPeriodicity.periodUnit.rawValue, "WEEK")
    }
}

extension RESTRecommendedBudget {
    static let json: String =
        """
        {
              "amount": {
                "currencyCode": "EUR",
                "scale": 2,
                "unscaledValue": 1050
              },
              "filter": {
                "categories": [
                  {
                    "code": "expenses:food.coffee"
                  }
                ]
              },
              "name": "Coffee budget",
              "recurringPeriodicity": {
                "periodUnit": "WEEK"
              }
            }
        """

    static func instanceFromJson() throws -> Self {
        try JSONDecoder().decode(Self.self, from: json.data(using: String.Encoding.utf8)!)
    }
}
