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

    @IBAction func remindButton(_ sender: Any) {
    }
    @IBOutlet weak var title: UILabel!
  @IBOutlet weak var bigDate: UILabel!
  @IBOutlet weak var leftDays: UILabel!
  @IBOutlet weak var leftDayTag: UILabel!
  
  var bigday: BigDay? {
      didSet { updateUI() }
  }
  
  let dateNow = Date()

  let daysUntilColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
  let daysLeftColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
  
  
  private func updateUI() {
      title?.text = bigday?.title
    
      guard let days = bigday?.diffDays(dateNow: dateNow) else {
          return
      }
    
      if days >= 0 {
        leftDays?.text = String(days)
        leftDayTag?.text = "DAYS LEFT"
        leftDayTag?.textColor = daysLeftColor
        leftDays?.textColor = daysLeftColor
      } else {
          leftDays?.text = String(-(days))
          leftDayTag?.text = "DAYS UNTIL"
          leftDayTag?.textColor = daysUntilColor
          leftDays?.textColor = daysUntilColor
      }
    
      if let theDate = bigday?.big_date {
          bigDate?.text = formatDate(theDate: theDate)
      } else {
          bigDate?.text = ""
      }
  }
  
  private func formatDate(theDate: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      let formatResultString = formatter.string(from: theDate)
    
      return formatResultString
  }
}
