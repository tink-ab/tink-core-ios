import Foundation

extension Decimal {
    var unscaledValue: Int64 {
        var value = self
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
        return normalizedSignificand ?? 0
    }

    var scale: Int64 {
        var value = self
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

        return Int64(-value.exponent)
    }
}
