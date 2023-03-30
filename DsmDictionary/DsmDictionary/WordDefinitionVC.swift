//
//  WordDefinitionVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 28.03.2023.
//

import UIKit
import CoreData

class WordDefinitionVC: UIViewController {
    

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var definitionDetailLabel: UILabel!
    @IBOutlet weak var dsmTitleLabel: UILabel!
    @IBOutlet weak var comorbidTableView: UITableView!
    @IBOutlet weak var dsmDetailTextView: UITextView!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    
    var clickedBookmark = false
    var comingWord = "Bellek"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        
        
    }

    
    @IBAction func bookmarkButton(_ sender: Any) {
        if !clickedBookmark{
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
            saveWordToCoredata(word: comingWord)
            clickedBookmark = !clickedBookmark
        }else{
            bookmarkButton.image = UIImage(systemName: "bookmark")
            clickedBookmark = !clickedBookmark
            deleteWordFromCoredata(word: comingWord)
        }
    }
    
    private func saveWordToCoredata(word: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let favWord = NSEntityDescription.insertNewObject(forEntityName: "FavoriteWord", into: context)
        
        favWord.setValue(word, forKey: "favWord")
        favWord.setValue(UUID(), forKey: "id")
        favWord.setValue(Date(), forKey: "createdAt")
        
        do {
            try context.save()
            print("Kaydedilen kelime \(word)")
            
        } catch  {
            Alert.showCoreDataError(on: self)
        }
    }
    private func deleteWordFromCoredata(word: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteWord")
        let deletedWord = word
        fetchRequest.predicate = NSPredicate(format: "favWord = %@", deletedWord)
        
        do {
            let result =  try context.fetch(fetchRequest)
            for i in result as! [NSManagedObject]{
                if let _ = i.value(forKey: "favWord") as? String{
                    context.delete(i)
                    break
                }
            }
        } catch  {
            Alert.showCoreDataError(on: self)
        }
    }
    
    
    private func configurationView(){
        
        //MARK: TableView
        self.comorbidTableView.delegate = self
        self.comorbidTableView.dataSource = self
        self.comorbidTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        
        
        // MARK: - Bookmark Button
        self.bookmarkButton.image = UIImage(systemName: "bookmark")
        
        // MARK: - Word
        self.wordLabel.text = "WORD"
        self.wordLabel.font = .boldSystemFont(ofSize: 30)
        
        // MARK: - SegmentedController
        self.languageSegmentedControl.setTitle("Türkçe", forSegmentAt: 0)
        self.languageSegmentedControl.setTitle("English", forSegmentAt: 1)
        self.languageSegmentedControl.selectedSegmentTintColor = UIColor(red: 0x47, green: 0x2f, blue: 0x92)
        self.languageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // MARK: - DefinitiontTitleLabel
        self.definitionLabel.text = "Açıklama"
        self.definitionLabel.font = .boldSystemFont(ofSize: 20)
        
        //MARK: - DefinitionDetailLabel
        self.definitionDetailLabel.text = "Schizophrenia is a serious mental disorder in which people interpret reality abnormally. Schizophrenia may result in some combination of hallucinations, delusions, and extremely disordered thinking and behavior that impairs daily functioning, and can be disabling."
        self.definitionDetailLabel.font = .systemFont(ofSize: 15)
        self.definitionDetailLabel.alpha = 0.6
        self.definitionDetailLabel.adjustsFontSizeToFitWidth = true
        
        //MARK: - DSM-V Title
        self.dsmTitleLabel.text = "DSM-V"
        self.dsmTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        // MARK: - TextView
        self.dsmDetailTextView.text = "Schizophrenia is a serious mental disorder in which people interpret reality abnormally. Schizophrenia may result in some combination of hallucinations, delusions, and extremely disordered thinking and behavior that impairs daily functioning, and can be disabling."
        self.dsmDetailTextView.alpha = 0.6
        self.dsmDetailTextView.isEditable = false
        
        

    }
}

extension WordDefinitionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let text = "Şizofreni"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0x47, green: 0x2f, blue: 0x92),
            .font: UIFont.boldSystemFont(ofSize: 15),
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        var content = cell.defaultContentConfiguration()
        content.attributedText = attributedString
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comorbid - (5)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
