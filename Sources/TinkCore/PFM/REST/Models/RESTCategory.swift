struct RESTCategory: Decodable {
    let code: String
    let defaultChild: Bool
    let id: String
    let parent: String?
    let primaryName: String?
    let searchTerms: String?
    let secondaryName: String?
    let sortOrder: Int
    let type: RESTCategoryType
    let typeName: String
}
