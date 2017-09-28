//
//  BigDayForSycn.swift
//  DaysLeft
//
//  Created by neil on 9/27/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import Foundation

class BigDayForSync: NSObject, NSCoding {
    
    override init() {
        super.init()
    }
    
    var title = ""
    var dueDate = NSDate()
    var day_description = ""
    var repeatKind = "None"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "Title")
        aCoder.encode(dueDate, forKey: "dueDate")
        aCoder.encode(day_description, forKey: "day_description")
        aCoder.encode(repeatKind, forKey: "repeatKind")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "Title") as! String
        dueDate = aDecoder.decodeObject(forKey: "dueDate") as! NSDate
        day_description = aDecoder.decodeObject(forKey: "day_description") as! String
        repeatKind = aDecoder.decodeObject(forKey: "repeatKind") as! String
        super.init()
    }
}
