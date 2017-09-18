//
//  TodayTableViewCell.swift
//  DaysLeft Extension
//
//  Created by viviJIE on 9/16/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {


  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var leftDays: UILabel!
  @IBOutlet weak var bgColorView: UIView!
  
  var bigday: BigDay? {
    didSet { updateUI() }
  }
  
  let daybgColorP3 = UIColor(displayP3Red: 77.0/255, green: 170.0/255, blue: 234.0/255, alpha: 1)
  
  let dateNow = Date()

  private func updateUI() {
    title?.text = bigday?.title

    guard let days = bigday?.diffDays(dateNow: dateNow) else {
      return
    }    
    
    if days >= 0 {
      leftDays?.text = String(days) + " Days"
    } else {
      leftDays?.text = String(-(days)) + " Days"
    }
    
    bgColorView.backgroundColor = daybgColorP3
    bgColorView.layer.cornerRadius = 8.0
  }
}
