//
//  DataModel.swift
//  20210823-VirquanHarold-NYCSchools
//
//  Created by 757Digital on 8/24/21.
//

import Foundation
import UIKit

// Model that will keep all the NYC schools
class SchoolViewModel {
    private(set) var schoolViewModels = [SchoolDataModel]()
    
    // Set the schoolViewModels
    func setSchoolViewModels(with viewModels: [SchoolDataModel]) {
        self.schoolViewModels = viewModels
    }
    
    
}

struct SchoolDataModel: Decodable {
    let name: String
    let interest: String
    let city: String
    let state: String
    let dbn: String
    let overview: String
    
    // Reassign JSON fields to code keys
    private enum CodingKeys: String, CodingKey {
        case name = "school_name"
        case interest = "interest1"
        case city
        case state = "state_code"
        case dbn
        case overview = "overview_paragraph"
    }
}
