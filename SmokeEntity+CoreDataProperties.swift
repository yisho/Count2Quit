//
//  SmokeEntity+CoreDataProperties.swift
//  Count2Quit
//
//  Created by yisho on 4/22/17.
//  Copyright © 2017 yisho. All rights reserved.
//

import Foundation
import CoreData


extension SmokeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SmokeEntity> {
        return NSFetchRequest<SmokeEntity>(entityName: "SmokeEntity")
    }

    @NSManaged public var brand: String?
    @NSManaged public var lat: Double
    @NSManaged public var totalSmoked: Int16
    @NSManaged public var totalUrges: Int16
    @NSManaged public var date: String?
    @NSManaged public var totalPrice: Double
    @NSManaged public var price: Double
    @NSManaged public var pic: NSData?
    @NSManaged public var long: Double

}
