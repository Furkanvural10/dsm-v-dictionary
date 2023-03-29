//
//  DetailSearchVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 23.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class DetailSearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    var searchResult = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailSearchPageView()
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
        let db = Firestore.firestore()
        let myCollection = db.collection("Dictionary")
        if searchText != ""{
        myCollection.whereField("word", isGreaterThanOrEqualTo: searchText)
                .whereField("word", isLessThan: searchText + "\u{f8ff}").limit(to: 10)
                    .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Alert.showFirebaseReadDataError(on: self, message: error.localizedDescription)
            } else {
                self.searchResult.removeAll()
                for document in querySnapshot!.documents {
                    if let result = document.get("word") as? String {
                        self.searchResult.append(result)
                    }
                }
                self.searchResultTableView.reloadData()
            }
        }

        }else{
            self.searchResult.removeAll()
            self.searchResultTableView.reloadData()
        }

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}

extension DetailSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = searchResult[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        saveWordCoreData(choosedWord: searchResult[indexPath.row])
        performSegue(withIdentifier: "toDetailWordVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Sonuçlar"
        return header
    }
    
    func saveWordCoreData(choosedWord: String){
        let context        = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lastSearchWord = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)
        
        lastSearchWord.setValue(choosedWord, forKey: "word")
        lastSearchWord.setValue(UUID(), forKey: "id")
        lastSearchWord.setValue(Date(), forKey: "createdAt")
        do      {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name("newWordAdded"), object: nil)
            
        }
        catch   { Alert.showCoreDataError(on: self) }
    }
}
