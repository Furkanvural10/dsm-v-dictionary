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
        
        // MARK: - Labels Configuration
        firstDefinitionLabel.text  = "Definition-1"
        secondDefinitionLabel.text = "Definition-2"
        thirdDefinitionLabel.text  = "Definition-3"
        
        // MARK: - Button configuration
        let buttonTitle = "Başla"
        getStartedButton.setTitle(buttonTitle, for: .normal)
        getStartedButton.tintColor = .black
        
        // MARK: - ImageView configuration
        onboardingImage.image = UIImage(named: "Onboarding")
        onboardingImage.contentMode = .scaleAspectFit
        onboardingImage.clipsToBounds = true
    }

    @IBAction func getStartedButton(_ sender: Any) { endOnboardingPage() }
    
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
                        }
                    }

                }

            }

        }

    }
    
    func endOnboardingPage(){
        
        // MARK: - Constant
        let duration = 0.8
        let buttonDuration = 1.5
        let delay: TimeInterval = 0
        let option = UIView.AnimationOptions.curveEaseOut
        let translationX: CGFloat = 500
        let translationY: CGFloat = 0
         
        
        
        UIView.animate(withDuration: duration, delay: delay, options: option) {
            // Nonvisible imageView
            self.onboardingImage.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: delay) {
                // Disappear first definition
                self.firstDefinitionLabel.transform = CGAffineTransform(translationX: translationX, y: translationY)
            } completion: { _ in
                UIView.animate(withDuration: duration, delay: delay) {
                    // Disappear second definition
                    self.secondDefinitionLabel.transform = CGAffineTransform(translationX: translationX, y: translationY)
                } completion: { _ in
                    UIView.animate(withDuration: duration, delay: delay) {
                        // Disappear third definition
                        self.thirdDefinitionLabel.transform = CGAffineTransform(translationX: translationX, y: translationY)
                    } completion: { _ in
                        // Disappear getStartedbutton
                        UIView.animate(withDuration: buttonDuration, delay: delay, options: option) {
                            self.getStartedButton.transform = CGAffineTransform(translationX: translationX, y: translationY)
                            self.getStartedButton.alpha = 0
                        } completion: { _ in
                            self.performSegue(withIdentifier: "toSearchPageVC", sender: nil)
                        }

                    }

                }

            }

        }
        
    }
    
}

