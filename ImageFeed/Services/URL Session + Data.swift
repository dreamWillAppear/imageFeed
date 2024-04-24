import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

// MARK: - URLSession

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("URLSession for \(request) failed with status code - \(NetworkError.httpStatusCode(statusCode))")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("URLSession for \(request) failed with status code - \(String(describing: error))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("URLSession for \(request) failed with status code - \(String(describing: error))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}

// MARK: - URLSession  func objectTask<T: Decodable>

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { result in
            switch result {
                case .success(let data):
                    do {
                        let decodedData = try decoder.decode(T.self, from: data)
                        print("Decoding \(type(of: T.self)) success!")
                        completion(.success(decodedData))
                    } catch {
                        print("Decoding \(type(of: T.self)) error: \(String(describing: error))")
                        completion(.failure(error))
                    }
                case.failure(let error):
                    print("Request data for \(type(of: T.self)) error: \(String(describing: error))")
                    completion(.failure(error))
            }
        }
        return task
    }
}


