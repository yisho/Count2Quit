//
//  CurrentBrand+CoreDataProperties.swift
//  Count2Quit
//
//  Created by yisho on 4/22/17.
//  Copyright © 2017 yisho. All rights reserved.
//

import Foundation
import CoreData


extension CurrentBrand {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentBrand> {
        return NSFetchRequest<CurrentBrand>(entityName: "CurrentBrand")
    }

    @NSManaged public var brand: String?
    @NSManaged public var price: Double

}
