import Foundation

public struct CurrencyDenominatedAmount: Equatable, Hashable, Codable {
    public let value: ExactNumber
    public let currencyCode: CurrencyCode
}

public extension CurrencyDenominatedAmount {
    var doubleValue: Double {
        return value.doubleValue
    }

    init() {
        self.init(0, currencyCode: CurrencyCode(""))
    }

    init(_ int: Int, currencyCode: CurrencyCode) {
        self.init(Decimal(int), currencyCode: currencyCode)
    }

    init(_ double: Double, currencyCode: CurrencyCode) {
        self.init(Decimal(double), currencyCode: currencyCode)
    }

    init(_ decimal: Decimal, currencyCode: CurrencyCode) {
        self.value = ExactNumber(value: decimal)
        self.currencyCode = currencyCode
    }

    init(_ number: NSNumber, currencyCode: CurrencyCode) {
        self.value = ExactNumber(value: number.decimalValue)
        self.currencyCode = currencyCode
    }

    init(_ value: ExactNumber, currencyCode: CurrencyCode) {
        self.value = value
        self.currencyCode = currencyCode
    }

    init(unscaledValue: Int64, scale: Int64, currencyCode: String) {
        self.value = ExactNumber(unscaledValue: unscaledValue, scale: scale)
        self.currencyCode = .init(currencyCode)
    }

    static func + (lhs: CurrencyDenominatedAmount, rhs: CurrencyDenominatedAmount) -> CurrencyDenominatedAmount {
        // TODO: Add with Decimal type instead.
        return CurrencyDenominatedAmount(lhs.doubleValue + rhs.doubleValue, currencyCode: lhs.currencyCode.value.isEmpty ? rhs.currencyCode : lhs.currencyCode)
    }

    static func - (lhs: CurrencyDenominatedAmount, rhs: CurrencyDenominatedAmount) -> CurrencyDenominatedAmount {
        // TODO: Add with Decimal type instead.
        return CurrencyDenominatedAmount(lhs.doubleValue - rhs.doubleValue, currencyCode: lhs.currencyCode.value.isEmpty ? rhs.currencyCode : lhs.currencyCode)
    }

    static func / (lhs: CurrencyDenominatedAmount, rhs: CurrencyDenominatedAmount) -> CurrencyDenominatedAmount {
        // TODO: Add with Decimal type instead.
        return CurrencyDenominatedAmount(lhs.doubleValue / rhs.doubleValue, currencyCode: lhs.currencyCode.value.isEmpty ? rhs.currencyCode : lhs.currencyCode)
    }
}
