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
    var selectedWord: String?
    var favoriteList = [String]()
    
    
    
    
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
        self.selectedWord = searchResult[indexPath.row]
        performSegue(withIdentifier: "toDetailWordVC", sender: selectedWord)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailWordVC"{
            let destinationVC = segue.destination as! WordDefinitionVC
            destinationVC.comingWord = self.selectedWord
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Sonuçlar"
        return header
    }
    
    func saveWordCoreData(choosedWord: String){
        
        if self.favoriteList.contains(choosedWord){
            
            //MARK: - First Delete then Save
            
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearchWord")
                let word = choosedWord
                
                fetchRequest.predicate = NSPredicate(format: "word = %@", word)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let result = try context.fetch(fetchRequest)
                    if result.count > 0 {
                        for i in result as! [NSManagedObject]{
                            if let _ = i.value(forKey: "word") as? String{
                                    context.delete(i)
                                if let index = self.favoriteList.firstIndex(of: "Osman"){
                                    self.favoriteList.remove(at: index)
                                }
                                
                                    do {
                                        try context.save()
                                    } catch  {
                                        Alert.showCoreDataError(on: self)
                                    }
                                    break
                            }
                        }
                    }
                } catch  {
                    Alert.showCoreDataError(on: self)
                }
            
            let lastSearchWord = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)
            lastSearchWord.setValue(choosedWord, forKey: "word")
            lastSearchWord.setValue(UUID(), forKey: "id")
            lastSearchWord.setValue(Date(), forKey: "createdAt")
            do      {
                try context.save()
                self.favoriteList.append(choosedWord)
                
            }
            catch   { Alert.showCoreDataError(on: self) }
        }else{
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let lastSearchWord = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)
            lastSearchWord.setValue(choosedWord, forKey: "word")
            lastSearchWord.setValue(UUID(), forKey: "id")
            lastSearchWord.setValue(Date(), forKey: "createdAt")
            do{
                try context.save()
                self.favoriteList.append(choosedWord)
                
            }
            catch   { Alert.showCoreDataError(on: self) }
        }
        
        
    }
}
