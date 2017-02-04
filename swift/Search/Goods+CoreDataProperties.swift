//
//  Goods+CoreDataProperties.swift
//  
//
//  Created by guanho on 2017. 2. 4..
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Goods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goods> {
        return NSFetchRequest<Goods>(entityName: "Goods");
    }

    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var price: String?
    @NSManaged public var date: String?
    @NSManaged public var detail: String?
    @NSManaged public var saveDT: NSDate?

}
