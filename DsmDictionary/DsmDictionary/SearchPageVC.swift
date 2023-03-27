//
//  SearchPageVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 21.03.2023.
//

import UIKit
import CoreData
import FirebaseFirestore
import Kingfisher

class SearchPageVC: UIViewController {
    
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordDefinitionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentSearchWordTableView: UITableView!
    
    
    var clickedSearchBar = false
    var wordIDList = [UUID]()
    var createdList = [Date]()
    var wordList = [String]()
    var reverstedWordList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchPageView()
        getLastSearchWord()
        getDailyWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Ne zaman calısacak")
    }
    
    @objc private func getLastSearchWord(){
        
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
    private func deleteLastSearchWord(indexPath: Int){
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
                            self.recentSearchWordTableView.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .left)
                            
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
        
        self.wordDefinitionLabel.textColor = .black.withAlphaComponent(0.5)
        self.wordDefinitionLabel.numberOfLines = 0
        self.wordDefinitionLabel.textAlignment = .center
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
        content.text = self.wordList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createdList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let title = "En Son Arananlar"
            return title
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteLastSearchWord(indexPath: indexPath.row)
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
