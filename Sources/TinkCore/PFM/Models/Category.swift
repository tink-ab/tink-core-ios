public struct Category: Equatable {
    /// A unique identifier of a `Category`.
    public typealias ID = Identifier<Category>

    public let id: ID
    public let code: Category.Code
    public let name: String
    public let sortOrder: Int
    public let parent: ID?
}

extension Category {
    public struct Code: Hashable, ExpressibleByStringLiteral {
        public let value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: String) {
            self.value = value
        }
    }
}

extension Category.Code {
    public var isExpense: Bool { value.hasPrefix("expenses") }
    public var isIncome: Bool { value.hasPrefix("income") }
    public var isTransfer: Bool { value.hasPrefix("transfers") }

    public var type: Category.Kind { Category.Kind(code: self) }

    public var isUncategorized: Bool { type == .expenses && value == "expenses:misc.uncategorized" }
    public var isReimbursement: Bool { type == .income && value.starts(with: "income:refund") }
    public var isSavings: Bool { type == .transfers && value == "transfers:savings.other" }
    public var isExcluded: Bool { type == .transfers && value == "transfers:exclude.other" }
    public var isOther: Bool { value.hasSuffix(".other") }
    public var isMiscOther: Bool { value == "expenses:misc.other" }
    public var isExpensesOther: Bool { isOther && !isMiscOther && type == .expenses && !isSavings && !isExcluded }

    public var isRootCategory: Bool { !value.contains(":") }
    public var isSubcategory: Bool { value.contains(".") }

    public func isChild(of parent: Category.Code) -> Bool {
        return value.hasPrefix(parent.value)
    }
}

extension Category {
    /// A type of category.
    public enum Kind: String, Hashable {
        /// The expenses category type.
        case expenses
        /// The income category type.
        case income
        /// The transfers category type.
        case transfers
    }
}

extension Category.Kind {
    public init(code: Category.Code) {
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

    public var categoryCode: Category.Code {
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
