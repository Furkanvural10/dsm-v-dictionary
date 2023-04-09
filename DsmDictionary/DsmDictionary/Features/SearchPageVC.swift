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
    var selectedWord: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchPageView()
        createUser()
        getLastWordFromCoredata()
        getFavWordFromCoredata()
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
        
        let result = CoreDataFunctions.getLastWordFromCoreData(vc: self)
        self.wordList = result.0
        self.rowsToDisplay = self.wordList
        self.wordIDList = result.1
        self.createdList = result.2
        self.recentSearchWordTableView.reloadData()
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
                            self.rowsToDisplay.remove(at: indexPath)
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
        self.wordLabel.numberOfLines = 1
        self.wordLabel.textColor = .black
        self.wordLabel.textAlignment = .center
        self.wordLabel.font = .boldSystemFont(ofSize: 35)
        self.wordLabel.adjustsFontSizeToFitWidth = true
        
        self.wordDefinitionLabel.textColor = .black.withAlphaComponent(0.6)
        self.wordDefinitionLabel.numberOfLines = 5
        self.wordDefinitionLabel.textAlignment = .left
        self.wordDefinitionLabel.adjustsFontSizeToFitWidth = true
        self.wordDefinitionLabel.font = .systemFont(ofSize: 15)
    }
    private func getDailyWord(){
        
            GetDataFromFirebase.getDailyWord(vc: self) { word, definition, url in
            self.wordLabel.text = word
            self.wordDefinitionLabel.text = definition
            if let url = URL(string: url) {
                self.dailyImageView.kf.setImage(with: url)
            }
        }
    }
    
    private func checkLastOrFavSegment() -> Bool{
        let index = self.segmentedController.selectedSegmentIndex
        if index == 0{
            if self.favoriteWordList.contains(self.selectedWord!){
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
}

extension SearchPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = self.segmentedController.selectedSegmentIndex
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = index == 0 ? self.wordList[indexPath.row] : self.favoriteWordList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = self.segmentedController.selectedSegmentIndex
        return index == 0 ? self.wordList.count : self.favoriteWordList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedWord = rowsToDisplay[indexPath.row]
        performSegue(withIdentifier: "toDetailWordVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailWordVC"{
            let destinationVC = segue.destination as! WordDefinitionVC
            destinationVC.comingWord = self.selectedWord
            destinationVC.isFavWord = checkLastOrFavSegment()
            
        }
        if segue.identifier == "toDetailSearchVC"{
            let destinationVC = segue.destination as! DetailSearchVC
            destinationVC.lastSearchList = self.rowsToDisplay
            destinationVC.favoriteWordList = self.favoriteWordList
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = self.segmentedController.selectedSegmentIndex
        if editingStyle == .delete {
            if index == 0 {
                deleteLastSearchWord(indexPath: indexPath.row, indexPaths: indexPath)
                
            }else{
                deleteFavoriteWord(indexPath: indexPath.row, indexPaths: indexPath)
            }
        }
    }
}

extension SearchPageVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performSegue(withIdentifier: "toDetailSearchVC", sender: nil)
        return true
    }
}
