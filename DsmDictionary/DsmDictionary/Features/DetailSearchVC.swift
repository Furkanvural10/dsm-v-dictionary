import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class DetailSearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    var searchResult = [String]()
    var selectedWord: String?
    var lastSearchList = [String]()
    var favoriteWordList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailSearchPageView()
        
    }
    private func configureDetailSearchPageView(){
        //MARK: - TableView
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.isMultipleTouchEnabled = false
        self.searchResultTableView.allowsMultipleSelection = false
        self.searchResultTableView.allowsMultipleSelectionDuringEditing = false
        self.searchResultTableView.separatorEffect = .none
        
        //MARK: - SearchBar
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = .search
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = Text.searchWord
        
        // Open keyboard
        searchBar.becomeFirstResponder()
    }
    private func checkSelectedWordExistInFavList() -> Bool{
        if favoriteWordList.contains(selectedWord!){
            return true
        }else{
            return false
        }
    }
}

extension DetailSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Searching.searchWord(vc: self, searchText: searchText) { searchResultList in
            self.searchResult = searchResultList
            self.searchResultTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.searchResult.isEmpty{
            self.searchResult.append(Text.notFound)
            self.searchResultTableView.reloadData()
            self.view.endEditing(true)
        }else{
            self.view.endEditing(true)
        }
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
            destinationVC.isFavWord = checkSelectedWordExistInFavList()
        }
    }
    
    func saveWordCoreData(choosedWord: String){
        
        if self.lastSearchList.contains(choosedWord){
            CoreDataFunctions.deleteFirsThenSaveWordCoreData(vc: self, choosedWord: choosedWord) { bool in
                if bool{
                    if let index = self.lastSearchList.firstIndex(of: choosedWord){
                        self.lastSearchList.remove(at: index)
                    }
                    self.lastSearchList.append(choosedWord)
                }
            }
        }else{
            CoreDataFunctions.saveWordToCoreData(vc: self, choosedWord: choosedWord) { bool in
                if bool {
                    self.lastSearchList.append(choosedWord)
                }
            }
        }
    }
}
