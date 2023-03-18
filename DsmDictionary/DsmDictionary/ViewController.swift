//
//  ViewController.swift
//  DsmDictionary
//
//  Created by furkan vural on 18.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var onboardingImage: UIImageView!
    
    @IBOutlet weak var firstDefinitionLabel: UILabel!
    
    @IBOutlet weak var secondDefinitionLabel: UILabel!
    
    @IBOutlet weak var thirdDefinitionLabel: UILabel!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurationView()
    }
    
    
    func configurationView(){
        
        // MARK: - Constants
        
        
        // MARK: - Labels Configuration
        firstDefinitionLabel.text  = "Definition-1"
        secondDefinitionLabel.text = "Definition-2"
        thirdDefinitionLabel.text  = "Definition-3"
        
        // MARK: - Button configuration
        getStartedButton.setTitle("Button Title", for: .normal)
        
        
        // MARK: - ImageView configuration
        onboardingImage.image = UIImage(named: "Onboarding")
        
        
    }

    @IBAction func getStartedButton(_ sender: Any) {
        
        
        
    }
    
}

