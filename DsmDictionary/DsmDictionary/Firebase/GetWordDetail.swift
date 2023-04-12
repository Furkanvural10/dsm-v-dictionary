import Foundation
import FirebaseFirestore


struct GetWordDetailInfo{
    
    static func getWordDetailInfo(vc: UIViewController, word: String, language: String, completion: @escaping (WordDetailModel, [String], [String]) -> Void){
        let database = Firestore.firestore()
        var comorbidList = [String]()
        var comorbidOneList = [String]()
        var wordEn: String?
        

        let myCollection = database.collection(language).whereField("word", isEqualTo: word)
        myCollection.addSnapshotListener { snapshot, error in
            if error == nil {
                for i in snapshot!.documents{
                    if let comorbid = i.get(FirebaseText.getComorbid) as? String{
                        comorbidList.append(comorbid)
                        for i in comorbidList{
                            let element = i.components(separatedBy: ", ")
                            comorbidOneList.append(contentsOf: element)
                            
                        }
                    }
                    
                    let word = i.get(FirebaseText.getWord) as! String
                    let definition = i.get(FirebaseText.getDefinition) as! String
                    let dsmV = i.get(FirebaseText.getdsmV) as! String
                    if let wordEnglish = i.get(FirebaseText.getWordEN) as? String{
                        wordEn = wordEnglish
                    }else{wordEn = ""}
                    
                    let wordDetail: WordDetailModel = WordDetailModel(word: word, definition: definition, dsmV: dsmV, wordEN: (wordEn!))
                    completion(wordDetail, comorbidList, comorbidOneList)
                }
            }else{
                Alert.showFirebaseReadDataError(on: vc, message: Text.errorMessage)
            }
        }
        
    }
    
}
