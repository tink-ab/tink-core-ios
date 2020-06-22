import Foundation

extension CurrencyDenominatedAmount {
    init(restAIAmount: RESTInsightData.CurrencyDenominatedAmount) {
        self.init(restAIAmount.amount, currencyCode: CurrencyCode(restAIAmount.currencyCode))
    }
}
