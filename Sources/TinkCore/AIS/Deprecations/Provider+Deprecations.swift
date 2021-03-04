extension Provider {
    @available(*, deprecated, renamed: "Field")
    public typealias FieldSpecification = Field

    @available(*, unavailable, message: "Use `financialServices` instead.")
    /// Indicates if a user authenticates toward the bank as a person or a business.
    public var authenticationUserType: AuthenticationUserType {
        switch financialServices.first?.segment {
        case .business:
            return .business
        case .personal:
            return .personal
        default:
            return .unknown
        }
    }
}

extension Provider.Field {
    @available(*, deprecated, renamed: "description")
    public var fieldDescription: String { description ?? "" }
}
