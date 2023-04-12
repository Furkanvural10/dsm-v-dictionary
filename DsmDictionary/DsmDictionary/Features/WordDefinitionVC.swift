import UIKit
import CoreData
import FirebaseFirestore

class WordDefinitionVC: UIViewController {
    

    @IBOutlet weak var wordLabel                : UILabel!
    @IBOutlet weak var languageSegmentedControl : UISegmentedControl!
    @IBOutlet weak var definitionLabel          : UILabel!
    @IBOutlet weak var definitionDetailLabel    : UILabel!
    @IBOutlet weak var dsmTitleLabel            : UILabel!
    @IBOutlet weak var comorbidTableView        : UITableView!
    @IBOutlet weak var dsmDetailTextView        : UITextView!
    @IBOutlet weak var bookmarkButton           : UIBarButtonItem!
    
    var clickedBookmark = false
    var comingWord      : String?
    var comorbidList    = [String]()
    var comorbidOneList = [String]()
    var wordEN          : String?
    var isFavWord       = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWordDetail(word: comingWord!, collection: FirebaseText.searchCollection)
        configurationView()
    }

    
    @IBAction func bookmarkButton(_ sender: Any) {
            
        if !self.isFavWord {
            if !clickedBookmark{
                bookmarkButton.image = Images.bookmarkFill
                clickedBookmark      = !clickedBookmark
                saveWordToCoredata(word: comingWord!)
                
            }else{
                bookmarkButton.image = Images.bookmark
                clickedBookmark      = !clickedBookmark
                deleteWordFromCoredata(word: comingWord!)
            }
        }
    }
    
    private func saveWordToCoredata(word: String){
        CoreDataFunctions.saveFavWordToCoreData(vc: self, word: word)
    }
    private func deleteWordFromCoredata(word: String){
        CoreDataFunctions.deleteComingBookmarkFavWord(vc: self, word: word)
    }
    
    private func configurationView(){
        
        //MARK: TableView
        self.comorbidTableView.delegate   = self
        self.comorbidTableView.dataSource = self

        // MARK: - Bookmark Button
        if self.isFavWord {
            self.bookmarkButton.image = Images.bookmarkFill
        }else{
            self.bookmarkButton.image = Images.bookmark
        }
        
        // MARK: - Word
        self.wordLabel.text                      = Text.wordLabel
        self.wordLabel.font                      = Font.BoldFontSize.boldFont30
        self.wordLabel.adjustsFontSizeToFitWidth = true
        
        // MARK: - SegmentedController
        self.languageSegmentedControl.setTitle(Text.turkishSegmentedTitle, forSegmentAt: 0)
        self.languageSegmentedControl.setTitle(Text.englishSegmentedTitle, forSegmentAt: 1)
        self.languageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.languageSegmentedControl.selectedSegmentTintColor = UIColor(red: 0x47, green: 0x2f, blue: 0x92)
        
        
        // MARK: - DefinitiontTitleLabel
        self.definitionLabel.text = Text.definitionTitle
        self.definitionLabel.font = Font.BoldFontSize.boldFont20
        
        //MARK: - DefinitionDetailLabel
        self.definitionDetailLabel.font                      = Font.FontSize.fontSize14
        self.definitionDetailLabel.alpha                     = Alpha.alpha7
        self.definitionDetailLabel.adjustsFontSizeToFitWidth = true
        
        //MARK: - DSM-V Title
        self.dsmTitleLabel.text = Text.dsmDefinition
        self.dsmTitleLabel.font = Font.BoldFontSize.boldFont20
        
        // MARK: - TextView
        self.dsmDetailTextView.alpha      = Alpha.alpha8
        self.dsmDetailTextView.isEditable = false
    }
    
    func getWordDetail(word: String, collection: String){
        
        self.comorbidList.removeAll(keepingCapacity: false)
        self.comorbidOneList.removeAll(keepingCapacity: false)
        
        GetWordDetailInfo.getWordDetailInfo(vc: self, word: word, language: collection) { worddetailModels, comorbidArray, comorbidOneArray in
            
            self.wordLabel.text             = worddetailModels.word
            self.definitionDetailLabel.text = worddetailModels.definition
            self.dsmDetailTextView.text     = worddetailModels.dsmV
            self.wordEN                     = worddetailModels.wordEN
            
            self.comorbidList     = comorbidArray
            self.comorbidOneList  = comorbidOneArray
            self.comorbidTableView.reloadData()
        }
    }
    
    @IBAction func languageSegmentedControl(_ sender: Any) {
        if self.languageSegmentedControl.selectedSegmentIndex == 0 {
            getWordDetail(word: self.comingWord!, collection: FirebaseText.dictionaryTr)
        }else{
            getWordDetail(word: self.wordEN!, collection: FirebaseText.dictionaryEn)
        }
    }
    
}

extension WordDefinitionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comorbidOneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let text = self.comorbidOneList[indexPath.row]
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0x47, green: 0x2f, blue: 0x92),
            .font: UIFont.boldSystemFont(ofSize: 15),
        ]
        let attributedString      = NSAttributedString(string: text, attributes: attributes)
        let cell                  = UITableViewCell()
        cell.selectionStyle       = .none
        var content               = cell.defaultContentConfiguration()
        content.attributedText    = attributedString
        cell.contentConfiguration = content
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(Text.comorbid)(\(self.comorbidOneList.count))"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

