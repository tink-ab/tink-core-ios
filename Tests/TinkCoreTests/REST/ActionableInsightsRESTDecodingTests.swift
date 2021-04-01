import XCTest
@testable import TinkCore

class ActionableInsightsRESTDecodingTests: XCTestCase {
    let decoder = JSONDecoder()

    override func setUp() {
        decoder.dateDecodingStrategy = .millisecondsSince1970
    }

    func testDecodingActionableInsight() throws {
        let json = """
        {
          "id" : "05e9068571064c899ddfe23daf3161da",
          "userId" : "af90cb2fa63d48fab3642ef4c0620bde",
          "type" : "ACCOUNT_BALANCE_LOW",
          "title" : "Your balance on Checking Account tink is low",
          "description" : "The balance on your Checking Account tink is low. Do you want to transfer money to this account?",
          "data" : {
            "accountId" : "99ebf04084cf40d9ac768092bee6a7d2",
            "balance" : {
              "currencyCode" : "SEK",
              "amount" : 925.96
            },
            "type" : "ACCOUNT_BALANCE_LOW"
          },
          "createdTime" : 1580134199275,
          "insightActions" : [ {
            "label" : "Make transfer",
            "data" : {
              "sourceAccount" : null,
              "destinationAccount" : "se://1299925966870660?name=testAccount",
              "amount" : null,
              "type" : "CREATE_TRANSFER"
            }
          }, {
            "label" : "No, not now",
            "data" : {
              "type" : "DISMISS"
            }
          } ]
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTActionableInsight.self, from: data)

        XCTAssertEqual(insight.id, "05e9068571064c899ddfe23daf3161da")
        XCTAssertEqual(insight.userId, "af90cb2fa63d48fab3642ef4c0620bde")
        XCTAssertEqual(insight.type, .accountBalanceLow)
        XCTAssertEqual(insight.title, "Your balance on Checking Account tink is low")
        XCTAssertEqual(insight.description, "The balance on your Checking Account tink is low. Do you want to transfer money to this account?")
        if case .accountBalanceLow(let data) = insight.data {
            XCTAssertEqual(data.accountId, "99ebf04084cf40d9ac768092bee6a7d2")
            XCTAssertEqual(data.balance.amount, 925.96)
            XCTAssertEqual(data.balance.currencyCode, "SEK")
        } else {
            XCTFail("No account balance low data")
        }
        XCTAssertEqual(insight.createdTime, Date(timeIntervalSince1970: 1_580_134_199.275))

        XCTAssertEqual(insight.insightActions?.count, 2)

        if let action = insight.insightActions?.first {
            XCTAssertEqual(action.label, "Make transfer")
            if case .createTransfer(let transfer) = action.data {
                XCTAssertNil(transfer.sourceAccount)
                XCTAssertEqual(transfer.destinationAccount, URL(string: "se://1299925966870660?name=testAccount")!)
                XCTAssertNil(transfer.amount)
            } else {
                XCTFail("No create transfer data")
            }
        }

        if let action = insight.insightActions?.last {
            XCTAssertEqual(action.label, "No, not now")
            if case .dismiss = action.data {
                XCTAssertTrue(true)
            } else {
                XCTFail("No create transfer data")
            }
        }
    }

    func testDecodingUnknownActionableInsight() throws {
        let json = """
        [
          {
            "id" : "05e9068571064c899ddfe23daf3161da",
            "userId" : "af90cb2fa63d48fab3642ef4c0620bde",
            "type" : "ACCOUNT_BALANCE_LOW",
            "title" : "Your balance on Checking Account tink is low",
            "description" : "The balance on your Checking Account tink is low. Do you want to transfer money to this account?",
            "data" : {
              "accountId" : "99ebf04084cf40d9ac768092bee6a7d2",
              "balance" : {
                "currencyCode" : "SEK",
                "amount" : 925.96
              },
              "type" : "ACCOUNT_BALANCE_LOW"
            },
            "createdTime" : 1580134199275,
            "insightActions" : [ {
              "label" : "Make transfer",
              "data" : {
                "sourceAccount" : null,
                "destinationAccount" : "se://1299925966870660?name=testAccount",
                "amount" : null,
                "type" : "CREATE_TRANSFER"
              }
            }, {
              "label" : "No, not now",
              "data" : {
                "type" : "DISMISS"
              }
            } ]
          }, {
            "id" : "4e82e15158fcefa117225117d9c2f547",
            "userId" : "af90cb2fa63d48fab3642ef4c0620bde",
            "type" : "TRIPLE_UNCATEGORIZED_TRANSACTION",
            "title" : "We found three transactions without category!",
            "description" : "Do you want to categorize it?",
            "data" : {
              "transactionIds" : ["f1875513221d42ad9a0890d10772cd44", "8b5f77f0efa240efad24c74e63802b9e", "8a6ff5f053234fea940e85cadbcaf796"],
              "type" : "TRIPLE_UNCATEGORIZED_TRANSACTION"
            },
            "createdTime" : 1580197373242,
            "insightActions" : [ {
              "label" : "Categorize",
              "data" : {
                "transactionId" : "500b03517ce74eaa87e8c21bab9ca106",
                "type" : "CATEGORIZE_THREE_EXPENSE"
              }
            }, {
              "label" : "No, not now",
              "data" : {
                "type" : "DISMISS"
              }
            } ]
          }, {
            "id" : "a8aca34acb6b493bbba49e36b6a648de",
            "userId" : "af90cb2fa63d48fab3642ef4c0620bde",
            "type" : "BUDGET_OVERSPENT",
            "title" : "You missed your Shopping budget",
            "description" : "Better luck next time!",
            "data" : {
              "budgetId" : "687d274aa2074826a8bc0240617039d3",
              "budgetPeriod" : {
                "start" : 1577059200000,
                "end" : 1579823999000,
                "spentAmount" : {
                  "currencyCode" : "SEK",
                  "amount" : 593780.1699999999
                },
                "budgetAmount" : {
                  "currencyCode" : "SEK",
                  "amount" : 500000.0
                }
              },
              "type" : "BUDGET_OVERSPENT"
            },
            "createdTime" : 1577955365279,
            "insightActions" : [ {
              "label" : "See details",
              "data" : {
                "budgetId" : "687d274aa2074826a8bc0240617039d3",
                "budgetPeriodStartTime" : 1577059200000,
                "type" : "VIEW_BUDGET"
              }
            }, {
              "label" : "Archive",
              "data" : {
                "type" : "DISMISS"
              }
            } ]
          }
        ]

        """

        let data = json.data(using: .utf8)!

        let insights = try decoder.decode([RESTActionableInsight].self, from: data)

        XCTAssertEqual(insights.count, 3)
    }

    func testDecodingMonthlyActionableInsight() throws {
        let json = """
        {
          "id" : "d07bdf771b6c49da89532aba07abbeb6",
          "userId" : "af90cb2fa63d48fab3642ef4c0620bde",
          "type" : "MONTHLY_SUMMARY_EXPENSES_BY_CATEGORY",
          "title" : "Here’s your spent amount per category last month",
          "description" : "You spent the most on these categories last month",
          "data" : {
            "month" : {
                "year" : 2020,
                "month" : 1
            },
            "expensesByCategory" : [ {
              "categoryCode" : "expenses:shopping.electronics",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 604357.0
              }
            }, {
              "categoryCode" : "expenses:house.fitment",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 109870.0
              }
            }, {
              "categoryCode" : "expenses:food.restaurants",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 32958.0
              }
            }, {
              "categoryCode" : "expenses:shopping.clothes",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 32137.0
              }
            }, {
              "categoryCode" : "expenses:misc.uncategorized",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 8242.97
              }
            }, {
              "categoryCode" : "expenses:shopping.hobby",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 1694.0
              }
            }, {
              "categoryCode" : "expenses:home.communications",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 59.94
              }
            }, {
              "categoryCode" : "expenses:shopping.other",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 75470.72
              }
            }, {
              "categoryCode" : "expenses:food.coffee",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 8500.0
              }
            } ],
            "type" : "MONTHLY_SUMMARY_EXPENSES_BY_CATEGORY"
          },
          "createdTime" : 1580975468149,
          "insightActions" : [ {
            "label" : "See details",
            "data" : {
              "transactionIdsByCategory" : {
                "expenses:misc.uncategorized" : {
                  "transactionIds" : [ "b1de2045639b45a4ac42135683a116a0", "97391585050a4211b330bf55eff51723", "e55a825810904beab6c6aac700c1f6c9", "da579a18151b47458c11c3d02ccb9649", "500b03517ce74eaa87e8c21bab9ca106", "76c38bb39c094d349e9655004a8b1fa2", "9a47c62cbf0d4269972beca470715ee0", "3b41bcd6c06f477f905ccf89f11a43ee", "25824a7bb7f248ae9b7c44915558c2ae", "8318b6f821b14134961bb6f0f3f9fb85", "477667fe65254b7f9d1dc88023ce42ec", "5014bb06c67e4d86a5a3dc6d5bc994e6", "fdc7bf04aef54d1b8121107aa58bc84f", "fe028e337b794ab6b1c2b23bbc8c0f77", "285c3795315147c5ad84f937650e51cd", "d832ac4982f54ddf8a09905df6bd0c38" ]
                },
                "expenses:food.coffee" : {
                  "transactionIds" : [ "3ea2a3f5ba9e47aea196f5ba1ea45581", "70645dcc43ad4371a96e8aeb1949712a", "40e8795ee9ce4d6090fa34ffafb323e1", "573c140b1ab344cb8861e1e3d7ed2b48", "4ac11bee433444ebb4d9a6baa8f8e64a", "b6acc3484559489bada1b6c4aa8506a0", "f1875513221d42ad9a0890d10772cd44", "8b5f77f0efa240efad24c74e63802b9e", "8a6ff5f053234fea940e85cadbcaf796", "6d86b8ad7332407eb4a89b155079123e", "ec30fa9245dc40a6a42d0d4451a80ff3", "62324c059e4e452abbb1f88f376757f3", "e9571bb30078445e9ef16fcc2572d8b1", "3b9f31859a544cdb84f9d150175406c2", "af6cc13decb74a76bb28f88c1694a100", "e870f3d15f434e55abe42d33dbd0d83f", "50781ca57072440d8aec8de3b8ae3403", "7cc012e5d6aa447c9b7c3c3b41368353" ]
                },
                "expenses:shopping.hobby" : {
                  "transactionIds" : [ "42574d4df4384c39a2aa49de83e3b6e6", "d3758aae656a42e5bac4d6d2a61ece1a", "ef470328fda64bb38171e2a1daef195f", "6b06a284a87541fa993dc87b69c9c1f5", "5f883a7a77074eb8b39b3f481a8a0e5d", "781f1da7a6c64d10ac99d71d5ce6a87f" ]
                },
                "expenses:shopping.other" : {
                  "transactionIds" : [ "72fd4db70908453191dadd5cefafb656", "e1bc2e421bcd4d8488b85c73672c261b", "60c1ac75e5db4171a205411cc9006665", "f906a97369e245368dc69b9b557e875d", "f519a59cec7642edaf8ecf2229e3cbfd", "2752c66622dd471c994f87bbf577d5e5", "19b82099d64a414cb45a9d0dc89fd965", "a7cca7b90ec74892a245f60970922773", "c1161f85757d4696b2db8ec4ddb289c8", "1e58cd3bcf084945b3c2086dba1ca282", "34e87220038b4080a8767d0728c5f1f5", "9ee9cad643e94beea9162ac4c2af3f1f", "0649bc52c10c42c39ae852e6f13a4fab", "0843eb91fec546299f41d93892f29f91", "8a6d9a33a79e4b30868227051c5ebc9f", "b2604349728c408a932cdd43b007e451", "be669ec063224d39b350d7225f2450a5" ]
                },
                "expenses:shopping.electronics" : {
                  "transactionIds" : [ "ac4de5150d8b4cb38a0d97d956df1278", "fc8d2e6c03d24677acebd94bc6e9e971", "231c643762d246ce8f3ff18dd839c26b", "a7ea2adc53de48c99e9399aefd8a8bf9", "f279a611749c450d89eba61ab58ca1dc", "b55e92bf90d04ab4af448915d28bf737", "d1607b1641154c858ff6606e87a3dc51", "98a8a379a7dd40e294f7d2d124d5572c", "ab1a1f53c2c0448e813fc03df38fabbf", "2ab828a1ce2649bc840509ada8edaa56", "8b49ede083d240a7a19aebe9fd6300dd", "60be4971f8844fe485a1e65a94d54f94", "647649fd407e4633bd1002b3aa8befcd", "9232993dc11645e7b7af782ada537a11", "4a1f71172caa4ec68391cd5307225132", "b53f887099fa4333b866a1a57cb67c9c", "e9e1aee28a624cc79dd164f96518b8f1", "483b11039a3a4a8cb5e47573e8c05a0b", "7ee203706873451bb2f1b66e91197b56", "ce586bbc1d5d4074a28cbe840e0b3936" ]
                },
                "expenses:food.restaurants" : {
                  "transactionIds" : [ "3a0ecb6b6b804cfe9961f0f5d0a69524", "a76739e1994242bfa63511ee6886cd3e", "37e31724f2be4d26844fac4cf16b07d2", "e67a4e8b751f41a3b07ef1ad4240662d", "8640364c46b94dc4949ab4b12e3b90d2", "faa9f2c8d15d4adcb296c45221cc1b6d", "92b5b803afbb4dd58d633ef63e4b741b", "5e11590bbb6a44ba94a464a98acc271f", "e82ae8e0afb547acb3708778ce5a5c4b", "4f6681174fca4982a40caa185994dce8", "d59c02db755a4d8397a7e50e8ecb1600", "82836e99fcfd481f86a9e76171326f9b", "4749878c6e6447099fb4bd84a4b5628d", "d4f93b93ce9945a684c9e1f7e8807f8a", "f5b0e52e7f714c8ba5ba338a5f61a7e3", "10c955702ac647fba8e00699240170f5", "3cdf6db36e3e44e5929c6ad9d46b3ffc", "eb1d06f2f2794b84b191bf0e760e4d17", "6197268501374ef3b62c6776f3b90c49", "bda11a8ad1b84bc4bdfcd2d7d269d76c", "a42da8b7e80b4309b76c54669ef322a5", "ddd741132a56442394b5f18584175233", "116baa2471154c9bbb764da44e4b6fb8", "96d66022422e4526ae81d7e233c5f8e9", "0e00e0a4995a49dbaae9b6a4fbb804a3", "37de7706ae364470bfe1fd8538879a39", "f58d3edbfaa44f80b2339a05d31ec11c", "95f1e37f977447d4b0ac79389572fb57", "4a81aca6f2504d95b3e862530aed7250", "f34a221d4c9b41daa1faebc920a76cb5", "f960f3df85354215bbc251e2308fc10e", "bb191e70a39642cf8337ac9b4f2f341c", "1e32e37af97e4d6496763762980f2e64", "40019b1ccab34d599ab19d05952ccb60", "82c41e33f478471780bca959c1449cab", "ce068c3ea79c4465a46a7574c7961923", "4bce2b32380e4bb8b87d72ac8a5dc68f", "d1c10d3c16974cf99d86525f26c4270c", "f1a620d608ff40fe8e9a05ad1d235e26", "8c47129caf56479e9cb11cd900f022e1", "bc82569a222c436db3d045cec0af1d58", "14c2f9b5fcdd46a380c43227a6720de9", "17a43751aacf408586b8c759caeb4ddb" ]
                },
                "expenses:home.communications" : {
                  "transactionIds" : [ "33f8553f52714e93a262f17316bce7be", "4979e6aff61a44cbaae41a1dc9f1c50b", "79c2bcbff6ee4c84a1a97b378d15659d", "cbd81d4517574211a9bd0e990012ae33", "d43ad864bc6247b5b81531f32b1d341a", "db42bca38c414804bdfc95fb69f87807" ]
                },
                "expenses:shopping.clothes" : {
                  "transactionIds" : [ "ec18bce3dca546a99c9d7da672d3f87f", "2ffdbc83001f432f97d5e49c3eb27137", "24dcee3451704c35981fd0b1d7de7d77", "6f9bf56421a3435a8506dd766d4c03f7", "8dda0c8242bf4327a041ed71f9c2ebec", "9ca2ea7d16c2412aa394000911f779c9", "51f4fa1b3d0f44939b79ca2a3dc5c58e", "ef157b26810d4b0ca24cd938e2213249", "f40fadbdc5494324b14535b0e2b368be", "6e17e5a3574d4b268ade53469d5219ff", "6dd4900ac2d2491e8dc3f47bc81e81ff", "e528a513b39844caa075e82865805759", "3ceb27a76c4f40deb2f0b0d51cad5b14", "7b59017228e0449e807a4a1592be8d62", "e35d7df9c4504d52af27f40b6bc378e7", "ec62d66839c64dd4b4998b18a4d2201e", "88834ec05eb44e68a24455f7b59872ef" ]
                },
                "expenses:house.fitment" : {
                  "transactionIds" : [ "3694a78bbd0248d1a56f29a1ba5490d7", "7e2fd0f0fc174410ab314cccfb24d7b2", "ab349c95d41642238d110d1292ee0438", "8ece2db3f3e941768e1b7792946d3b7f", "115279c6440b4cc1856aca969222043f", "098f7be5bd7e41c18e91c3b5e4dda71d", "baffcb88876741cfbf6d7fafe2757c1c", "499d5bbe3a684852a299610607fd2874", "7a5ce4bb70914209b35931f6eceb8dce", "8a525c8f99cf40d089e4958a9c54b19d", "90a2c672d8e94a19a909f1c9f06b5716", "a167efd60328477fae5706e5d0b2d409", "571fd009637d4c6aac2fc3607d2c1840", "25fc11666df74afd8978666b3e22cb7f", "d0732882643442e4b9a639b141e91adf", "9b1daa2cca7e4428aeae6141c181ccb0" ]
                }
              },
              "type" : "VIEW_TRANSACTIONS_BY_CATEGORY"
            }
          }, {
            "label" : "Archive",
            "data" : {
              "type" : "DISMISS"
            }
          } ]
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTActionableInsight.self, from: data)

        XCTAssertEqual(insight.id, "d07bdf771b6c49da89532aba07abbeb6")
        XCTAssertEqual(insight.userId, "af90cb2fa63d48fab3642ef4c0620bde")
        XCTAssertEqual(insight.type, .monthlySummaryExpensesByCategory)
        XCTAssertEqual(insight.title, "Here’s your spent amount per category last month")
        XCTAssertEqual(insight.description, "You spent the most on these categories last month")
        XCTAssertEqual(insight.createdTime, Date(timeIntervalSince1970: 1_580_975_468.149))
        if case .monthlySummaryExpensesByCategory(let data) = insight.data {
            XCTAssertEqual(data.month.year, 2020)
            XCTAssertEqual(data.month.month, 1)
            XCTAssertEqual(data.expensesByCategory.count, 9)
            if let categorySpending = data.expensesByCategory.first {
                XCTAssertEqual(categorySpending.categoryCode, "expenses:shopping.electronics")
                XCTAssertEqual(categorySpending.spentAmount.amount, 604_357.0)
                XCTAssertEqual(categorySpending.spentAmount.currencyCode, "SEK")
            }
        } else {
            XCTFail("No monthly summary data")
        }
    }

    func testDecodingActionableInsightWithWeeklySummaryData() throws {
        let json = """
        {
          "id" : "ff77c7023ee34cc18a3d7ae3a9307c5b",
          "userId" : "af90cb2fa63d48fab3642ef4c0620bde",
          "type" : "WEEKLY_SUMMARY_EXPENSES_BY_DAY",
          "title" : "Here’s your spending per day last week",
          "description" : "Expenses this week",
          "data" : {
            "week" : {
              "year" : 2020,
              "week" : 4
            },
            "expenseStatisticsByDay" : [
              {
                "date": [2020, 1, 26],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 123846.48
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 33983.49
                  }
                }
              },
              {
                "date": [2020, 1, 25],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 2573.0
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 5933.49
                  }
                }
              },
              {
                "date": [2020, 1, 24],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 27820.5
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 14587.94
                  }
                }
              },
              {
                "date": [2020, 1, 23],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 8944.97
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 16721.61
                  }
                }
              },
              {
                "date": [2020, 1, 22],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 9595.98
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 12590.36
                  }
                }
              },
              {
                "date": [2020, 1, 21],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 21483.49
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 16933.62
                  }
                }
              },
              {
                "date": [2020, 1, 20],
                "expenseStatistics": {
                  "totalAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 4174.5
                  },
                  "averageAmount" : {
                    "currencyCode" : "SEK",
                    "amount" : 18765.43
                  }
                }
              }
            ],
            "type" : "WEEKLY_SUMMARY_EXPENSES_BY_DAY"
          },
          "createdTime" : 1580134199995,
          "insightActions" : [ {
            "label" : "OK, good to know",
            "data" : {
              "type" : "ACKNOWLEDGE"
            }
          } ]
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTActionableInsight.self, from: data)

        XCTAssertEqual(insight.title, "Here’s your spending per day last week")
        switch insight.data {
        case .weeklySummaryExpensesByDay(let data):
            XCTAssertEqual(data.week.year, 2020)
            XCTAssertEqual(data.week.week, 4)
            XCTAssertEqual(data.expenseStatisticsByDay.count, 7)
            if let day = data.expenseStatisticsByDay.first {
                XCTAssertEqual(day.date, [2020, 01, 26])
                XCTAssertEqual(day.expenseStatistics.totalAmount.amount, 123_846.48)
                XCTAssertEqual(day.expenseStatistics.totalAmount.currencyCode, "SEK")
                XCTAssertEqual(day.expenseStatistics.averageAmount.amount, 33983.49)
                XCTAssertEqual(day.expenseStatistics.averageAmount.currencyCode, "SEK")
            } else {
                XCTFail("No weekly summary day data")
            }
        default:
            XCTFail("No weekly summary data")
        }
    }

    func testDecodingActionableInsightWithMonthlySummaryData() throws {
        let json = """
         {
          "id" : "6916936260974eafb06cb45014d44ffe",
          "userId" : "a66e0c581566471a9a02f6e71694b5be",
          "type" : "MONTHLY_SUMMARY_EXPENSES_BY_CATEGORY",
          "title" : "Here’s your spent amount per category last month",
          "description" : "You spent the most on these categories last month.",
          "data" : {
            "month" : {
              "year": 2020,
              "month": 2
            },
            "expensesByCategory" : [ {
              "categoryCode" : "expenses:shopping.electronics",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 572919.0
              }
            }, {
              "categoryCode" : "expenses:house.fitment",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 97761.0
              }
            }, {
              "categoryCode" : "expenses:food.restaurants",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 21955.0
              }
            }, {
              "categoryCode" : "expenses:shopping.clothes",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 31829.0
              }
            }, {
              "categoryCode" : "expenses:misc.uncategorized",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 12586.98
              }
            }, {
              "categoryCode" : "expenses:home.communications",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 39.96
              }
            }, {
              "categoryCode" : "expenses:food.coffee",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 9974.0
              }
            }, {
              "categoryCode" : "expenses:shopping.other",
              "spentAmount" : {
                "currencyCode" : "SEK",
                "amount" : 60632.71
              }
            } ],
            "type" : "MONTHLY_SUMMARY_EXPENSES_BY_CATEGORY"
          },
          "createdTime" : 1583141984354,
          "insightActions" : [ {
            "label" : "See details",
            "data" : {
              "transactionIdsByCategory" : {
                "expenses:misc.uncategorized" : {
                  "transactionIds" : [ "beedd528d19249808513b0e300a46a54", "eb7df745d3ee4c9683a43c4c4ae7ae5c", "0dac3a49fe484033956d2d57edf6e885", "ebf484d83ae74551986a73f71fdc4a60", "d19e1d27497d49a4a0a161702810be61", "334a67e1eda9413f9b19477901f0cd1d", "5f14a4e5e41c4569bf17e2a20e9812fd", "b184636f9d974ca9bd8a34dd1dd018d4", "ccfe926419b1471baacb474d10ce6b74", "e3784e1cd524426097107719383836cf", "ef26386546fe43f7b0c875c498357883", "2c511c3fbdcf4557a986a7faaeb7bbbe", "91c5f60f270547cf963d6238564fafdb", "ef8a0879050f45e186c0762189deaf87", "7d0923fe7e4d4e0cbc230a8bb6b8eccb", "517e24538ba04eedbe013407306ffe83", "337fa23846fa4c4da049706c55390812", "c85aa4e48e1b4b0dad8a1bfa69e8a4b8", "eec3fed49c11411c97199023d1aea18f", "fdf12509b1564424974909c545972dac", "a10d4911397045baaee75f591536ad02", "8a0841e7e8d04abbaaf68984b6a620bf" ]
                },
                "expenses:food.coffee" : {
                  "transactionIds" : [ "7753f3b2c3f44e15844356c5e8c79650", "ac26982ad36d49a8aada00c5970b7efc", "8793f9620b68437e92aefa6a3dde38d0", "f4dae5b7da8d44e4b2d55964abdfa3e6", "70b94f420dc44f83b1b734cfd1886eda", "52caf0863a7f44ee89d92cef92a43b5a", "062f9e6d1ab24b92be7eb6624c85c33b", "01adbea4a2b145ab8e638ee60aaa0b34", "2de24149d8984c02984c57ea4bdbe38d", "169fc829d46445e291de548ac8981c35", "25742865a372451db03af67f60f2bf9c", "45e147004d474b46a79c6594eb5c0212", "f1a4dfbb8ff549f7a468f5f9e0e56cc6", "97681201a89e4a8aa84d32497427c81d", "6e2f45a4ed08465b88d85f372dff7655", "842b60a13e5e46c1973f8294e00f3783", "441593a650264aa4a5276dc0d2ab2cb5", "7c0d221fcfe84c7eb64f79cbbd154547", "bcc456b7c82548568a839fcc343ed90e", "0496bec595ae4875b6a0446e1131171c", "aa019900d36a4847bfbbc9de37a3800a", "39e16310926e45798fd9c871e7d78c3c" ]
                },
                "expenses:shopping.other" : {
                  "transactionIds" : [ "391e735eb90d492f8d4b49fd1dd05649", "964ad0c4f1a84298a59a35c003c476ea", "5173d4505c46423c9e0fc0a41dbd112a", "fb668993517b447791f329ef931a51fc", "abc5f3eeb28343019b2f22ecf5c9e822", "b8b398226feb4d01b35b3809e99ed0ee", "7231f18fbf6d4b66a1492e00cd1f51e8", "b891597541f4485fae02ea3cafbfe66f", "ef1629dde65143cba8ef8bd125dca713", "32d75ac7d9f445a48a8f1f164157bf6d", "b84b3652114843819ae124737f1af22b", "2b5564aa16e8416d8f37fdb879ee771f", "8d0edad4e6cd4348b6dc6095323561b9", "f2f43bc071cb4b4886b569ecbc83ebe7", "fef02ed2daf24d549c3bf2630723c0ae", "096957a5523944cb945cfcec074bc89e" ]
                },
                "expenses:shopping.electronics" : {
                  "transactionIds" : [ "42de4c39b85045169bcd9359a80ce8ac", "57997523aaeb40f286ba5eeb3de82d4b", "934b7b15ec384572bbf20addbb5e0a67", "5ba7a3a84eab40a8a59ba3fff36cc3a1", "34c6d7f1f7874d9a89a77f5caecd1787", "ce45aceaa50c46668686a5d20a3d8261", "bd0ffee98bbe4f47b97f3df456cf38f5", "dde205311bb1433db606ebf7730187f2", "e12efdfa21fb485fa52d475cca03803f", "131d0533004243f28295a6be28e1b186", "0f23a66b619c4fa0a77c1aab651e1d39", "5080428eb2ff41789e3d6bb5c870f72e", "0c2be75e438c46cfa79842b997f750c1", "ddc3b6ecdc3d4ce1b83963d55e2593e4", "f9e7e8c2d9c84af88c97a2f475b28d73" ]
                },
                "expenses:food.restaurants" : {
                  "transactionIds" : [ "4ef26e4adaf7453ba23726fc06a1c875", "c4cec425b2754aeeb1fbe7115024a617", "2a931f1b6ba04dde97b1fc550aa1ed33", "1b09aa196c064aed859c6b0a6fd349e2", "ab1bda32f48c412899c92c18140440f0", "a26114950c054a8e93744e2d1b9b793c", "03890cfbd746424a8893a3f8d96c50f1", "51fa9bad3a2d4a1ca353057c9b1324c4", "cfe2824fb54a40fcb27cb3204665df31", "c94490390cd0489eb530e6229517b61d", "e08964e4b1644b859ebeb53662b3f451", "1e4c02c3388645f69c8472bdda726b73", "18abcb2504384d5a88e55908a86e99b3", "452dbef8d6974b8cad52f04c0e9a9d4e", "fcb9a028ff224b05a078a98745ed5b04", "771eb7d8765143c2b9dd57757a607976", "582632352c0048d4acff3859403a7683", "e66438c87ce04264ab9203e6ea6a6949", "39e34d0088c74d89a7c3dfac3500fc06", "d74196c0a5f04958a50486a658365a3e", "64c7ce85575e4041b3a74bb2b511acb4", "72b76bfe8ecb46a4b731829265f7486e", "229f312bc30c4faa8c512dd592302ac1", "a29c90a84e784a2f9d27c6781cffae3f", "cc075ebad8654db884ebd4933353d237", "f3d0bcb733f64deb9560448f3e49dd90", "2392a234fa2a46caacbb6c478ea8c222", "5bb1831fda694bb9a94dbca1a2e11e66", "790b28c838d04eb5917aa2f4a03aa6a4", "283ca200fbec4928bb38f510f3bd65ca", "872a1991384f484d8885f2daa5c9606a", "4724848989f44bbb94a6ff3f1776292a", "84dae848e86148d5a53e38c59475918d", "a3247924af4341b5a79a4d987cd28fb2", "b5ba2361925940f89629485a2695ce88", "c02e0d77ea124335bdd4a11eb06dbb07", "61a4e6cf6e994ddcb73fff68b42c33fe", "2fb9c7b9d7c448ad8d7b6892a7836f23" ]
                },
                "expenses:home.communications" : {
                  "transactionIds" : [ "702a8e4ca6e143b0b9a60a22f42bc082", "c198d116c6744f1b94b5639df33efd4b", "e07f3e0449654183846ab0b04e53b4f7", "f3e6f4d2066745ccaef7094b39250dc9" ]
                },
                "expenses:shopping.clothes" : {
                  "transactionIds" : [ "bc06e8ae21d64609bd932719c7cdc572", "be937ddff3e94bf4a4721e9280515fb6", "e8d59aa82098463daf3ad6a934cfdc9d", "6f07c18aed334b29bad87cde4c9e2350", "c17d6a50f52e49afabc40030eb47a03e", "7f95bb92499647e98d3f8b0493c28724", "69ac19da57434afea7375f51fb290f0c", "517b3efd759a4bd68a3ab1c782347b2a", "e795f6da6d684e409493fc873d1976aa", "e99b7fc9719a4ae4b7374fda6a1b892f", "65a6a06e034d45cda71ee57bc8233275", "7b6f36c2bb0c41f3ab69ca2fd1655f7d", "84a7f83ba5654e8f9b1002bb8db12afc", "6502ad34bdf64b83a703246e72117b7d", "4bf95c09457e45398db14cee36bcddb7", "e5e7822865764ffc9a234e6014e98cef", "39ea8c6dbcf346c481701c719221018c" ]
                },
                "expenses:house.fitment" : {
                  "transactionIds" : [ "065040e15d1c44e48a4a3b30a64965b4", "575a582d10ac4836b6dae90bffe6f3f0", "b5ecfa9c986e471f9654bb861be007e4", "d08c084cf1f54e84a9148e3b7d118fec", "d9bf466f1b524995a1f34f2dc0f22b29", "7cf009281ac14f7cba3cbee084f43084", "19b6f4e01dd14485b28814212338aab5", "bcb659951de34d5098e4d89d7f1e45fb", "7717b87a85aa4832ba1c1e7d9bb8059b", "5ad158d07c644ac78d2d0d233b8bd60b", "3d8af87242434d0daac551081588f69f", "62359cdd43e44e818f368e274c8ad5fe", "683a6d2e7ceb4fcc96a8404ad98579f0", "cbe8b19d4151478089ded95a6726f47e" ]
                }
              },
              "type" : "VIEW_TRANSACTIONS_BY_CATEGORY"
            }
          }, {
            "label" : "Archive",
            "data" : {
              "type" : "DISMISS"
            }
          } ]
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTActionableInsight.self, from: data)

        XCTAssertEqual(insight.title, "Here’s your spent amount per category last month")
        switch insight.data {
        case .monthlySummaryExpensesByCategory(let data):
            XCTAssertEqual(data.month.year, 2020)
            XCTAssertEqual(data.month.month, 2)
            XCTAssertEqual(data.expensesByCategory.count, 8)
            if let expenses = data.expensesByCategory.first {
                XCTAssertEqual(expenses.categoryCode, "expenses:shopping.electronics")
                XCTAssertEqual(expenses.spentAmount.amount, 572_919.0)
                XCTAssertEqual(expenses.spentAmount.currencyCode, "SEK")
            } else {
                XCTFail("No monthly summary category data")
            }
        default:
            XCTFail("No monthly summary data")
        }
    }

    func testDecodingCreateBudgetSuggestionAction() throws {
        let json = """
        {
          "label" : "Create Budget",
          "data" : {
            "budgetSuggestion" : {
              "filter" : {
                "accounts" : null,
                "categories" : [ "expenses:food.restaurants" ]
              },
              "periodicityType" : "BUDGET_PERIODICITY_TYPE_RECURRING",
              "oneOffPeriodicityData" : null,
              "recurringPeriodicityData" : {
                "periodUnit" : "MONTH"
              },
              "amount" : {
                "currencyCode" : "SEK",
                "amount" : 12210.3
              }
            },
            "type" : "CREATE_BUDGET"
          }
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTInsightProposedAction.self, from: data)

        if case .createBudget(let createBudget) = insight.data {
            XCTAssertNil(createBudget.budgetSuggestion.filter?.accounts)
            XCTAssertEqual(createBudget.budgetSuggestion.filter?.categories?.first, "expenses:food.restaurants")
            XCTAssertEqual(createBudget.budgetSuggestion.periodicityType, .recurring)
            XCTAssertNil(createBudget.budgetSuggestion.oneOffPeriodicityData)
            XCTAssertEqual(createBudget.budgetSuggestion.recurringPeriodicityData?.periodUnit, .month)
            XCTAssertEqual(createBudget.budgetSuggestion.amount?.amount, 12210.3)
            XCTAssertEqual(createBudget.budgetSuggestion.amount?.currencyCode, "SEK")
        } else {
            XCTFail("Expected create budget")
        }
    }

    func testDecodingInsightSpendingByCategoryIncreased() throws {
        let json = """
        {
        "id": "a76fad32c16b457ab9b1c9dd15b4687b",
        "userId": "d1fa9a8628244ab9920baa93a76e702d",
        "type": "SPENDING_BY_CATEGORY_INCREASED",
        "title": "Your Coffee & Snacks expenses went up by 229% since last month",
        "description": "Want to take a closer look at your Coffee & Snacks expenses in February?",
        "data": {
        "lastMonth": {
            "year": 2021,
            "month": 2
        },
        "percentage": 229.0,
        "category": {
            "displayName": "Coffee & Snacks",
            "id": "63a7e66150d44c67a3380265c86e1c26",
            "code": "expenses:food.coffee"
        },
        "lastMonthSpending": {
            "currencyCode": "EUR",
            "amount": 61.9
        },
        "twoMonthsAgoSpending": {
            "currencyCode": "EUR",
            "amount": 18.79
        },
        "type": "SPENDING_BY_CATEGORY_INCREASED"
        },
        "createdTime": 1615807101753,
        "insightActions": [{
        "label": "See Details",
        "data": {
            "transactionIds": [{
                "id": "0a759d4c990c49c08233b69587756d69",
                "type": "TRANSACTION"
            }, {
                "id": "387031d5f3a043a48e96ff90f1b355b4",
                "type": "TRANSACTION"
            }, {
                "id": "e95f3f1a5634494ea2edd55346bfe013",
                "type": "TRANSACTION"
            }],
            "type": "VIEW_TRANSACTIONS"
        }
        }, {
        "label": "Dismiss",
        "data": {
            "type": "DISMISS"
        }
        }]
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTActionableInsight.self, from: data)

        if case .spendingByCategoryIncreased(let spendingByCategoryIncreased) = insight.data {
            XCTAssertNotNil(spendingByCategoryIncreased)
            XCTAssertEqual(spendingByCategoryIncreased.lastMonth.year, 2021)
            XCTAssertEqual(spendingByCategoryIncreased.lastMonth.month, 2)
            XCTAssertEqual(spendingByCategoryIncreased.percentage, 229)
        } else {
            XCTFail("Expected spendingByCategoryIncreased")
        }

        XCTAssertNotNil(insight.insightActions)
        XCTAssertEqual(insight.insightActions?.count ?? 0, 2)
        if case .viewTransactions(let viewTransactions) = insight.insightActions?.first?.data {
            XCTAssertEqual(viewTransactions.transactionIds.count, 3)
        } else {
            XCTFail("Expected viewTransactions")
        }
    }

    func testDecodingSpendingByPrimaryCategoryIncreasedAction() throws {
        let json = """
        {
        "id": "01fd2a17c0dd49d79fb195e6bf4978a9",
        "userId": "d1fa9a8628244ab9920baa93a76e702d",
        "type": "SPENDING_BY_PRIMARY_CATEGORY_INCREASED",
        "title": "Your Food & Drinks expenses went up by 19% since last month",
        "description": "Want to take a closer look at your Food & Drinks expenses in February?",
        "data": {
        "category": {
            "displayName": "Food & Drinks",
            "id": "47ea44117c6543178b3fefae8ffada52",
            "code": "expenses:food"
        },
        "lastMonthSpending": {
            "currencyCode": "EUR",
            "amount": 1477.23
        },
        "twoMonthsAgoSpending": {
            "currencyCode": "EUR",
            "amount": 1244.73
        },
        "lastMonth": {
            "year": 2021,
            "month": 2
        },
        "percentage": 19.0,
        "type": "SPENDING_BY_PRIMARY_CATEGORY_INCREASED"
        },
        "createdTime": 1615807101752,
        "insightActions": [{
        "label": "See Details",
        "data": {
            "transactionIdsByCategory": {
                "expenses:food": {
                    "transactionIds": []
                }
            },
            "type": "VIEW_TRANSACTIONS_BY_CATEGORY"
        }
        }, {
        "label": "Dismiss",
        "data": {
            "type": "DISMISS"
        }
        }]
        }
        """

        let data = json.data(using: .utf8)!

        let insight = try decoder.decode(RESTActionableInsight.self, from: data)

        if case .spendingByPrimaryCategoryIncreased(let spendingByCategoryIncreased) = insight.data {
            XCTAssertNotNil(spendingByCategoryIncreased)
            XCTAssertEqual(spendingByCategoryIncreased.lastMonth.year, 2021)
            XCTAssertEqual(spendingByCategoryIncreased.lastMonth.month, 2)
            XCTAssertEqual(spendingByCategoryIncreased.percentage, 19.0)
        } else {
            XCTFail("Expected spendingByCategoryIncreased")
        }

        XCTAssertNotNil(insight.insightActions)
        XCTAssertEqual(insight.insightActions?.count ?? 0, 2)
        if case .viewTransactionsByCategory(let viewTransactions) = insight.insightActions?.first?.data {
            XCTAssertEqual(viewTransactions.transactionIdsByCategory.count, 1)
        } else {
            XCTFail("Expected viewTransactionsByCategory")
        }
    }

    func testDecodingCreateTransferActionDataWithOnlyDestinationAccount() throws {
        let json = """
        {
          "sourceAccount" : null,
          "destinationAccount" : "1019-637004280640",
          "amount" : null,
          "sourceAccountNumber" : null,
          "destinationAccountNumber" : "1019-637004280640",
          "type" : "CREATE_TRANSFER"
        }
        """

        let data = json.data(using: .utf8)!

        let action = try decoder.decode(RESTInsightActionData.self, from: data)

        if case .createTransfer(let createTransfer) = action {
            XCTAssertNil(createTransfer.sourceAccount)
            XCTAssertEqual(createTransfer.destinationAccount, URL(string: "1019-637004280640"))
            XCTAssertNil(createTransfer.amount)
            XCTAssertNil(createTransfer.sourceAccountNumber)
            XCTAssertEqual(createTransfer.destinationAccountNumber, "1019-637004280640")
        } else {
            XCTFail("Expected create transfer action type")
        }
    }

    func testDecodingCreateTransferActionDataWithOnlySourceAccount() throws {
        let json = """
        {
          "sourceAccount" : "1299-925966870660",
          "destinationAccount" : null,
          "amount" : null,
          "sourceAccountNumber" : "1299-925966870660",
          "destinationAccountNumber" : null,
          "type" : "CREATE_TRANSFER"
        }
        """

        let data = json.data(using: .utf8)!

        let action = try decoder.decode(RESTInsightActionData.self, from: data)

        if case .createTransfer(let createTransfer) = action {
            XCTAssertEqual(createTransfer.sourceAccount, URL(string: "1299-925966870660"))
            XCTAssertNil(createTransfer.destinationAccount)
            XCTAssertNil(createTransfer.amount)
            XCTAssertNil(createTransfer.destinationAccountNumber)
            XCTAssertEqual(createTransfer.sourceAccountNumber, "1299-925966870660")
        } else {
            XCTFail("Expected create transfer action type")
        }
    }

    func testDecodingCreateTransferAction() throws {
        let json = """
        {
          "type": "CREATE_TRANSFER",
          "sourceAccount": "iban://SE9832691627751644451227",
          "destinationAccount": "iban://NL41INGB1822913977",
          "amount": {
            "currencyCode": "EUR",
            "amount": 30.00
          },
          "sourceAccountNumber": "1234567890",
          "destinationAccountNumber": "1234098765"
        }
        """

        let data = json.data(using: .utf8)!

        let action = try decoder.decode(RESTInsightActionData.self, from: data)

        if case .createTransfer(let createTransfer) = action {
            XCTAssertEqual(createTransfer.sourceAccount?.scheme, "iban")
            XCTAssertEqual(createTransfer.sourceAccount?.host, "SE9832691627751644451227")
            XCTAssertEqual(createTransfer.destinationAccount, URL(string: "iban://NL41INGB1822913977"))
            XCTAssertEqual(createTransfer.amount?.amount, 30.0)
            XCTAssertEqual(createTransfer.amount?.currencyCode, "EUR")
            XCTAssertEqual(createTransfer.sourceAccountNumber, "1234567890")
            XCTAssertEqual(createTransfer.destinationAccountNumber, "1234098765")
        } else {
            XCTFail("Expected create transfer action type")
        }

    }
}
