import Foundation

struct RESTUpdateCredentialsRequest: Codable {
    var providerName: String?
    var fields: [String: String]?
    /// This URI will be used by the ASPSP to pass the authorization code. It corresponds to the redirect/callback URI in OAuth2/OpenId. This parameter is only applicable if you are a TPP.
    var callbackUri: String?
    /// The end user will be redirected to this URI after the authorization code has been delivered.
    var appUri: String?
    /// The array contains the list of used products needed to connect the aggregation event triggered from Tink Link to the actual product flow running in Tink Link.
    var productNames: [RESTProductName]?

    init(providerName: String?, fields: [String: String]?, callbackUri: String?, appUri: String?, products: [Product]) {
        self.providerName = providerName
        self.fields = fields
        self.callbackUri = callbackUri
        self.appUri = appUri
        self.productNames = products.productNames
    }
}
