extension CategoryTree.Node {
    init(restCategory: RESTCategory) {
        self.category = Category(
            id: .init(restCategory.id),
            code: .init(restCategory.code),
            name: restCategory.secondaryName ?? restCategory.primaryName ?? ""
        )
        self.subcategories = []
        self.sortOrder = .init(restCategory.sortOrder)
    }
}
