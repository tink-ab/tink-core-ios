@testable import TinkCore
import XCTest

class ConfigurationTests: XCTestCase {
    func testConfiguration() {
        let redirectURI = URL(string: "http://my-customer-app.com/authentication")!
        let configuration = try! Tink.Configuration(clientID: "abc", redirectURI: redirectURI, environment: .production)
        let link = Tink(configuration: configuration)
        XCTAssertNotNil(link.configuration)
    }

    func testConfigureTinkWithConfiguration() {
        let redirectURI = URL(string: "http://my-customer-app.com/authentication")!
        let configuration = try! Tink.Configuration(clientID: "abc", redirectURI: redirectURI, environment: .production)
        let link = Tink(configuration: configuration)
        XCTAssertEqual(link.configuration.appURI, URL(string: "http://my-customer-app.com/authentication")!)
    }

    func testConfigureWithoutRedirectURLHost() {
        let redirectURI = URL(string: "http-my-customer-app://")!
        do {
            _ = try Tink.Configuration(clientID: "abc", redirectURI: redirectURI, environment: .production)
            XCTFail("Cannot configure Tink with redriect url without host")
        } catch let urlError as URLError {
            XCTAssert(urlError.code == .cannotFindHost)
        } catch {
            XCTFail("Cannot configure Tink with redriect url without host")
        }
    }

    func testConfigureSharedTinkWithConfigurationWithAppURI() {
        let appURI = URL(string: "my-customer-app://authentication")!
        let configuration = try! Tink.Configuration(clientID: "abc", redirectURI: appURI, environment: .production)
        Tink.configure(with: configuration)
        XCTAssertEqual(Tink.shared.configuration.appURI, appURI)
    }
}
