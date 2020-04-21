import Foundation

struct RESTAccountListResponse: Decodable {
    let accounts: [RESTAccount]
}

enum RESTAccountType: String, Decodable {
    case checking = "CHECKING"
    case savings = "SAVINGS"
    case investment = "INVESTMENT"
    case mortgage = "MORTGAGE"
    case creditCard = "CREDIT_CARD"
    case loan = "LOAN"
    case pension = "PENSION"
    case other = "OTHER"
    case external = "EXTERNAL"
}

enum RESTAccountExclusion: String, Decodable {
    case aggregation = "AGGREGATION"
    case pfmAndSearch = "PFM_AND_SEARCH"
    case pfmData = "PFM_DATA"
    case none = "NONE"
}

struct RESTAccount: Decodable {

    struct RESTAccountDetails: Decodable {
        let interest: Double?
        let nextDayOfTermsChange: Date?
        let numMonthsBound: Int?
        let type: String?
    }

    struct RESTTransferDestination: Decodable {
        let balance: Double?
        let displayAccountNumber: String?
        let displayBankName: String?
        let matchesMultiple: Bool?
        let name: String?
        let type: String?
        let uri: String?
    }

    let accountExclusion: RESTAccountExclusion
    let accountNumber: String
    let balance: Double
    let closed: Bool?
    let credentialsId: String
    let currencyDenominatedBalance: RESTCurrencyDenominatedAmount?
    let details: RESTAccountDetails?
    let excluded: Bool
    let favored: Bool
    let financialInstitutionId: String?
    let flags: String?
    let holderName: String?
    let id: String
    let identifiers: String?
    let name: String
    let ownership: Double
    let refreshed: Date?
    let transferDestinations: [RESTTransferDestination]?
    let type: RESTAccountType
}
