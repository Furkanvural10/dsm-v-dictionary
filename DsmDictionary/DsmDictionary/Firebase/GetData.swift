//
//  GetData.swift
//  DsmDictionary
//
//  Created by furkan vural on 10.04.2023.
//

import Foundation
import FirebaseFirestore

private let database = Firestore.firestore()
struct GetDataFromFirebase {
    
    
    static func getDailyWord(vc: UIViewController, completion: @escaping (String, String, String) -> Void){
        var word: String = ""
        var definition: String = ""
        var urlString: String = ""
        
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
    
    static func getOnboardingTextAndImage(vc: UIViewController, completion: @escaping (String, String, String, String) -> Void){
        var firstDefinitionLabel = ""
        var secondDefinitionLabel = ""
        var thirdDefinitionLabel = ""
        var urlString = ""

        let collection = database.collection(FirebaseText.onboardingCollection)
        collection.addSnapshotListener { snapshot, error in
            if error == nil {
                for document in snapshot!.documents {
                    if let wordDefinition1 = document.get(FirebaseText.onboardingDefinition1) as? String {
                        firstDefinitionLabel = wordDefinition1
                    }
                    if let wordDefinition2 = document.get(FirebaseText.onboardingDefinition2) as? String {
                        secondDefinitionLabel = wordDefinition2
                    }
                    if let wordDefinition3 = document.get(FirebaseText.onboardingDefinition3) as? String {
                        thirdDefinitionLabel = wordDefinition3
                    }
                    if let imageUrl = document.get(FirebaseText.imageUrlText) as? String{
                        urlString = imageUrl
                    }
                    completion(firstDefinitionLabel, secondDefinitionLabel, thirdDefinitionLabel, urlString)
                }
            }else{
                Alert.showFirebaseReadDataError(on: vc, message: Text.errorMessage)
            }
        }
        
    }
}
