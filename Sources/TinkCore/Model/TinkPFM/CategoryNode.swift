import Foundation

extension CategoryTree {
    /// The `CategoryTree.Node` model represents a category.
    struct Node: Equatable {
        let category: Category
        var code: Category.Code { category.code }
        var id: Category.ID { category.id }
        var name: String { category.name }
        var subcategories: [Node]

        let sortOrder: Int

        init(code: Category.Code, id: Category.ID, name: String, subcategories: [Node], sortOrder: Int) {
            self.category = Category(id: id, code: code, name: name)
            self.subcategories = subcategories
            self.sortOrder = sortOrder
        }
    }
}

extension CategoryTree.Node: Comparable {
    public static func < (lhs: CategoryTree.Node, rhs: CategoryTree.Node) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}

extension CategoryTree.Node {
    var type: Category.Kind { code.type }

    var isIncome: Bool { code.isIncome }

    var isUncategorized: Bool { code.isUncategorized }

    var isReimbursement: Bool { code.isReimbursement }

    var isSavings: Bool { code.isSavings }

    var isExcluded: Bool { code.isExcluded }

    var isOther: Bool { code.isOther }

    var isMiscOther: Bool { code.isMiscOther }

    var isExpensesOther: Bool { code.isExpensesOther }

    var isRootCategory: Bool { code.isRootCategory }
    var isSubcategory: Bool { code.isSubcategory }

    var formattedName: String? {
        return name
    }
}
