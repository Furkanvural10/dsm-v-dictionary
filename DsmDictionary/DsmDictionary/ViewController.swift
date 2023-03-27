//
//  ViewController.swift
//  DsmDictionary
//
//  Created by furkan vural on 18.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var firstDefinitionLabel: UILabel!
    @IBOutlet weak var secondDefinitionLabel: UILabel!
    @IBOutlet weak var thirdDefinitionLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUser()
        configurationView()
        startAnimation()
        getOnboardingTextAndImage()
    
    }
    private func createUser(){
            Auth.auth().signInAnonymously { data, error in
                if error != nil {
                    Alert.showFirebaseSignInError(on: self, message: error!.localizedDescription)
                }
            }
    }
    
    private func getOnboardingTextAndImage(){
        let database = Firestore.firestore()
        let collection = database.collection("Onboarding")
        collection.addSnapshotListener { snapshot, error in
            if error == nil {
                for document in snapshot!.documents {
                    if let wordDefinition1 = document.get("definition1") as? String {
                        self.firstDefinitionLabel.text = wordDefinition1
                    }
                    if let wordDefinition2 = document.get("definition2") as? String {
                        self.secondDefinitionLabel.text = wordDefinition2
                    }
                    if let wordDefinition3 = document.get("definition3") as? String {
                        self.thirdDefinitionLabel.text = wordDefinition3
                    }
                    if let imageUrl = document.get("imageUrl") as? String{
                        if let url = URL(string: imageUrl){
                            self.onboardingImage.kf.setImage(with: url)
                        }
                    }
                }
            }else{
                Alert.showFirebaseReadDataError(on: self, message: "Hata oluştu. Lütfen tekrar deneyin")
            }
        }
    }
    
    func configurationView(){
        
        
        // MARK: - Button configuration
        let buttonTitle = "Başla"
        getStartedButton.setTitle(buttonTitle, for: .normal)
        getStartedButton.tintColor = .black
        
        // MARK: - ImageView configuration
        onboardingImage.image = UIImage(named: "Onboarding")
        onboardingImage.contentMode = .scaleAspectFit
        onboardingImage.clipsToBounds = true
    }

    @IBAction func getStartedButton(_ sender: Any) {
        endOnboardingPage()
        
        
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
                        }
                    }

                }

            }

        }

    }
    
    func endOnboardingPage(){
        
        self.getStartedButton.isMultipleTouchEnabled = false
        // MARK: - Constant
        let duration = 0.8
        let buttonDuration = 1.0
        let delay: TimeInterval = 0
        let option = UIView.AnimationOptions.curveEaseOut
        let translationX: CGFloat = 500
        let translationY: CGFloat = 0
         
        
        
        UIView.animate(withDuration: duration, delay: delay, options: option) {
            // Nonvisible button
            self.getStartedButton.alpha = 0
            
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: delay) {
                // Disappear first definition and imageView
                self.onboardingImage.alpha = 0
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
                        // Go To SearchPage
                        UIView.animate(withDuration: buttonDuration, delay: delay, options: option) {
                            self.performSegue(withIdentifier: "toSearchPageVC", sender: nil)
                        }
                    }

                }

            }

        }
        
    }
    
}

