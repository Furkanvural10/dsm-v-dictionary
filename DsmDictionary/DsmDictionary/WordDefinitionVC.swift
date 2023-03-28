//
//  WordDefinitionVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 28.03.2023.
//

import UIKit

class WordDefinitionVC: UIViewController {
    
    
    @IBOutlet weak var mainWordView: UIView!
    @IBOutlet weak var wordInTheMainView: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var definitionTitle: UILabel!
    @IBOutlet weak var definitionMainView: UIView!
    @IBOutlet weak var wordDefinitionTextView: UITextView!
    
    var clickedFavButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationView()
    }
    
    private func configurationView(){
        
        
        //MARK: - MainView
        self.mainWordView.backgroundColor = UIColor(red: 0x37, green: 0x17, blue: 0x77)
        self.mainWordView.layer.cornerRadius = 10
        mainWordView.layer.shadowColor = UIColor.gray.cgColor
        mainWordView.layer.shadowOpacity = 0.4
        mainWordView.layer.shadowOffset = .zero
        mainWordView.layer.shadowRadius = 10
        
        //MARK: - MainWord
        self.wordInTheMainView.font = .boldSystemFont(ofSize: 25)
        self.wordInTheMainView.textColor = .white
        self.wordInTheMainView.text = "Şizofreni"
        
        
        // MARK: - Fav Button
        self.favButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.favButton.tintColor = .white
        
        
        // MARK: - Definition Label
        self.definitionTitle.text = "Açıklama"
        self.definitionTitle.font = .boldSystemFont(ofSize: 20)
        
        
        // MARK: - MainTextView
        
        self.definitionMainView.layer.cornerRadius = 10
        self.definitionMainView.layer.shadowColor = UIColor.gray.cgColor
        self.definitionMainView.layer.shadowOpacity = 0.4
        self.definitionMainView.layer.shadowOffset = .zero
        self.definitionMainView.layer.shadowRadius = 10
        
        // MARK: - TextView
        self.wordDefinitionTextView.layer.cornerRadius = 10
        
        
        // MARK: - Word Definition
        wordDefinitionTextView.isEditable = false
        
        let txtString = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet"
        wordDefinitionTextView.text = "\t\(txtString)"
        
    }

    @IBAction func favButton(_ sender: Any) {
        
        if !clickedFavButton{
            self.favButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            clickedFavButton = !clickedFavButton
        }else{
            self.favButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            clickedFavButton = !clickedFavButton
        }
        
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
