import Foundation

struct RESTCurrencyDenominatedAmount: Codable {
    let unscaledValue: Int
    let scale: Int
    let currencyCode: String
}

extension RESTCurrencyDenominatedAmount {
    init(currencyDenominatedAmount: CurrencyDenominatedAmount) {
        (self.scale, self.unscaledValue) = currencyDenominatedAmount.toScaledValue()
        self.currencyCode = currencyDenominatedAmount.currencyCode.value
    }
}

private extension CurrencyDenominatedAmount {
    func toScaledValue() -> (Int, Int) {
        var value = self.value
        var normalizedSignificand: Int64?

        // Due to inprecision when converting through Double; `11.7` becomes `11.700000000000001` and that turns
        // into a `11700000000000001` significand which doesn’t fit into an Int64 type. The solution is to decrease
        // precision of the significand while changing the exponent.

        repeat {
            if let significand = Int64(exactly: value.significand as NSNumber) {
                normalizedSignificand = significand
            } else {
                var nextValue = Decimal()
                NSDecimalRound(&nextValue, &value, -value.exponent - 1, NSDecimalNumber.RoundingMode.plain)
                value = nextValue
            }
        } while normalizedSignificand == nil && value.exponent < 0

        assert(normalizedSignificand != nil)

        let scale = Int64(-value.exponent)
        let unscaledValue = normalizedSignificand ?? 0
        return (Int(scale), Int(unscaledValue))
    }
}
