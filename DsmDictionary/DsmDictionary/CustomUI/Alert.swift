import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: Text.okeyButtonTitle, style: .default)
        alert.addAction(button)
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showCoreDataError(on vc: UIViewController){
        showBasicAlert(on: vc, with: Text.errorTitle, message: Text.errorMessage)
    }
    
    static func showFirebaseSignInError(on vc: UIViewController, message: String){
        showBasicAlert(on: vc, with: Text.errorTitle, message: message)
    }
    
    static func showFirebaseReadDataError(on vc: UIViewController, message: String){
        showBasicAlert(on: vc, with: Text.errorTitle, message: message)
    }
    
    static func showBasicAlertMessage(on vc: UIViewController, title: String , message: String){
        showBasicAlert(on: vc, with: title, message: message)
    }
}
