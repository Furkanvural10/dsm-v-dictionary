//
//  SearchPageVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 21.03.2023.
//

import UIKit
import CoreData

class SearchPageVC: UIViewController {
    
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordDefinitionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentSearchWordTableView: UITableView!
    
    
    var clickedSearchBar = false
    var wordIDList = [UUID]()
    var wordList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchPageView()
        getLastSearchWord()
    }
    
    private func getLastSearchWord(){
        
        wordList.removeAll(keepingCapacity: false)
        wordList.removeAll(keepingCapacity: false)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        _ = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearchWord")
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
            }
            self.recentSearchWordTableView.reloadData()
            
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
        self.wordLabel.text = "Günün Kelimesi"
        self.wordLabel.numberOfLines = 0
        self.wordLabel.textColor = .black
        self.wordLabel.textAlignment = .center
        self.wordLabel.font = .boldSystemFont(ofSize: 35)
        
        self.wordDefinitionLabel.text = "Günün kelimesinin açıklaması burada olacak - Günün kelimesinin açıklaması burada olacak"
        self.wordDefinitionLabel.textColor = .black.withAlphaComponent(0.5)
        self.wordDefinitionLabel.numberOfLines = 0
        self.wordDefinitionLabel.textAlignment = .center
        self.wordDefinitionLabel.font = .systemFont(ofSize: 15)
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
        return wordIDList.count
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SEÇİLDİ")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let title = "En Son Arananlar"
            return title
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipe = UIContextualAction(style: .destructive, title: "Sil") { action, view, boolValue in
            print("Silme işlemi")
        }
        return UISwipeActionsConfiguration(actions: [deleteSwipe])
    }
    
}

extension SearchPageVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // MARK: - Go To Detail Search Page
        performSegue(withIdentifier: "toDetailSearchVC", sender: nil)
        return true
    }
}
