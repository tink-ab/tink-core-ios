extension Provider {
    @available(*, deprecated, renamed: "Field")
    public typealias FieldSpecification = Field
}

extension Provider.Field {
    @available(*, deprecated, renamed: "description")
    public var fieldDescription: String { description ?? "" }
}
