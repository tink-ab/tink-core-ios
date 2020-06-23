extension Category {
    init(restCategory: RESTCategory) {
        self.id = .init(restCategory.id)
        self.code = .init(restCategory.code)
        self.name = restCategory.secondaryName ?? restCategory.primaryName ?? ""
        self.sortOrder = restCategory.sortOrder
    }
}
