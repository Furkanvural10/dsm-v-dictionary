import Foundation
import FirebaseFirestore

struct Searching {
    
    static func searchWord(vc: UIViewController, searchText: String, completion: @escaping ([String])-> Void){
        var searchResultList = [String]()
        let db = Firestore.firestore()
        let myCollection = db.collection(FirebaseText.searchCollection)
        if searchText != ""{
            myCollection.whereField(FirebaseText.word, isGreaterThanOrEqualTo: searchText)
                .whereField(FirebaseText.word, isLessThan: searchText + "\u{f8ff}").limit(to: 10)
                    .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Alert.showFirebaseReadDataError(on: vc, message: error.localizedDescription)
            } else {
                searchResultList.removeAll()
                for document in querySnapshot!.documents {
                    if let result = document.get(FirebaseText.word) as? String {
                        searchResultList.append(result)
                        completion(searchResultList)
                    }
                }
            }
        }

        }else{
            searchResultList.removeAll()
            completion(searchResultList)
        }
    }
}
