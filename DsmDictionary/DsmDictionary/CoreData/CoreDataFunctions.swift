//
//  CoreDataFunctions.swift
//  DsmDictionary
//
//  Created by furkan vural on 9.04.2023.
//

import Foundation
import UIKit
import CoreData

struct CoreDataFunctions {
    
    static func getLastWordFromCoreData(vc: UIViewController) -> ([String], [UUID], [Date]){
        var wordList = [String]()
        var wordIDList = [UUID]()
        var createdList = [Date]()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        _ = NSEntityDescription.insertNewObject(forEntityName: "LastSearchWord", into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearchWord")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for i in result as! [NSManagedObject]{
                if let word = i.value(forKey: "word") as? String {
                    wordList.append(word)
                }
                if let id = i.value(forKey: "id") as? UUID {
                    wordIDList.append(id)
                }
                if let date = i.value(forKey: "createdAt") as? Date {
                    createdList.append(date)
                }
            }
            
            
        } catch  {
            Alert.showCoreDataError(on: vc)
        }
        return (wordList, wordIDList, createdList)
    }
    
}
