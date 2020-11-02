public struct Category: Equatable {
    /// A unique identifier of a `Category`.
    public typealias ID = Identifier<Category>

    public let id: ID
    public let code: Category.Code
    public let name: String
    public let sortOrder: Int
    public let parent: ID?

    public init(id: Category.ID, code: Category.Code, name: String, sortOrder: Int, parent: Category.ID?) {
        self.id = id
        self.code = code
        self.name = name
        self.sortOrder = sortOrder
        self.parent = parent
    }
}

public extension Category {
    struct Code: Hashable, ExpressibleByStringLiteral {
        public let value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: String) {
            self.value = value
        }
    }
}

public extension Category.Code {
    var isExpense: Bool { value.hasPrefix("expenses") }
    var isIncome: Bool { value.hasPrefix("income") }
    var isTransfer: Bool { value.hasPrefix("transfers") }

    var type: Category.Kind { Category.Kind(code: self) }

    var isUncategorized: Bool { type == .expenses && value == "expenses:misc.uncategorized" }
    var isReimbursement: Bool { type == .income && value.starts(with: "income:refund") }
    var isSavings: Bool { type == .transfers && value == "transfers:savings.other" }
    var isExcluded: Bool { type == .transfers && value == "transfers:exclude.other" }
    var isOther: Bool { value.hasSuffix(".other") }
    var isMiscOther: Bool { value == "expenses:misc.other" }
    var isExpensesOther: Bool { isOther && !isMiscOther && type == .expenses && !isSavings && !isExcluded }

    var isRootCategory: Bool { !value.contains(":") }
    var isSubcategory: Bool { value.contains(".") }

    func isChild(of parent: Category.Code) -> Bool {
        return value.hasPrefix(parent.value)
    }
}

public extension Category {
    /// A type of category.
    enum Kind: String, Hashable {
        /// The expenses category type.
        case expenses
        /// The income category type.
        case income
        /// The transfers category type.
        case transfers
    }
}

public extension Category.Kind {
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
