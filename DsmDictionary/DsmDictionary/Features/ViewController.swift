import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var onboardingImage      : UIImageView!
    @IBOutlet weak var firstDefinitionLabel : UILabel!
    @IBOutlet weak var secondDefinitionLabel: UILabel!
    @IBOutlet weak var thirdDefinitionLabel : UILabel!
    @IBOutlet weak var getStartedButton     : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPass()
        configurationView()
        startAnimation()
        getOnboardingTextAndImage()
    }
    
    func checkPass(){
        let result = UserDefaults.standard.object(forKey: Text.finishedOnboarding)
        if (result as? Bool) != nil {
            self.performSegue(withIdentifier: Text.toSearchPageVC, sender: nil)
        }
    }
    
    private func getOnboardingTextAndImage(){
        GetOnboardingInfo.getOnboardingTextAndImage(vc: self) { onboarding in
            self.firstDefinitionLabel.text  = onboarding.defitinion1
            self.secondDefinitionLabel.text = onboarding.definition2
            self.thirdDefinitionLabel.text  = onboarding.definition3
            if let url                      = URL(string: onboarding.defitinion1){
                self.onboardingImage.kf.setImage(with: url)
            }
        }
    }
    
    func configurationView(){
        firstDefinitionLabel.textColor  = .black
        secondDefinitionLabel.textColor = .black
        thirdDefinitionLabel.textColor  = .black
        getStartedButton.tintColor      = .black
        onboardingImage.image           = Images.onboardingImage
        onboardingImage.contentMode     = .scaleAspectFit
        onboardingImage.clipsToBounds   = true
        getStartedButton.setTitle(Text.onboardingButtonTitle, for: .normal)
    }

    @IBAction func getStartedButton(_ sender: Any) {endOnboardingPage()}
    
    func startAnimation(){
        
        let duration             = 1.5
        let delay: TimeInterval  = 0
        let option               = UIView.AnimationOptions.curveEaseOut
         
        onboardingImage.alpha       = Alpha.alpha0
        firstDefinitionLabel.alpha  = Alpha.alpha0
        secondDefinitionLabel.alpha = Alpha.alpha0
        thirdDefinitionLabel.alpha  = Alpha.alpha0
        getStartedButton.alpha      = Alpha.alpha0
        
        UIView.animate(withDuration: duration, delay: delay, options: option) {
            
            self.onboardingImage.alpha = Alpha.alpha
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: delay, options: option) {
                self.firstDefinitionLabel.alpha = Alpha.alpha
            } completion: { _ in
                UIView.animate(withDuration: duration, delay: delay, options: option) {
                    self.secondDefinitionLabel.alpha = Alpha.alpha
                } completion: { _ in
                    UIView.animate(withDuration: duration, delay: delay, options: option) {
                        self.thirdDefinitionLabel.alpha = Alpha.alpha
                    } completion: { _ in
                        UIView.animate(withDuration: duration, delay: delay, options: option) {
                            self.getStartedButton.alpha = Alpha.alpha
                        }
                    }
                }
            }
        }
    }
    
    func endOnboardingPage(){
        
        UserDefaults.standard.setValue(true, forKey: Text.finishedOnboarding)
        self.getStartedButton.isMultipleTouchEnabled = false
        
        let duration              = 0.8
        let buttonDuration        = 1.0
        let delay: TimeInterval   = 0
        let option                = UIView.AnimationOptions.curveEaseOut
        let translationX: CGFloat = 500
        let translationY: CGFloat = 0

        UIView.animate(withDuration: duration, delay: delay, options: option) {

            self.getStartedButton.alpha = Alpha.alpha0
        } completion: { _ in
            UIView.animate(withDuration: duration, delay: delay) {
                self.onboardingImage.alpha = Alpha.alpha0
                self.firstDefinitionLabel.transform = CGAffineTransform(translationX: translationX, y: translationY)
            } completion: { _ in
                UIView.animate(withDuration: duration, delay: delay) {
                    self.secondDefinitionLabel.transform = CGAffineTransform(translationX: translationX, y: translationY)
                } completion: { _ in
                    UIView.animate(withDuration: duration, delay: delay) {
                        self.thirdDefinitionLabel.transform = CGAffineTransform(translationX: translationX, y: translationY)
                    } completion: { _ in
                        UIView.animate(withDuration: buttonDuration, delay: delay, options: option) {
                            self.performSegue(withIdentifier: Text.toSearchPageVC, sender: nil)
                        }
                    }
                }
            }
        }
    }
}

