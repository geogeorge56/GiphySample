//
//  DataLayer.swift
//  GifySampleProject
//
//  Created by user on 14/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class DataLayer: NSObject {
    
    static let sharedInstance = DataLayer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    
    
    /*
     * Gets Favorite Object based on favoriteid
     */
    func getFavoriteGiphyWith(id giphyId:String) -> Favorite?{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Favorite.className)
        
        fetchRequest.predicate = NSPredicate(format: "favId == %@", giphyId)
        do{
            let results = try mainContext.fetch(fetchRequest) as! [Favorite]
            if(results.count > 0){
                return results.first
            }
        }
        catch let error as NSError{
            print(error)
        }
        return nil
    }
    
    /*
      * Gets All Favorite Objects
      */
    func getAllFavorites() -> [Favorite]?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Favorite.className)
           do{
               let results = try mainContext.fetch(fetchRequest) as! [Favorite]
               if(results.count > 0)
               {
                   return results
               }
           }
           catch let error as NSError{
               print(error)
           }
           return nil
    }
    
    /*
    * Creates and saves new giphy object
    */
    func saveGiphyData(from giphyModel:Datum)
    {
        let favGiphy = NSEntityDescription.insertNewObject(forEntityName: "Favorite",
                                                           into: mainContext) as! Favorite
        favGiphy.favId = giphyModel.id
        favGiphy.title = giphyModel.title
        favGiphy.rating = giphyModel.rating
        favGiphy.url = giphyModel.images.downsized.url
        favGiphy.height = giphyModel.images.downsized.height
        favGiphy.width = giphyModel.images.downsized.width
        
        
        performSaveInMainContext()
    }
    
    /*
    * Delete a giphy object based on id
    */
    func deleteFavoriteGiphy(with id:String)
    {
        let favGiphy = getFavoriteGiphyWith(id: id)
        if favGiphy != nil
        {
            mainContext.delete(favGiphy!)
        }
        performSaveInMainContext();
        
    }
    
    
    /*
      * Saves in main context
      */
     func performSaveInMainContext()
     {
         do{
             try mainContext.save()
         }
         catch{
             print("Failure to save context: \(error)")
         }
     }

}

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
