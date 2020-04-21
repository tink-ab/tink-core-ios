import Foundation

@available(*, deprecated, renamed: "Category.Kind")
public typealias CategoryType = Category.Kind

extension Category {
    /// A type of category.
    public enum Kind: String, Hashable, Codable {
        /// The expenses category type.
        case expenses
        /// The income category type.
        case income
        /// The transfers category type.
        case transfers
    }
}

extension Category.Kind {
    init(code: Category.Code) {
        if code.isExpense {
            self = .expenses
        } else if code.isIncome {
            self = .income
        } else if code.isTransfer {
            self = .transfers
        } else {
            self = .expenses
        }
    }

    var categoryCode: Category.Code {
        switch self {
        case .expenses:
            return Category.Code("expenses")
        case .income:
            return Category.Code("income")
        case .transfers:
            return Category.Code("transfer")
        }
    }
}
