@testable import TinkCore
import XCTest

class CurrencyDenominatedAmountRESTTests: XCTestCase {
    func testCurrencyDenominatedAmountMapping() {
        let restCurrencyDenominatedAmount = RESTCurrencyDenominatedAmount(
            unscaledValue: 6861,
            scale: 2,
            currencyCode: "EUR"
        )
        let currencyDenominatedAmount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: restCurrencyDenominatedAmount)
        XCTAssertEqual(currencyDenominatedAmount.currencyCode.value, restCurrencyDenominatedAmount.currencyCode)
        XCTAssertEqual(currencyDenominatedAmount.value, Decimal(68.61))
    }
}
