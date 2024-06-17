import Foundation

extension CurrencyDenominatedAmount {
    init(restCurrencyDenominatedAmount amount: RESTCurrencyDenominatedAmount) {
        self.value = Decimal(
            sign: amount.unscaledValue < 0 ? .minus : .plus,
            exponent: -amount.scale,
            significand: Decimal(amount.unscaledValue)
        )
        self.currencyCode = CurrencyCode(amount.currencyCode)
    }

    init(_ amount: RESTPredictedRecurringTransactionCurrencyDenominatedAmount) {
        let unscaledValue = Int(amount.value.unscaledValue) ?? 0
        let scale = Int(amount.value.scale) ?? 0
        self.value = Decimal(
            sign: unscaledValue < 0 ? .minus : .plus,
            exponent: -scale,
            significand: Decimal(unscaledValue)
        )
        self.currencyCode = CurrencyCode(amount.currencyCode)
    }
}
