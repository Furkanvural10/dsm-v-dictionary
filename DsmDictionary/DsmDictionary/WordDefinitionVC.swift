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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func favButton(_ sender: Any) {
    }
    
}
