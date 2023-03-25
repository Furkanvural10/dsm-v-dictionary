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
//        createGestureRecognizer()
    }
    
    private func getData(){
        let firestoreDB = Firestore.firestore()
        
        
    }
    
    
    
    func configureDetailSearchPageView(){
        
        
        //MARK: - TableView
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.isMultipleTouchEnabled = false
        self.searchResultTableView.allowsMultipleSelection = false
        self.searchResultTableView.allowsMultipleSelectionDuringEditing = false
        self.searchResultTableView.separatorEffect = .none
        
        
        
        //MARK: - SearchBar
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = .done
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "Kelime Ara"
        
        // Open keyboard
        searchBar.becomeFirstResponder()
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Diğer sayfaya götür")
        // Kelimenin detay sayfasına gönder kullanıcıyı
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Sonuçlar"
        return "Sonuçlar"
    }
    
    
    
    
}
