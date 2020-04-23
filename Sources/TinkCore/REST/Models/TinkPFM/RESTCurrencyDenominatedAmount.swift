struct RESTCurrencyDenominatedAmount: Decodable {
    let scale: Int
    let unscaledValue: Int
    let currencyCode: String
}
