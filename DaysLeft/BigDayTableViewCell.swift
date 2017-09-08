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
        
        if let theDate = bigday?.big_date {
            guard let days = bigday?.diffDays(dateNow: dateNow) else {
                return
            }
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
    

    
}
