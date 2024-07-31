import Foundation

public enum NetworkClient {
    
    public struct Request {
        public let url: String
        public let method: NetworkMethod
        public let headers: [String: String]?
        public let body: Encodable?
        public let parameters: [String: String]?
        
        public init(
            url: String,
            method: NetworkMethod,
            headers: [String: String]? = nil,
            body: Encodable? = nil,
            paremeters: [String: String]? = nil
        ) {
            self.url = url
            self.method = method
            self.headers = headers
            self.body = body
            self.parameters = paremeters
        }
        
        public func run<T: Decodable>(
            urlSession: URLSession = .shared,
            encoder: JSONEncoder = .init(),
            decoder: JSONDecoder = .init()
        ) async throws -> T {
            guard let url = URL(string: url) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            if let parameters {
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
                request.url?.append(queryItems: queryItems)
            }
            
            if let body {
                let data = try encoder.encode(body)
                request.httpBody = data
            }
            
            let (data, response) = try await urlSession.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
                    throw NetworkError.decode
                }
                return decodedResponse
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.unexpectedStatusCode(statusCode: response.statusCode)
            }
        }
        
        public func run(
            urlSession: URLSession = .shared,
            encoder: JSONEncoder = .init(),
            decoder: JSONDecoder = .init()
        ) async throws {
            guard let url = URL(string: url) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            if let parameters {
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
                request.url?.append(queryItems: queryItems)
            }
            
            if let body {
                let data = try encoder.encode(body)
                request.httpBody = data
            }
            
            let (_, response) = try await urlSession.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                break
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.unexpectedStatusCode(statusCode: response.statusCode)
            }
        }
    }
    
    public struct StreamRequest {
        
        public let url: String
        public let method: NetworkMethod
        public let headers: [String: String]?
        public let body: Encodable?
        
        public init(
            url: String,
            method: NetworkMethod,
            headers: [String: String]? = nil,
            body: Encodable? = nil
        ) {
            self.url = url
            self.method = method
            self.headers = headers
            self.body = body
        }
        
        public func run<T: Decodable>(
            urlSession: URLSession = .shared,
            encoder: JSONEncoder = .init(),
            decoder: JSONDecoder = .init(),
            timeout: CGFloat? = nil
        ) async throws -> AsyncThrowingStream<T, Error> {
            
            guard let url = URL(string: url) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            
            if let timeout {
                request.timeoutInterval = timeout
            }
            
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            if let body {
                let data = try encoder.encode(body)
                request.httpBody = data
            }
            
            let (result, response) = try await urlSession.bytes(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            guard httpResponse.statusCode != 401 else {
                throw NetworkError.unauthorized
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
            }
            
            return AsyncThrowingStream<T, Error> { continuation in
                Task(priority: .userInitiated) {
                    do {
                        for try await line in result.lines {
                            guard let data = line.data(using: .utf8) else {
                                continuation.finish(throwing: NetworkError.decode)
                                return
                            }
                            
                            let decodedResponse = try decoder.decode(T.self, from: data)
                            continuation.yield(decodedResponse)
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }
        }
    }
}

