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
        _ = NSEntityDescription.insertNewObject(forEntityName: Text.entityNameLastSearchWord, into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Text.entityNameLastSearchWord)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Text.entityLastSearchAttributeCreatedAtName, ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for i in result as! [NSManagedObject]{
                if let word = i.value(forKey: Text.entityLastSearchAttributeWordName) as? String {
                    wordList.append(word)
                }
                if let id = i.value(forKey: Text.entityLastSearchAttributeIDName) as? UUID {
                    wordIDList.append(id)
                }
                if let date = i.value(forKey: Text.entityLastSearchAttributeCreatedAtName) as? Date {
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
        _ = NSEntityDescription.insertNewObject(forEntityName: Text.entityNameFavWord, into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Text.entityNameFavWord)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Text.entityAttributeFavCreatedAtName, ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for i in result as! [NSManagedObject]{
                if let word = i.value(forKey: Text.entityAttributeFavWordName) as? String {
                    favoriteWordList.append(word)
                    
                }
                if let id = i.value(forKey: Text.entityAttributeFavIDName) as? UUID {
                    favoriteWordIDList.append(id)
                    
                }
                if let date = i.value(forKey: Text.entityAttributeFavCreatedAtName) as? Date {
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Text.entityNameLastSearchWord)
        let idString = wordIDList[indexPath].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                for i in result as! [NSManagedObject]{
                    if let id = i.value(forKey: Text.entityLastSearchAttributeIDName) as? UUID{
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Text.entityNameFavWord)
        let idString = favWordListID[indexPath].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                for i in result as! [NSManagedObject]{
                    if let id = i.value(forKey: Text.entityAttributeFavIDName) as? UUID{
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
    
    static func deleteFirsThenSaveWordCoreData(vc: UIViewController, choosedWord: String, completion: @escaping (Bool) -> Void){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Text.entityNameLastSearchWord)
        let word = choosedWord
        fetchRequest.predicate = NSPredicate(format: "word = %@", word)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                for i in result as! [NSManagedObject]{
                    if let _ = i.value(forKey: Text.entityLastSearchAttributeWordName) as? String{
                        context.delete(i)
                        do{
                            try context.save()
                        }
                        catch {
                            Alert.showCoreDataError(on: vc)
                        }
                        break
                    }
                }
            }
        }
        catch {Alert.showCoreDataError(on: vc)}
        
        let lastSearchWord = NSEntityDescription.insertNewObject(forEntityName: Text.entityNameLastSearchWord, into: context)
        lastSearchWord.setValue(choosedWord, forKey: Text.entityLastSearchAttributeWordName)
        lastSearchWord.setValue(UUID(), forKey: Text.entityLastSearchAttributeIDName)
        lastSearchWord.setValue(Date(), forKey: Text.entityLastSearchAttributeCreatedAtName)
        
        do {
            try context.save()
            completion(true)
        }
        catch {Alert.showCoreDataError(on: vc)}
        completion(false)
    }
    
    static func saveWordToCoreData(vc: UIViewController, choosedWord: String, completion: @escaping (Bool) -> Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lastSearchWord = NSEntityDescription.insertNewObject(forEntityName: Text.entityNameLastSearchWord, into: context)
        lastSearchWord.setValue(choosedWord, forKey: Text.entityLastSearchAttributeWordName)
        lastSearchWord.setValue(UUID(), forKey: Text.entityLastSearchAttributeIDName)
        lastSearchWord.setValue(Date(), forKey: Text.entityLastSearchAttributeCreatedAtName)
        do{
            try context.save()
            completion(true)
        }
        catch   {
            Alert.showCoreDataError(on: vc)
            completion(false)
        }
    }
}
