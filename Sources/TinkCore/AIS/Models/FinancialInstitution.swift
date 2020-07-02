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
    }
}
