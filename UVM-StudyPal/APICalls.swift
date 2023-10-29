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

func APICall(query: String) -> Future<[Course], Error> {
    return Future<[Course], Error> { promise in
        let baseURL = "https://one.ehinchli.w3.uvm.edu/api/courses/search/?query="
        
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
