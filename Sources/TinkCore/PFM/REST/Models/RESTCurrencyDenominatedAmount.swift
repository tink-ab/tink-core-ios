import Foundation

struct RESTCurrencyDenominatedAmount: Codable {
    let unscaledValue: Int
    let scale: Int
    let currencyCode: String
}

extension RESTCurrencyDenominatedAmount {
    init(currencyDenominatedAmount: CurrencyDenominatedAmount) {
        unscaledValue = Int(currencyDenominatedAmount.value.unscaledValue)
        scale = Int(currencyDenominatedAmount.value.scale)
        currencyCode = currencyDenominatedAmount.currencyCode.value
    }
}
