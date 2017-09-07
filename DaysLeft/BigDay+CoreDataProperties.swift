//
//  BigDay+CoreDataProperties.swift
//  DaysLeft
//
//  Created by viviJIE on 8/27/17.
//  Copyright © 2017 tdones. All rights reserved.
//
//

import Foundation
import CoreData


extension BigDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigDay> {
        return NSFetchRequest<BigDay>(entityName: "BigDay")
    }

    @NSManaged public var big_date: Date?
    @NSManaged public var day_description: String?
    @NSManaged public var repeat_type: String?
    @NSManaged public var title: String?

}
