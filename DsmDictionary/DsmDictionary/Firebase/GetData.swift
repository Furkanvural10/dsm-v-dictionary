//
//  GetData.swift
//  DsmDictionary
//
//  Created by furkan vural on 10.04.2023.
//

import Foundation
import FirebaseFirestore

struct GetDataFromFirebase {
    static func getDailyWord(vc: UIViewController, completion: @escaping (String, String, String) -> Void){
        var word: String = ""
        var definition: String = ""
        var urlString: String = ""
        let database = Firestore.firestore()
        let myCollection = database.collection(FirebaseText.wordCollection)
        myCollection.addSnapshotListener { snapshot, error in
            if error == nil {
                for i in snapshot!.documents{
                    if let wordFirebase = i.get(FirebaseText.dailyWord) as? String{
                        word = wordFirebase
                    }
                    if let wordDefinitionFirebase = i.get(FirebaseText.definition) as? String{
                        definition = wordDefinitionFirebase
                    }
                    if let imageUrl = i.get(FirebaseText.imageUrlText) as? String{
                        urlString = imageUrl
                        
                    }else{
                        Alert.showFirebaseReadDataError(on: vc, message: Text.errorMessage )
                    }
                }
                completion(word,definition,urlString)
            }
        }
        
    }
}
