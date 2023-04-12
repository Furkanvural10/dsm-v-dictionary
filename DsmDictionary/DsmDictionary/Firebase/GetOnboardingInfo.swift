import Foundation
import UIKit
import FirebaseFirestore

struct GetOnboardingInfo {
        
    static func getOnboardingTextAndImage(vc: UIViewController, completion: @escaping (OnboardingModel) -> Void){
        let database = Firestore.firestore()
        
        let collection = database.collection(FirebaseText.onboardingCollection)
        collection.addSnapshotListener { snapshot, error in
            if error == nil {
                for document in snapshot!.documents {
                    if let wordDefinition1 = document.get(FirebaseText.onboardingDefinition1) as? String {
                        if let wordDefinition2 = document.get(FirebaseText.onboardingDefinition2) as? String {
                            if let wordDefinition3 = document.get(FirebaseText.onboardingDefinition3) as? String {
                                if let imageUrl = document.get(FirebaseText.imageUrlText) as? String{
                                    let onboarding = OnboardingModel(defitinion1: wordDefinition1, definition2: wordDefinition2, definition3: wordDefinition3, imageUrl: imageUrl)
                                        completion(onboarding)
                                }
                            }
                        }
                    }
                }
            }else{
                Alert.showFirebaseReadDataError(on: vc, message: Text.errorMessage)
            }
        }
        
    }
    
    
}
