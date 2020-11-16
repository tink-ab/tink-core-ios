import Foundation

final class RESTClient {
    let restURL: URL
    let behavior: ClientBehavior
    private let session: URLSession
    private let sessionDelegate: URLSessionDelegate?

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970 * 1000))
        }
        return encoder
    }()

    init(restURL: URL, certificates: String? = nil, behavior: ClientBehavior = EmptyClientBehavior()) {
        self.restURL = restURL
        self.behavior = behavior

        if let certificateData = certificates?.data(using: .utf8) {
            let certificates = [certificateData]
            self.sessionDelegate = CertificatePinningDelegate(certificates: certificates)
            self.session = URLSession(configuration: .ephemeral, delegate: sessionDelegate, delegateQueue: nil)
        } else {
            self.sessionDelegate = nil
            self.session = .shared
        }
    }

    func performRequest(_ request: RESTRequest) -> RetryCancellable? {
        do {
            let urlRequest = try makeURLRequest(from: request)

            let task = URLSessionRetryCancellableTask(session: session, urlRequest: urlRequest) { data, response, error in
                if case URLError.cancelled? = error {
                    request.onResponse(.failure(ServiceError.cancelled))
                    self.behavior.afterError(error: ServiceError.cancelled)
                } else if let error = error {
                    request.onResponse(.failure(error))
                    self.behavior.afterError(error: error)
                } else if let data = data, let response = response {
                    if let response = response as? HTTPURLResponse, let statusCodeError = HTTPStatusCodeError(statusCode: response.statusCode) {
                        let restError = try? JSONDecoder().decode(RESTError.self, from: data)
                        let error: Error = restError ?? statusCodeError
                        let serviceError = ServiceError(error) ?? error
                        request.onResponse(.failure(serviceError))
                        self.behavior.afterError(error: serviceError)
                    } else {
                        request.onResponse(.success((data, response)))
                        self.behavior.afterSuccess(response: data, urlResponse: response)
                    }
                } else {
                    request.onResponse(.failure(URLError(.unknown)))
                    self.behavior.afterError(error: URLError(.unknown))
                }
            }
            task.start()
            return task

        } catch {
            request.onResponse(.failure(error))
            behavior.afterError(error: error)
            return nil
        }
    }

    private func makeURLRequest(from request: RESTRequest) throws -> URLRequest {
        var urlComponents = URLComponents(url: restURL, resolvingAgainstBaseURL: false)!
        urlComponents.path = request.path

        if !request.queryParameters.isEmpty {
            urlComponents.queryItems = []
        }

        for queryItem in request.queryParameters {
            urlComponents.queryItems?.append(URLQueryItem(name: queryItem.name, value: queryItem.value))
        }

        guard let url = urlComponents.url else {
            throw URLError(.unknown)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        for (field, value) in behavior.headers {
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }

        if let contentType = request.contentType {
            urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }

        if let body = request.body {
            urlRequest.httpBody = try encoder.encode(body)
        } else {
            urlRequest.httpBody = nil
        }

        for header in request.headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }

        return urlRequest
    }
}
