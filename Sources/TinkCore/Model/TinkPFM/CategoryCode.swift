extension Category {
    struct Code: Hashable, ExpressibleByStringLiteral, Codable {
        let value: String

        init(_ value: String) {
            self.value = value
        }

        init(stringLiteral value: String) {
            self.value = value
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(String.self)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
}

extension Category.Code {
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
