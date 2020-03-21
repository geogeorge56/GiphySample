//
//  Favorite+CoreDataProperties.swift
//  GifySampleProject
//
//  Created by user on 14/02/20.
//  Copyright © 2020 user. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var attribute: String?
    @NSManaged public var height: String?
    @NSManaged public var rating: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var width: String?
    @NSManaged public var favId: String?

}
