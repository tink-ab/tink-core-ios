extension Provider {
    /// The FinancialInstitution model represents a financial institution.
    public struct FinancialInstitution: Hashable {
        /// A unique identifier of a `FinancialInstitution`.
        public typealias ID = Identifier<FinancialInstitution>

        /// A unique identifier.
        ///
        /// Use this to group providers belonging the same financial institution.
        public let id: ID

        /// The name of the financial institution.
        public let name: String

        /// Creates a FinancialInstitution model.
        /// - Parameters:
        ///   - id: A unique identifier.
        ///   - name: The name of the financial institution.
        public init(id: Provider.FinancialInstitution.ID, name: String) {
            self.id = id
            self.name = name
        }
    }
}
