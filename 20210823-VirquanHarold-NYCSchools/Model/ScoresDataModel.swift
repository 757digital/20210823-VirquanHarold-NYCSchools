//
//  ScoresDataModel.swift
//  20210823-VirquanHarold-NYCSchools
//
//  Created by 757Digital on 8/25/21.
//

import Foundation

// Model for the SAT scores of a school
class ScoresViewModel {
    private(set) var scoresViewModel = ScoresViewModel()

}


struct ScoresDataModel: Decodable {
    let takers: String
    let reading: String
    let math: String
    let writing: String
    var schoolViewModel: SchoolDataModel?
    
    
    // Personalise the decoding keys
    private enum CodingKeys: String, CodingKey {
        case takers = "num_of_sat_test_takers"
        case reading = "sat_critical_reading_avg_score"
        case math = "sat_math_avg_score"
        case writing = "sat_writing_avg_score"
    }
    
    init() {
        self.takers = ""
        self.reading = ""
        self.math = ""
        self.writing = ""
    }
}
