//
//  SchoolManager.swift
//  20210823-VirquanHarold-NYCSchools
//
//  Created by 757Digital on 8/25/21.
//

import Foundation

protocol SchoolsManagerDelegate {
    func didUpdateSchools(_ apiManager: SchoolManager, schools: [SchoolDataModel])
    func didFailWithError(error: Error)
}


struct SchoolManager {
    let schoolAPIUrl = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    
    var schoolsDelegate: SchoolsManagerDelegate?
    
    
    func fetchSchools() {
        performRequest(urlString: schoolAPIUrl)
    }
    
   
    func performRequest(urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URL Session
            let session = URLSession(configuration: .default)
            // Give session a task
            
            let task = session.dataTask(with: url) { data, response, error in
                
                // Check for err or null data
                if error != nil || data == nil {
                    print("Error on client side")
                    return
                }
                
                // Check for 200 success status
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Error on server side")
                    return
                }
                
                // Check for data type
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Invald mime type")
                    return
                }
                
                if let safeData = data {
                    if let schoolObj = self.parseJSON(data: safeData) {
                        self.schoolsDelegate?.didUpdateSchools(self, schools: schoolObj)
                    }
                }
                
            }
            
            // Start task
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data) -> [SchoolDataModel]?{
        // Decode data
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode([SchoolDataModel].self, from: data)
            print(decodedData)
            let schoolList = decodedData
            return schoolList
        } catch {
            print("JSON error: \(error.localizedDescription)")
            schoolsDelegate?.didFailWithError(error: error)
            return []
        }
    }
    
}
