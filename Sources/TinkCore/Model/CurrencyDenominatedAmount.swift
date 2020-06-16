import Foundation

public struct CurrencyDenominatedAmount: Equatable, Hashable, Codable {
    public let value: Decimal
    public let currencyCode: CurrencyCode
}

public extension CurrencyDenominatedAmount {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: value).doubleValue
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
        self.value = decimal
        self.currencyCode = currencyCode
    }

    init(_ number: NSNumber, currencyCode: CurrencyCode) {
        self.value = number.decimalValue
        self.currencyCode = currencyCode
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
