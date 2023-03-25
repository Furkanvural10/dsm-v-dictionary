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
    var searchResults = [String]()
    var notFoundWord = ""
    var choosenWord: String?
    
    
    
    
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
        if searchText != ""{
            let firestoreDB = Firestore.firestore()
            let collectionRef = firestoreDB.collection("Dictionary")
            
            collectionRef.whereField("word", isGreaterThan: searchText)
                .whereField("word", isLessThanOrEqualTo: searchText + "\u{f8ff}").limit(to: 5)
                .getDocuments { snapshots, error in
                    if error != nil {
                        Alert.showFirebaseReadDataError(on: self, message: error!.localizedDescription)
                    }else{
                        print("SONUC: *** \(snapshots!.count)")
                        if searchText.count > 3 && snapshots!.count == 0 {
                            self.notFoundWord = "Sonuç Bulunamadı"
                        }else{
                            self.notFoundWord = ""
                            self.searchResults.removeAll(keepingCapacity: false)
                            for document in snapshots!.documents{
                                if let value = document.get("word") as? String {
                                    self.searchResults.append(value)
                                }
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
        if notFoundWord == "Sonuç Bulunamadı" {
            return 1
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        if self.notFoundWord == "Sonuç Bulunamadı"{
            content.text = "Sonuç Bulunamadı"
            cell.contentConfiguration = content
            return cell
        }
        content.text = searchResults[indexPath.row]
        self.choosenWord = searchResults[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let choosedWord = choosenWord {
            saveWordCoreData(choosedWord: choosedWord)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Sonuçlar"
        return header
    }
    
    func saveWordCoreData(choosedWord: String){
        print(choosedWord)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lastSearchWord = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)

        lastSearchWord.setValue(choosedWord, forKey: "word")
        lastSearchWord.setValue(UUID(), forKey: "id")

        do {
            try context.save()
        } catch  {
            print("HATA")
        }
        
        
    }
}
