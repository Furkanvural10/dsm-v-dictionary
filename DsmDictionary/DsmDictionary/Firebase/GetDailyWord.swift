import Foundation
import FirebaseFirestore


struct GetDailyWordDataFromFirebase {
    
    
    static func getDailyWord(vc: UIViewController, completion: @escaping (DailyWordModel) -> Void){
        let database = Firestore.firestore()
        
        let myCollection = database.collection(FirebaseText.wordCollection)
        myCollection.addSnapshotListener { snapshot, error in
            if error == nil {
                for i in snapshot!.documents{
                    if let dailyWord = i.get(FirebaseText.dailyWord) as? String{
                        if let definition = i.get(FirebaseText.definition) as? String{
                            if let imageUrl = i.get(FirebaseText.imageUrlText) as? String{
                                let dailyWord: DailyWordModel = DailyWordModel(dailyWord: dailyWord, definition: definition, imageUrl: imageUrl)
                                completion(dailyWord)
                            }
                        }
                        
                    }
                    
                    
                }
                
            }
            else{
                Alert.showFirebaseReadDataError(on: vc, message: Text.errorMessage )
            }
        }
        
    }
    

}
