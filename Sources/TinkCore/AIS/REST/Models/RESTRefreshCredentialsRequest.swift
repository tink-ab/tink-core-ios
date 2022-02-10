import Foundation

struct RESTRefreshCredentialsRequest: Codable {
    /// The end user will be redirected to this URI after the authorization code has been delivered.
    var appUri: String?
    /// This URI will be used by the ASPSP to pass the authorization code. It corresponds to the redirect/callback URI in OAuth2/OpenId. This parameter is only applicable if you are a TPP.
    var callbackUri: String?

    init(appUri: String?, callbackUri: String?) {
        self.appUri = appUri
        self.callbackUri = callbackUri
    }
}
