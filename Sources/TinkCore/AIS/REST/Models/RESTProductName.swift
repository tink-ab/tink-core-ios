import Foundation

/// The REST representation of the `Product` model which also contains the `.unknown` case used when the list of the products is empty.
enum RESTProductName: String, Codable {
    case unknown = "PRODUCT_UNKNOWN"
    case realTimeBalance = "PRODUCT_REAL_TIME_BALANCE"
    case paymentInitiation = "PRODUCT_PAYMENT_INITIATION"
    case accountAggregation = "PRODUCT_ACCOUNT_AGGREGATION"
    case accountCheck = "PRODUCT_ACCOUNT_CHECK"
    case incomeCheck = "PRODUCT_INCOME_CHECK"
    case moneyManager = "PRODUCT_MONEY_MANAGER"
    case transactions = "PRODUCT_TRANSACTIONS"
    case businessTransactions = "PRODUCT_BUSINESS_TRANSACTIONS"
    case riskInsights = "PRODUCT_RISK_INSIGHTS"
}

extension Array where Element == Product {
    var productNames: [RESTProductName] {
        // In case if the list of the products is empty we are using `.unknown` case to represent it.
        if isEmpty { return [.unknown] }
        return map(\.productName)
    }
}

/// One-to-one mapping between `Product` and `RESTProductName` cases.
extension Product {
    fileprivate var productName: RESTProductName {
        switch self {
        case .realTimeBalance:
            return .realTimeBalance
        case .paymentInitiation:
            return .paymentInitiation
        case .accountAggregation:
            return .accountAggregation
        case .accountCheck:
            return .accountCheck
        case .incomeCheck:
            return .incomeCheck
        case .moneyManager:
            return .moneyManager
        case .transactions:
            return .transactions
        case .businessTransactions:
            return .businessTransactions
        case .riskInsights:
            return .riskInsights
        }
    }
}
