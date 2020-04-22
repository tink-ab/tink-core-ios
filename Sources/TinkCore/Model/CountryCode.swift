struct CountryCode: Hashable, ExpressibleByStringLiteral {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    init(stringLiteral value: String) {
        self.value = value
    }
}
