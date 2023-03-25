//
//  DetailSearchVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 23.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailSearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    var searchResults = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailSearchPageView()
        createGestureRecognizer()
    }
    
    private func getData(){
        let firestoreDB = Firestore.firestore()
        
        
    }
    
    private func createGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
     @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    func configureDetailSearchPageView(){
        // Open keyboard
        searchBar.becomeFirstResponder()
        
        //MARK: - TableView
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        
        //MARK: - SearchBar
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
    }
    
}

extension DetailSearchVC: UISearchBarDelegate {
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            
            let firestoreDB = Firestore.firestore()
            let collectionRef = firestoreDB.collection("Dictionary")
            
            collectionRef.whereField("word", isGreaterThan: searchText)
                .whereField("word", isLessThanOrEqualTo: searchText + "\u{f8ff}").limit(to: 5)
                .getDocuments { snapshots, error in
                    if error != nil {
                        Alert.showFirebaseReadDataError(on: self, message: error!.localizedDescription)
                    }else{
                        self.searchResults.removeAll(keepingCapacity: false)
                        for document in snapshots!.documents{
                            if let value = document.get("word") as? String {
                                self.searchResults.append(value)
                            }
                        }
                    }
                }
        }else{
            self.searchResults.removeAll(keepingCapacity: false)
        }
        self.searchResultTableView.reloadData()
    }
}

extension DetailSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = searchResults[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}
