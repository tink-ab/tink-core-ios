@testable import TinkCore
import XCTest

final class RESTRecommendedBudgetResponseTests: XCTestCase {
    func testDecodable() throws {
        let data = RESTRecommendedBudgetResponse.json.data(using: String.Encoding.utf8)
        let decoder = JSONDecoder()
        let sut = try decoder.decode(RESTRecommendedBudgetResponse.self, from: data!)

        XCTAssertTrue(sut.recommendedBudgets.count == 1)
    }
}

extension RESTRecommendedBudgetResponse {
    static let json: String =
        """
        {
          "recommendedBudgets": [
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
          ]
        }
        """
}
