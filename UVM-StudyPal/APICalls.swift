import Foundation

// Model for course response
struct CourseResponse: Codable {
    let results: [Course]
}

// NetworkManager handles all network requests
class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://one.ehinchli.w3.uvm.edu/api"
    private var csrfToken: String?
    private var sessionId: String?

    private init() {}

    // Updates CSRF token and Session ID
    func updateAuthCookies(csrfToken: String?, sessionId: String?) {
        self.csrfToken = csrfToken
        self.sessionId = sessionId
        print("updateAuthCookies called: \(String(describing: self.csrfToken)) \(String(describing: self.sessionId))")

    }

    // Generic request function with authentication
    func request(_ urlRequest: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                completion(data, error)
            }
            task.resume()
        }

    
    private func logRequest(_ request: URLRequest) {
           print("\n--- Request Start ---")
           print("URL: \(String(describing: request.url))")
           print("Method: \(String(describing: request.httpMethod))")
           print("Headers: \(String(describing: request.allHTTPHeaderFields))")

           if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
               print("Body: \(bodyString)")
           }
           print("--- Request End ---\n")
       }
    

    
    func fetchUserProfile(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/userprofile/") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let csrfToken = csrfToken, let sessionId = sessionId {
            let cookieHeader = "csrftoken=\(csrfToken); sessionid=\(sessionId)"
            request.addValue(cookieHeader, forHTTPHeaderField: "Cookie")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }.resume()
    }

    func updateUserProfile(jsonData: Data, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/userprofile/") else {
            completion(false, NSError(domain: "", code: -1, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let csrfToken = csrfToken, let sessionId = sessionId {
            request.addValue(csrfToken, forHTTPHeaderField: "X-CSRFToken")
            request.addValue("csrftoken=\(csrfToken); sessionid=\(sessionId)", forHTTPHeaderField: "Cookie")
        }
        logRequest(request)
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                completion(error == nil, error)
            }
        }.resume()
    }
    
    // Fetches courses data and decodes JSON response
    func fetchCourses(query: String, completion: @escaping ([Course]?, Error?) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/?query=\(encodedQuery)") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        self.request(urlRequest) { data, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(CourseResponse.self, from: data)
                    completion(decodedData.results, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
    func fetchTotalStudyTime(completion: @escaping (Int?, Error?) -> Void) {
            guard let url = URL(string: "\(baseURL)/total_study") else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            if let csrfToken = csrfToken, let sessionId = sessionId {
                let cookieHeader = "csrftoken=\(csrfToken); sessionid=\(sessionId)"
                request.addValue(cookieHeader, forHTTPHeaderField: "Cookie")
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(nil, error)
                    } else if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Int],
                               let totalStudyTime = jsonResponse["total_study"] {
                                completion(totalStudyTime, nil)
                            }
                        } catch {
                            completion(nil, error)
                        }
                    }
                }
            }.resume()
        }
}
