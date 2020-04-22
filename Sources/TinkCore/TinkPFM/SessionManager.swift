import UIKit

final class SessionManager {
    let statisticsController: StatisticsController
    let transactionsController: TransactionsController
    let categoryController: CategoryController
    let accountController: AccountController
    private(set) lazy var actionableInsightController = ActionableInsightController(client: client, queue: queue)
    private(set) lazy var budgetController = BudgetController(client: client, queue: queue)

    private let client: Client
    private let queue: DispatchQueue
    private let observerToken = ObserverToken()

    private var fastDebouncer = Debouncer(seconds: 1)
    private var debouncer = Debouncer(seconds: 3)
    private var slowDebouncer = Debouncer(seconds: 10)
    private let storeGroup = DispatchGroup()

    private var cancellers: [AnyCanceller] = []

    init(client: Client) {
        self.client = client
        self.queue = DispatchQueue(label: "com.tink.TinkPFM.SessionManager.queue", qos: .userInitiated)

        self.statisticsController = StatisticsController(client: client, queue: queue)
        self.transactionsController = TransactionsController(client: client, queue: queue)
        self.categoryController = CategoryController(client: client, queue: queue)
        self.accountController = AccountController(client: client, queue: queue)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        transactionsController.addObserver(observerToken) { [weak self] event in
            if case .didUpdate = event {
                self?.fastDebouncer.debounce {
                    self?.statisticsController.update()
                }
                self?.debouncer.debounce {
                    self?.statisticsController.update()
                }
                self?.slowDebouncer.debounce {
                    self?.statisticsController.update()
                }
            }
        }
    }

    deinit {
        cancel()
    }

    func refresh() {
        let statisticsCanceller = statisticsController.update()
        let categoriesCanceller = categoryController.update()
        let accountCanceller = accountController.update()

        let latestTransactionsQuery = TransactionsQuery(
            sort: .date,
            order: .descending,
            limit: 25
        )
        let transactionsCanceller = transactionsController.fetchTransactions(query: latestTransactionsQuery) { _ in }

        if let callCanceller = statisticsCanceller as? URLSessionDataTask {
            cancellers.append(AnyCanceller(callCanceller))
        }
        if let callCanceller = categoriesCanceller as? URLSessionDataTask {
            cancellers.append(AnyCanceller(callCanceller))
        }
        if let callCanceller = accountCanceller as? URLSessionDataTask {
            cancellers.append(AnyCanceller(callCanceller))
        }
        if let callCanceller = transactionsCanceller as? URLSessionDataTask {
            cancellers.append(AnyCanceller(callCanceller))
        }
    }

    func reset() {
        statisticsController.reset()
        categoryController.reset()
        transactionsController.reset()
        accountController.reset()
        actionableInsightController.reset()
        budgetController.reset()
    }

    private func cancel() {
        cancellers.forEach { $0.cancel() }
    }

    @objc private func applicationDidEnterBackground() {
        cancel()
    }

    @objc private func applicationWillEnterForeground() {
        refresh()
    }
}
