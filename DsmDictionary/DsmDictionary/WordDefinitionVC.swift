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
    }
}

extension WordDefinitionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "Deneme"
        cell.contentConfiguration = content
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
