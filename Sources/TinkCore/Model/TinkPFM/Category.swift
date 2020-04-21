@available(*, deprecated, renamed: "Category")
public typealias CategoryNode = Category

public struct Category: Equatable {
    /// A unique identifier of a `Category`.
    public typealias ID = Identifier<Category>

    public let id: ID
    let code: Category.Code
    let name: String
}
