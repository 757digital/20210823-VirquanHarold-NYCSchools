//
//  ViewController.swift
//  20210823-VirquanHarold-NYCSchools
//
//  Created by 757Digital on 8/24/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    var apiManager = SchoolManager()
    
    var schoolData = [SchoolDataModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.schoolsDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        setupTableView()
    }
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "school")
        
        
    }
    
    func fetchData() {
        apiManager.fetchSchools()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let DetailsViewController = segue.destination as? DetailsViewController {
            
            DetailsViewController.schoolId = sender as? String ?? ""
        }
    }
    
}
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let school = tableView.dequeueReusableCell(withIdentifier: "school", for: indexPath)
        school.textLabel?.text = schoolData[indexPath.row].name
        return school
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "NYC Schools "
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "DetailsView", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.schoolId = schoolData[indexPath.row].dbn
        present(secondVC, animated: true, completion: nil)
    }
}
extension ViewController: SchoolsManagerDelegate {
    func didUpdateSchools(_ apiManager: SchoolManager, schools: [SchoolDataModel]) {
        DispatchQueue.main.async {
            self.schoolData = schools
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("API Failed")
    }
}

