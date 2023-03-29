//
//  WordDefinitionVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 28.03.2023.
//

import UIKit

class WordDefinitionVC: UIViewController {
    

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var definitionDetailLabel: UILabel!
    @IBOutlet weak var dsmTitleLabel: UILabel!
    @IBOutlet weak var comorbidTableView: UITableView!
    @IBOutlet weak var dsmDetailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        
    }
    
    private func configurationView(){
        self.comorbidTableView.delegate = self
        self.comorbidTableView.dataSource = self
        
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
        
        //MARK: - DefinitionLabel
        self.definitionDetailLabel.text = "Schizophrenia is a serious mental disorder in which people interpret reality abnormally. Schizophrenia may result in some combination of hallucinations, delusions, and extremely disordered thinking and behavior that impairs daily functioning, and can be disabling."
//        self.definitionDetailLabel.numberOfLines = 0
        self.definitionDetailLabel.font = .systemFont(ofSize: 14)
        self.definitionDetailLabel.adjustsFontSizeToFitWidth = true
        
        

    }
}

extension WordDefinitionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.comorbidTableView.dequeueReusableCell(withIdentifier: "comorbidID1", for: indexPath) as! ComorbidTableViewCell
        cell.comorbirLabel1.text = "Deneme1"
        cell.comorbidLabel2.text = "Deneme2"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comorbid"
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
