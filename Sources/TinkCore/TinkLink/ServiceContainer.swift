public final class ServiceContainer {
    let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    public private(set) lazy var authenticationService: AuthenticationService = RESTAuthenticationService(client: client)
    public private(set) lazy var oAuthService: OAuthService = RESTOAuthService(client: client)
    public private(set) lazy var beneficiaryService: BeneficiaryService = RESTBeneficiaryService(client: client)
    public private(set) lazy var credentialsService: CredentialsService = RESTCredentialsService(client: client)
    public private(set) lazy var providerService: ProviderService = RESTProviderService(client: client)
    public private(set) lazy var transferService: TransferService = RESTTransferService(client: client)
    public private(set) lazy var userService: UserService = RESTUserService(client: client)
}
