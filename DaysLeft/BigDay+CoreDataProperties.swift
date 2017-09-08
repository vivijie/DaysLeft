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
    
    func diffDays(dateNow: Date) -> Int {
        let dateNow = dateNow
        let repeatKind = repeat_type
        let dateCreated = big_date!
        var diffDays: Int
        
        if repeatKind == "None" {
            let calendar = Calendar.current
            
            let dateNowInit = calendar.startOfDay(for: dateNow)
            let dateDueInit = calendar.startOfDay(for: dateCreated)
            
            diffDays =  Int(dateDueInit.timeIntervalSince(dateNowInit) / (60*60*24))
            
        } else if repeatKind == "Week" {
            let dateNowComponents = NSCalendar.current.component(Calendar.Component.weekday, from: dateNow)
            let dateCreatedComponents = NSCalendar.current.component(Calendar.Component.weekday, from: dateCreated)
            
            diffDays =  dateCreatedComponents - dateNowComponents
            
            if diffDays < 0 {
                diffDays += 7
            }
            
        } else if repeatKind == "Month" {
            let dateNowComponents = NSCalendar.current.component(Calendar.Component.day, from: dateNow)
            let dateCreatedComponents = NSCalendar.current.component(Calendar.Component.day, from: dateCreated)
            
            diffDays = dateCreatedComponents - dateNowComponents
            
            if diffDays < 0 {
                diffDays += getRangeDays(rangeType: .month, dateNow: dateNow)
            }
            
        } else if repeatKind == "Year" {
            let calendar = Calendar.current
            let yearNow = NSCalendar.current.component(Calendar.Component.year, from: dateNow)
            let month = NSCalendar.current.component(Calendar.Component.month, from: dateCreated)
            let day = NSCalendar.current.component(Calendar.Component.day, from: dateCreated)
            
            let dateComponentsDueNextYear = DateComponents(year: yearNow, month: month, day: day)
            let dateDueNextYear = calendar.date(from: dateComponentsDueNextYear)
            let dateNowInit = calendar.startOfDay(for: dateNow)
            
            diffDays = Int(dateDueNextYear!.timeIntervalSince(dateNowInit) / (60*60*24))
            
            if diffDays < 0 {
                diffDays += getRangeDays(rangeType: .year, dateNow: dateNow)
            }
            
        } else {
            diffDays = 8888
        }
        return diffDays
    }
    
    private func getRangeDays(rangeType: Calendar.Component, dateNow: Date) -> Int {
        let calendar = Calendar.current
        
        let year = NSCalendar.current.component(Calendar.Component.year, from: dateNow)
        let month = NSCalendar.current.component(Calendar.Component.month, from: dateNow)
        
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)
        
        let range = calendar.range(of: .day, in: rangeType, for: date!)!
        let numDays = range.count
        print("dateNow: \(dateNow)")
        print("numDays: \(numDays)")
        return numDays
    }


}
