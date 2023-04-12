import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class SearchPageVC: UIViewController {
    
    @IBOutlet weak var dailyImageView            : UIImageView!
    @IBOutlet weak var wordLabel                 : UILabel!
    @IBOutlet weak var wordDefinitionLabel       : UILabel!
    @IBOutlet weak var searchBar                 : UISearchBar!
    @IBOutlet weak var recentSearchWordTableView : UITableView!
    @IBOutlet weak var segmentedController       : UISegmentedControl!
    
    var clickedSearchBar = false
    var wordIDList         	 = [UUID]()
    var createdList        	 = [Date]()
    var wordList           	 = [String]()
    var favoriteWordList   	 = [String]()
    var favoriteWordIDList 	 = [UUID]()
    var favoriteWordCreateAt = [Date]()
    lazy var rowsToDisplay   = [String]()
    var selectedWord         : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchPageView()
        createUser()
        getLastWordFromCoredata()
        getFavWordFromCoredata()
        getDailyWord()
    }
    
    func createUser(){CreateUsers.createUser(vc: self)}
    
    override func viewWillAppear(_ animated: Bool) {
        let index = self.segmentedController.selectedSegmentIndex
        if index == 0 {
            getLastWordFromCoredata()
        }else{
            getFavWordFromCoredata()
        }
    }
    
    @IBAction func selectSegmentedController(_ sender: Any) {
        let index = self.segmentedController.selectedSegmentIndex
        if index == 0 {
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
        let result          = CoreDataFunctions.getLastWordFromCoreData(vc: self)
        self.wordList       = result.0
        self.rowsToDisplay  = self.wordList
        self.wordIDList     = result.1
        self.createdList    = result.2
        self.recentSearchWordTableView.reloadData()
    }
    
    private func getFavWordFromCoredata(){
        
        favoriteWordList.removeAll(keepingCapacity: false)
        favoriteWordIDList.removeAll(keepingCapacity: false)
        let result                = CoreDataFunctions.getFavWordFromCoreData(vc: self)
        self.favoriteWordList     = result.0
        self.rowsToDisplay        = favoriteWordList
        self.favoriteWordIDList   = result.1
        self.favoriteWordCreateAt = result.2
        self.recentSearchWordTableView.reloadData()
        
    }
    private func deleteLastSearchWord(indexPath: Int, indexPaths: IndexPath){
        
        let result = CoreDataFunctions.deleteLastSearchWord(vc: self, indexPath: indexPath, indexPaths: indexPaths, wordIDList: wordIDList)
        if result{
            wordList.remove(at: indexPath)
            wordIDList.remove(at: indexPath)
            createdList.remove(at: indexPath)
            self.rowsToDisplay.remove(at: indexPath)
            recentSearchWordTableView.deleteRows(at: [indexPaths], with: .none)
            recentSearchWordTableView.reloadData()
        }
    }
    private func deleteFavoriteWord(indexPath: Int, indexPaths: IndexPath){
        
        let result = CoreDataFunctions.deleteFavoriteWord(vc: self, indexPath: indexPath, indexPaths: indexPaths, favWordListID: favoriteWordIDList)
        if result{
            favoriteWordList.remove(at: indexPath)
            favoriteWordIDList.remove(at: indexPath)
            favoriteWordCreateAt.remove(at: indexPath)
            self.rowsToDisplay.remove(at: indexPath)
            recentSearchWordTableView.deleteRows(at: [indexPaths], with: .none)
            recentSearchWordTableView.reloadData()
        }
    }
    private func configureSearchPageView(){
        
        // MARK: - UISegmentedController
        self.segmentedController.setTitle(Text.segmentedControllerTitle1, forSegmentAt: 0)
        self.segmentedController.setTitle(Text.segmentedControllerTitle2, forSegmentAt: 1)

        // Hide backbutton
        navigationItem.hidesBackButton = true
        
        // MARK: - ImageView
        self.dailyImageView.image = Images.onboardingImage
        
        // MARK: - Delegate
        self.recentSearchWordTableView.delegate = self
        self.recentSearchWordTableView.dataSource = self
        
        self.searchBar.delegate          = self
        self.searchBar.placeholder       = Text.searchBarTitle
        self.searchBar.spellCheckingType = .no
        
        // MARK: - Labels
        self.wordLabel.numberOfLines             		   = 1
        self.wordLabel.textColor                 		   = .black
        self.wordLabel.textAlignment             		   = .center
        self.wordLabel.font                      		   = Font.BoldFontSize.boldFont30
        self.wordLabel.adjustsFontSizeToFitWidth 		   = true

        self.wordDefinitionLabel.textColor                 = .black.withAlphaComponent(0.6)
        self.wordDefinitionLabel.numberOfLines             = 5
        self.wordDefinitionLabel.textAlignment             = .left
        self.wordDefinitionLabel.adjustsFontSizeToFitWidth = true
        self.wordDefinitionLabel.font                      = Font.FontSize.fontSize15
    }
    private func getDailyWord(){
        
            GetDailyWordDataFromFirebase.getDailyWord(vc: self) { word in
                self.wordLabel.text           = word.dailyWord
                self.wordDefinitionLabel.text = word.definition
                if let url                    = URL(string: word.imageUrl) {
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
        let index                 = self.segmentedController.selectedSegmentIndex
        let cell                  = UITableViewCell()
        var content               = cell.defaultContentConfiguration()
        content.text              = index == 0 ? self.wordList[indexPath.row] : self.favoriteWordList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = self.segmentedController.selectedSegmentIndex
        return index == 0 ? self.wordList.count : self.favoriteWordList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedWord = rowsToDisplay[indexPath.row]
        performSegue(withIdentifier: Text.toDetailWordVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.toDetailWordVC{
            let destinationVC        = segue.destination as! WordDefinitionVC
            destinationVC.comingWord = self.selectedWord
            destinationVC.isFavWord  = checkLastOrFavSegment()
            
        }
        if segue.identifier == Text.toDetailSearchVC{
            let destinationVC              = segue.destination as! DetailSearchVC
            destinationVC.lastSearchList   = self.rowsToDisplay
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
        performSegue(withIdentifier: Text.toDetailSearchVC, sender: nil)
        return true
    }
}
