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

    func testSuggestTransactionsResponseMapping() throws {
        let responseJSON = """
        {
          "categorizationImprovement": 0.01,
          "categorizationLevel": 0.93,
          "clusters": [
            {
              "categorizationImprovement": 0.003,
              "description": "McDonalds Stock",
              "transactions": [
                {
                  "accountId": "3fe2d96efacd4dc5994404a950f238a9",
                  "amount": 34.5,
                  "categoryId": "0e1bade6a7e3459eb794f27b7ba4cea0",
                  "categoryType": "EXPENSES",
                  "credentialsId": "65bc7a41a66e4ad1aad199bbfb3c5098",
                  "currencyDenominatedAmount": {
                    "currencyCode": "EUR",
                    "scale": 2,
                    "unscaledValue": 1050
                  },
                  "currencyDenominatedOriginalAmount": {
                    "currencyCode": "EUR",
                    "scale": 2,
                    "unscaledValue": 1050
                  },
                  "date": 1455740874875,
                  "description": "Stadium Sergelg Stockholm",
                  "dispensableAmount": 0,
                  "formattedDescription": "Stadium Sergelgatan Stockholm",
                  "id": "79c6c9c27d6e42489e888e08d27205a1",
                  "inserted": 1455740874875,
                  "lastModified": 1455740874875,
                  "notes": "Delicious #cake #wedding",
                  "originalAmount": 34.5,
                  "originalDate": 1455740874875,
                  "originalDescription": "Stadium Sergelg Stockholm",
                  "partnerPayload": {},
                  "parts": [
                    {
                      "amount": 34.5,
                      "categoryId": "0e1bade6a7e3459eb794f27b7ba4cea0",
                      "counterpartDescription": "Stadium Sergelg Stockholm",
                      "counterpartId": "79c6c9c27d6e42489e888e08d27205a1",
                      "counterpartTransactionAmount": 10.0,
                      "counterpartTransactionId": "d030a7b0840547428aa2fd07026e9a77",
                      "date": 1455740874875,
                      "id": "7303ff128531463bbed358bbf9e23f31",
                      "lastModified": 1455740874875
                    }
                  ],
                  "payload": {},
                  "pending": false,
                  "timestamp": 1464543093494,
                  "type": "CREDIT_CARD",
                  "upcoming": false,
                  "userId": "d9f134ee2eb44846a4e02990ecc8d32e",
                  "userModified": false
                }
              ]
            }
          ]
        }
        """

        guard let data = responseJSON.data(using: .utf8) else {
            XCTFail("Failed to parse JSON")
            return
        }

        let restSuggestTransactionsResponse = try JSONDecoder().decode(RESTSuggestTransactionsResponse.self, from: data)
        let suggestTransaction = SuggestTransactionsResponse(from: restSuggestTransactionsResponse)

        XCTAssertEqual(suggestTransaction.categorizationImprovement, 0.01)
        XCTAssertEqual(suggestTransaction.categorizationLevel, 0.93)
        XCTAssertEqual(suggestTransaction.clusters[0].transactions[0].accountID, "3fe2d96efacd4dc5994404a950f238a9")
        XCTAssertEqual(suggestTransaction.clusters[0].transactions[0].categoryID, "0e1bade6a7e3459eb794f27b7ba4cea0")
    }
}
