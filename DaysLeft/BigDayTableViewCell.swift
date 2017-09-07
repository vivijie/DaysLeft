//
//  BigDayTableViewCell.swift
//  DaysLeft
//
//  Created by viviJIE on 8/27/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit
import CoreData

class BigDayTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bigDate: UILabel!
    @IBOutlet weak var leftDays: UILabel!
    @IBOutlet weak var leftDayTag: UILabel!
    
    var bigday: BigDay? {
        didSet { updateUI() }
    }
    
    let dateNow = Date()
    
    
    private func updateUI() {
        title?.text = bigday?.title
        let repeatType = bigday?.repeat_type
        
        
        if let theDate = bigday?.big_date {
            let days = diffDays(dateNow: dateNow, dateCreated: theDate , repeatKind: repeatType)
            leftDays?.text = String(days)
            
            if days > 0 {
                leftDayTag?.text = "DAYS LEFT"
            } else {
                leftDayTag?.text = "DAYS UNTIL"
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            bigDate?.text = formatter.string(from: theDate)
        } else {
            bigDate?.text = nil
        }
    }
    

    private func diffDays(dateNow: Date, dateCreated: Date, repeatKind: String?) -> Int {
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
                diffDays = 7 + diffDays
            }
            
        } else if repeatKind == "Month" {
            let dateNowComponents = NSCalendar.current.component(Calendar.Component.day, from: dateNow)
            let dateCreatedComponents = NSCalendar.current.component(Calendar.Component.day, from: dateCreated)
            
            diffDays = dateCreatedComponents - dateNowComponents
            
            if diffDays < 0 {
                diffDays = getRangeDays(rangeType: .month) - dateCreatedComponents + dateNowComponents
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
                diffDays += getRangeDays(rangeType: .year)
            }
            
        } else {
            diffDays = 8888
        }
        return diffDays
    }
    
    private func getRangeDays(rangeType: Calendar.Component) -> Int {
        let calendar = Calendar.current
        
        let year = NSCalendar.current.component(Calendar.Component.year, from: dateNow)
        let month = NSCalendar.current.component(Calendar.Component.month, from: dateNow)
        
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)
        
        let range = calendar.range(of: .day, in: rangeType, for: date!)!
        let numDays = range.count
        print("numDays: \(numDays)")
        return numDays
    }
    
}
