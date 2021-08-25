//
//  DetailsViewController.swift
//  20210823-VirquanHarold-NYCSchools
//
//  Created by 757Digital on 8/25/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var schoolId: String = ""
    var apiManager = ScoreManager()
    
    var scoreData = [ScoresDataModel]()
    
    @IBOutlet weak var SATScore: UILabel!
    @IBOutlet weak var MathScore: UILabel!
    @IBOutlet weak var ReadScore: UILabel!
    @IBOutlet weak var WriteScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.scoresDelegate = self
        fetchData()
        view.backgroundColor = .cyan
    }
    

    func fetchData() {
        apiManager.fetchScores()
    }
 
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
extension DetailsViewController: ScoresManagerDelegate {
    func didUpdateScores(_ apiManager: ScoreManager, scores: [ScoresDataModel]) {
        DispatchQueue.main.async {
            let schoolSATScores = scores
            self.scoreData = schoolSATScores.filter {$0.schoolViewModel?.dbn == self.schoolId}
            self.MathScore.text = self.scoreData[0].math
            self.WriteScore.text = self.scoreData[0].writing
            self.ReadScore.text = self.scoreData[0].reading
        }
        
    }
    
    func didFailWithError(error: Error) {
        print("API Failed")
    }
    
    
}
