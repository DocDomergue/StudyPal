import Foundation

// Model for course data
struct Course: Decodable {
    let subj, course_number, title, section: String
    let instructor: String
    let start_time, end_time: String? // nullable fields
    let days, bldg, room, credits: String
    let xlistings, lec_lab, coll_code: String
    let max_enrollment, current_enrollment, comp_numb, id: Int
    let email: String
}

// Model for course response
struct CourseResponse: Decodable {
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
    }

    // Generic request function with authentication
    func request(endpoint: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        if let csrfToken = csrfToken, let sessionId = sessionId {
            request.addValue("csrftoken=\(csrfToken); sessionid=\(sessionId)", forHTTPHeaderField: "Cookie")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }

    // Adds a course
    func addCourse(courseId: Int, completion: @escaping (Bool, Error?) -> Void) {
        performCourseOperation(endpoint: "/add_course?course_id=\(courseId)", completion: completion)
    }

    // Removes a course
    func removeCourse(courseId: Int, completion: @escaping (Bool, Error?) -> Void) {
        performCourseOperation(endpoint: "/remove_course?course_id=\(courseId)", completion: completion)
    }

    // Fetches courses data and decodes JSON response
    func fetchCourses(query: String, completion: @escaping ([Course]?, Error?) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }
        request(endpoint: "/search/?query=\(encodedQuery)") { data, error in
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

    // Helper function for course operations
    private func performCourseOperation(endpoint: String, completion: @escaping (Bool, Error?) -> Void) {
        request(endpoint: endpoint) { data, error in
            DispatchQueue.main.async {
                completion(error == nil, error)
            }
        }
    }
}
