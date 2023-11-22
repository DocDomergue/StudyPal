//
//  APICalls.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

// This is a rough example of how the API would be plugged in, which is one of our next steps.
// Currently, this only works in the sense that it reaches out to the API and can print its returned JSON file.

import Foundation
import Combine

struct Course: Decodable {
    let subj: String
    let course_number: String
    let title: String
    let section: String
    let instructor: String
    let start_time: String?  // nullable fields
    let end_time: String?
    let days: String
    let bldg: String
    let room: String
    let credits: String
    let xlistings: String
    let lec_lab: String
    let coll_code: String
    let max_enrollment: Int
    let current_enrollment: Int
    let email: String
    let comp_numb: Int
    let id: Int
}


struct CourseResponse: Decodable {
    let results: [Course]
}

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://one.ehinchli.w3.uvm.edu/api"

    // Properties to store CSRF token and Session ID
    private var csrfToken: String?
    private var sessionId: String?

    private init() {}

    // Update CSRF token and session ID
    func updateAuthCookies(csrfToken: String?, sessionId: String?) {
            self.csrfToken = csrfToken
            self.sessionId = sessionId
        }

    // Generic request function with authentication cookies
    func request(endpoint: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        
        if let csrfToken = self.csrfToken, let sessionId = self.sessionId {
                    request.addValue("csrftoken=\(csrfToken); sessionid=\(sessionId)", forHTTPHeaderField: "Cookie")
                }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Request Error: \(error)")
            }
            completion(data, error)
        }
        task.resume()
    }

    // Method to add a course
    func addCourse(courseId: Int, completion: @escaping (Bool, Error?) -> Void) {
        request(endpoint: "/add_course?course_id=\(courseId)") { data, error in
            DispatchQueue.main.async {
                completion(error == nil, error)
            }
        }
    }

    // Method to remove a course
    func removeCourse(courseId: Int, completion: @escaping (Bool, Error?) -> Void) {
        request(endpoint: "/remove_course?course_id=\(courseId)") { data, error in
            DispatchQueue.main.async {
                completion(error == nil, error)
            }
        }
    }
    
    // Fetch courses data and decode JSON response
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
    
}

