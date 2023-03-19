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
        configurationView()
        startAnimation()
        
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
    
    func startAnimation(){
        
        // MARK: - Constant
        let duration = 1.5
        let delay: TimeInterval = 0
        let option = UIView.AnimationOptions.curveEaseOut
        
        
        
        onboardingImage.alpha = 0
        firstDefinitionLabel.alpha = 0
        secondDefinitionLabel.alpha = 0
        thirdDefinitionLabel.alpha = 0
        getStartedButton.alpha = 0
        
        
        UIView.animate(withDuration: duration, delay: delay, options: option) {
            // Showing Image
            self.onboardingImage.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: delay, options: option) {
                // Showing first definition
                self.firstDefinitionLabel.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: duration, delay: delay, options: option) {
                    self.secondDefinitionLabel.alpha = 1
                } completion: { _ in
                    UIView.animate(withDuration: duration, delay: delay, options: option) {
                        self.thirdDefinitionLabel.alpha = 1
                    } completion: { _ in
                        UIView.animate(withDuration: duration, delay: delay, options: option) {
                            self.getStartedButton.alpha = 1
                        } completion: { _ in
                            // Go to Searching Page
                        }

                    }

                }

            }

        }

    }
    
}

