import Foundation

struct RESTPredictedRecurringTransaction: Decodable {
    let groupId: String
    let accountId: String
    let amount: RESTPredictedRecurringTransactionPredictedAmount
    let description: RESTPredictedDescription
    let date: RESTPredictedTransactionDates
}

struct RESTPredictedTransactionDates: Decodable {
    let predicted: String
}

struct RESTPredictedDescription: Decodable {
    let display: String
    let original: String
}

struct RESTPredictedListRecurringTransactionsResponse: Decodable {
    let nextPageToken: String
    let predictedRecurringTransactions: [RESTPredictedRecurringTransaction]
}

struct RESTPredictedRecurringTransactionPredictedAmount: Codable {
    let predicted: RESTPredictedRecurringTransactionCurrencyDenominatedAmount
}

struct RESTPredictedRecurringTransactionCurrencyDenominatedAmount: Codable {
    let value: RESTPredictedExactNumber
    let currencyCode: String
}

struct RESTPredictedExactNumber: Codable {
    let unscaledValue: String
    let scale: String
}
