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

    // PFM
    public private(set) lazy var accountService: AccountService = RESTAccountService(client: client)
    public private(set) lazy var actionableInsightService: ActionableInsightService = RESTActionableInsightService(client: client)
    public private(set) lazy var budgetService: BudgetService = RESTBudgetService(client: client)
    public private(set) lazy var calendarService: CalendarService = RESTCalendarService(client: client)
    public private(set) lazy var categoryService: CategoryService = RESTCategoryService(client: client)
    public private(set) lazy var statisticService: StatisticService = RESTStatisticService(client: client)
    public private(set) lazy var transactionService: TransactionService = RESTTransactionService(client: client)
}
