import Foundation
@testable import TinkCore
import XCTest

class SuggestTransactionsTests: XCTestCase {
    func testSuggestTransactions() {
        let restCurrencyDenominatedAmount = RESTCurrencyDenominatedAmount(
            unscaledValue: 1050,
            scale: 2,
            currencyCode: "EUR"
        )

        let transactions = [
            RESTTransaction(
                accountId: "3fe2d96efacd4dc5994404a950f238a9",
                categoryId: "0e1bade6a7e3459eb794f27b7ba4cea0",
                amount: 34.5,
                categoryType: .expenses,
                currencyDenominatedAmount: restCurrencyDenominatedAmount,
                currencyDenominatedOriginalAmount: restCurrencyDenominatedAmount,
                date: Date(),
                description: "Stadium Sergelg Stockholm",
                dispensableAmount: 0,
                id: "79c6c9c27d6e42489e888e08d27205a1",
                lastModified: Date(),
                notes: "Delicious #cake #wedding",
                originalAmount: 34.5,
                originalDate: Date(),
                originalDescription: "Stadium Sergelg Stockholm",
                timestamp: Date(),
                type: .creditCard,
                upcoming: false,
                userId: "d9f134ee2eb44846a4e02990ecc8d32e",
                pending: false)
        ]

        let clusters = [RESTTransactionCluster(
            categorizationImprovement: 0.003,
                description: "McDonalds Stock",
                transactions: transactions)]

        let restSuggestion = RESTSuggestTransactionsResponse(
            categorizationImprovement: 0.01,
            categorizationLevel: 0.93,
            clusters: clusters)

        let suggestion = SuggestTransactionsResponse(from:  restSuggestion)
        XCTAssertEqual(suggestion.categorizationImprovement, restSuggestion.categorizationImprovement)
        XCTAssertEqual(suggestion.categorizationLevel, restSuggestion.categorizationLevel)
        XCTAssertEqual(suggestion.clusters.count, restSuggestion.clusters.count)
    }
}
