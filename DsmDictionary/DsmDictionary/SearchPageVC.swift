//
//  SearchPageVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 21.03.2023.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class SearchPageVC: UIViewController {
    
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordDefinitionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentSearchWordTableView: UITableView!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var clickedSearchBar = false
    var wordIDList = [UUID]()
    var createdList = [Date]()
    var wordList = [String]()
    var favoriteWordList = [String]()
    var favoriteWordIDList = [UUID]()
    var favoriteWordCreateAt = [Date]()
    lazy var rowsToDisplay = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchPageView()
        createUser()
        getLastWordFromCoredata()
        getDailyWord()
    }
    
    func createUser(){
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
                Auth.auth().signInAnonymously { data, error in
                    if error != nil {
                        Alert.showFirebaseSignInError(on: self, message: error!.localizedDescription)
                    }
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.segmentedController.selectedSegmentIndex == 0 {
            getLastWordFromCoredata()
        }else{
            getFavWordFromCoredata()
        }
    }
    
    @IBAction func selectSegmentedController(_ sender: Any) {
        if self.segmentedController.selectedSegmentIndex == 0 {
            getLastWordFromCoredata()
            self.recentSearchWordTableView.reloadData()
        }else{
            getFavWordFromCoredata()
            self.recentSearchWordTableView.reloadData()
        }
   
        
    }
    

    private func getLastWordFromCoredata(){
        
            
            wordList.removeAll(keepingCapacity: false)
            wordIDList.removeAll(keepingCapacity: false)
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            _ = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearchWord")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(fetchRequest)
                for i in result as! [NSManagedObject]{
                    if let word = i.value(forKey: "word") as? String {
                        self.wordList.append(word)
                        self.rowsToDisplay = self.wordList
                    }
                    if let id = i.value(forKey: "id") as? UUID {
                        self.wordIDList.append(id)
                    }
                    if let date = i.value(forKey: "createdAt") as? Date {
                        self.createdList.append(date)
                    }
                }
                self.recentSearchWordTableView.reloadData()
                
            } catch  {
                Alert.showCoreDataError(on: self)
            }
        }
    private func getFavWordFromCoredata(){
        favoriteWordList.removeAll(keepingCapacity: false)
        favoriteWordIDList.removeAll(keepingCapacity: false)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        _ = NSEntityDescription.insertNewObject(forEntityName: "FavoriteWord", into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteWord")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for i in result as! [NSManagedObject]{
                if let word = i.value(forKey: "favWord") as? String {
                    self.favoriteWordList.append(word)
                    self.rowsToDisplay = favoriteWordList
                }
                if let id = i.value(forKey: "id") as? UUID {
                    self.favoriteWordIDList.append(id)
                    
                }
                if let date = i.value(forKey: "createdAt") as? Date {
                    self.favoriteWordCreateAt.append(date)
                }
            }
            self.recentSearchWordTableView.reloadData()
            
        } catch  {
            Alert.showCoreDataError(on: self)
        }
    }
    private func deleteLastSearchWord(indexPath: Int, indexPaths: IndexPath){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearchWord")
        let idString = wordIDList[indexPath].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                for i in result as! [NSManagedObject]{
                    if let id = i.value(forKey: "id") as? UUID{
                        if id == wordIDList[indexPath]{
                            context.delete(i)
                            wordList.remove(at: indexPath)
                            wordIDList.remove(at: indexPath)
                            createdList.remove(at: indexPath)
//                            self.recentSearchWordTableView.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .left)
                            self.rowsToDisplay.remove(at: indexPath)
//                            self.recentSearchWordTableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                            recentSearchWordTableView.deleteRows(at: [indexPaths], with: .none)
                            recentSearchWordTableView.reloadData()
                            do {
                                try context.save()
                            } catch  {
                                Alert.showCoreDataError(on: self)
                            }
                            break
                        }
                    }
                }
            }
        } catch  {
            Alert.showCoreDataError(on: self)
        }
    }
    private func deleteFavoriteWord(indexPath: Int, indexPaths: IndexPath){
        
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteWord")
            let idString = favoriteWordIDList[indexPath].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(fetchRequest)
                if result.count > 0 {
                    for i in result as! [NSManagedObject]{
                        if let id = i.value(forKey: "id") as? UUID{
                            if id == favoriteWordIDList[indexPath]{
                                context.delete(i)
                                favoriteWordList.remove(at: indexPath)
                                favoriteWordIDList.remove(at: indexPath)
                                favoriteWordCreateAt.remove(at: indexPath)
                                self.rowsToDisplay.remove(at: indexPath)
//                                self.recentSearchWordTableView.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .left)
                                recentSearchWordTableView.deleteRows(at: [indexPaths], with: .none)
                                recentSearchWordTableView.reloadData()
                                do {
                                    try context.save()
                                    
                                } catch  {
                                    Alert.showCoreDataError(on: self)
                                }
                                break
                            }
                        }
                    }
                }
            } catch  {
                Alert.showCoreDataError(on: self)
            }
        
    }
    private func configureSearchPageView(){
        
        // MARK: - UISegmentedController
        self.segmentedController.setTitle("Geçmiş", forSegmentAt: 0)
        self.segmentedController.setTitle("Favoriler", forSegmentAt: 1)
        
        
        // Hide backbutton
        navigationItem.hidesBackButton = true
        
        // MARK: - ImageView
        self.dailyImageView.image = UIImage(named: "Onboarding")
        
        // MARK: - Delegate
        self.recentSearchWordTableView.delegate = self
        self.recentSearchWordTableView.dataSource = self
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Ara"
        self.searchBar.spellCheckingType = .no
        
        // MARK: - Labels
        self.wordLabel.numberOfLines = 0
        self.wordLabel.textColor = .black
        self.wordLabel.textAlignment = .center
        self.wordLabel.font = .boldSystemFont(ofSize: 35)
        
        self.wordDefinitionLabel.textColor = .black.withAlphaComponent(0.6)
        self.wordDefinitionLabel.numberOfLines = 5
        self.wordDefinitionLabel.textAlignment = .left
        self.wordDefinitionLabel.adjustsFontSizeToFitWidth = true
        self.wordDefinitionLabel.font = .systemFont(ofSize: 15)
    }
    private func getDailyWord(){
        let database = Firestore.firestore()
        let myCollection = database.collection("DailyWord")
        myCollection.addSnapshotListener { snapshot, error in
            if error == nil {
                for i in snapshot!.documents{
                    if let word = i.get("dailyWord") as? String{
                        self.wordLabel.text = word
                    }
                    if let wordDefinition = i.get("definition") as? String{
                        self.wordDefinitionLabel.text = wordDefinition
                    }
                    if let imageUrl = i.get("imageUrl") as? String{
                        if let url = URL(string: imageUrl) {
                            self.dailyImageView.kf.setImage(with: url)
                        }
                    }
                }
            }else{
                let message = "Bir hata oluştur lütfen tekrar deneyin"
                Alert.showFirebaseReadDataError(on: self, message: message )
            }
        }
    }
}

extension SearchPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = self.segmentedController.selectedSegmentIndex == 0 ? self.wordList[indexPath.row] : self.favoriteWordList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return wordList.count
        return self.segmentedController.selectedSegmentIndex == 0 ? self.wordList.count : self.favoriteWordList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(wordList[indexPath.row])
        performSegue(withIdentifier: "toDetailWordVC", sender: nil)
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.segmentedController.selectedSegmentIndex == 0 {
                deleteLastSearchWord(indexPath: indexPath.row, indexPaths: indexPath)
                
            }else{
                deleteFavoriteWord(indexPath: indexPath.row, indexPaths: indexPath)
                    //
            }
        }
    }
    
    
}

extension SearchPageVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // MARK: - Go To Detail Search Page
        performSegue(withIdentifier: "toDetailSearchVC", sender: nil)
        return true
    }
}
