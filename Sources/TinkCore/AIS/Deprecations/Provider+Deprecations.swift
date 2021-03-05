extension Provider {
    @available(*, deprecated, renamed: "Field")
    public typealias FieldSpecification = Field

    /// Indicates if a user authenticates towards the provider as a person or business.
    public enum AuthenticationUserType {
        case unknown
        /// The user is authenticating as a business.
        case business
        /// The user is authenticating as a person.
        case personal
        /// The user is authenticating as a corporation.
        case corporate
    }

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
