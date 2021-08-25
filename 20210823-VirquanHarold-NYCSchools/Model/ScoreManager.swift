//
//  ScoreManager.swift
//  20210823-VirquanHarold-NYCSchools
//
//  Created by 757Digital on 8/25/21.
//

import Foundation

protocol ScoresManagerDelegate {
    func didUpdateScores(_ apiManager: ScoreManager, scores: [ScoresDataModel])
    func didFailWithError(error: Error)
 
}

struct ScoreManager {
    let scoresAPIUrl = "https://data.cityofnewyork.us/Education/2012-SAT-Results/f9bf-2cp4"
    
    var scoresDelegate: ScoresManagerDelegate?
    
    
    public func fetchScores() {
       performRequest(urlString: scoresAPIUrl)
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
                    if let scoresObj = self.parseJSON(data: safeData) {
                        self.scoresDelegate?.didUpdateScores(self, scores: scoresObj)
                    }
                }
                
            }
            
            // Start task
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data) -> [ScoresDataModel]?{
        // Decode data
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode([ScoresDataModel].self, from: data)
            print(decodedData)
            let satScores = decodedData
            return satScores
        } catch {
            print("JSON error: \(error.localizedDescription)")
            scoresDelegate?.didFailWithError(error: error)
            return []
        }
    }
    
}
