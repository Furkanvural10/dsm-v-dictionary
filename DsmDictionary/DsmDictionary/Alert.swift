//
//  Alert.swift
//  DsmDictionary
//
//  Created by furkan vural on 23.03.2023.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(button)
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showCoreDataError(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Hata", message: "Veriler getirilirken bir hata oluştu. Bir süre sonra tekrar deneyiniz")
    }
}
