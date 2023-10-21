//
//  APICalls.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/21/23.
//

// This is a rough example of how the API would be plugged in, which is one of our next steps.
// Currently, this only works in the sense that it reaches out to the API and can print its returned JSON file.

import Foundation

// Define a struct to match the JSON response structure
struct queryReturn: Codable {
    // This will need properties to match the JSON structure
    var dumpItAsAString = "oops"
}

// Example function
func APICall(query: String) {
    
    // base API URL
    let baseURL = "https://one.ehinchli.w3.uvm.edu/api/courses/search/"
    
    // query
    var defaultQuery = "Mobile"
    
    if (query != "") { defaultQuery = query }
    
    // Construct the full API URL
    if let encodedQuery = defaultQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
       let url = URL(string: baseURL + encodedQuery) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create a URLSession task to make the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                exit(-1) // These should be handled more nicely later on
            }
            
            guard let data = data else {
                print("No data received.")
                exit(-1) // These should be handled more nicely later on
            }
            
            do {
                // Decode the JSON response into an array of Course structs
                let courses = try JSONDecoder().decode([queryReturn].self, from: data)
                
                // Process the courses data as needed
                for course in courses {
                    print(course)
                }
            } catch let jsonError {
                print("JSON decoding error: \(jsonError)")
            }
        }
        
        // Start the URLSession task
        task.resume()
    }
}
