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

struct APIResponse: Decodable {
    let results: [Course]
}

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

func SearchAPICall(query: String) -> Future<[Course], Error> {
    return Future<[Course], Error> { promise in
        let baseURL = "https://one.ehinchli.w3.uvm.edu/api/search/?query="
        
        var defaultQuery = "Mobile"
        
        if !query.isEmpty {
            defaultQuery = query
        }
        
        // Construct the full API URL
        if let encodedQuery = defaultQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: baseURL + encodedQuery) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Create a URLSession task to make the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    promise(.success(apiResponse.results))
                } catch {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
    }
}



struct CourseResponse: Decodable {
    let results: [Course]
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://one.ehinchli.w3.uvm.edu/api"

    private init() {}

    func request(endpoint: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, error)
        }
        task.resume()
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
