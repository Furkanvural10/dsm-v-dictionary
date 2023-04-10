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
    
    static func getFavWordFromCoreData(vc: UIViewController) -> ([String], [UUID], [Date]){
        var favoriteWordList     = [String]()
        var favoriteWordIDList   = [UUID]()
        var favoriteWordCreateAt = [Date]()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        _ = NSEntityDescription.insertNewObject(forEntityName: "FavoriteWord", into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteWord")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for i in result as! [NSManagedObject]{
                if let word = i.value(forKey: "favWord") as? String {
                    favoriteWordList.append(word)
                    
                }
                if let id = i.value(forKey: "id") as? UUID {
                    favoriteWordIDList.append(id)
                    
                }
                if let date = i.value(forKey: "createdAt") as? Date {
                    favoriteWordCreateAt.append(date)
                }
            }
            
            
        } catch  {
            Alert.showCoreDataError(on: vc)
        }
        return (favoriteWordList, favoriteWordIDList, favoriteWordCreateAt)
    }
    
    static func deleteLastSearchWord(vc: UIViewController, indexPath: Int, indexPaths: IndexPath, wordIDList: [UUID]) -> Bool{
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastSearchWord")
        let idString = wordIDList[indexPath].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                for i in result as! [NSManagedObject]{
                    if let id = i.value(forKey: "id") as? UUID{
                        if id == wordIDList[indexPath]{
                            context.delete(i)
                            
                            do {
                                try context.save()
                            } catch  {
                                Alert.showCoreDataError(on: vc)
                                return false
                            }
                            break
                        }
                    }
                }
            }
        } catch  {
            Alert.showCoreDataError(on: vc)
            return false
        }
        return true
    }
    
    static func deleteFavoriteWord(vc: UIViewController, indexPath: Int, indexPaths: IndexPath, favWordListID: [UUID]) -> Bool{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteWord")
        let idString = favWordListID[indexPath].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                for i in result as! [NSManagedObject]{
                    if let id = i.value(forKey: "id") as? UUID{
                        if id == favWordListID[indexPath]{
                            context.delete(i)
                            
                            do {
                                try context.save()
                                
                            } catch  {
                                Alert.showCoreDataError(on: vc)
                                return false
                            }
                            break
                        }
                    }
                }
            }
        } catch  {
            Alert.showCoreDataError(on: vc)
            return false
        }
        return true
    }
}
