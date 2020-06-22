struct RESTCurrencyDenominatedAmount: Decodable {
    let unscaledValue: Int
    let scale: Int
    let currencyCode: String
}
