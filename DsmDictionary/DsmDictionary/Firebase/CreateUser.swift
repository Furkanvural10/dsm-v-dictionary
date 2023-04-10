//
//  CreateUser.swift
//  DsmDictionary
//
//  Created by furkan vural on 10.04.2023.
//

import Foundation
import FirebaseAuth

struct CreateUsers {
    
    static func createUser(vc: UIViewController){
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            Auth.auth().signInAnonymously { data, error in
                if error != nil {
                    Alert.showFirebaseSignInError(on: vc, message: error!.localizedDescription)
                }
            }
        }
    }
}
