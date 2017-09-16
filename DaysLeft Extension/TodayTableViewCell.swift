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
  
  var bigday: BigDay? {
    didSet { updateUI() }
  }

  let dateNow = Date()

  private func updateUI() {
    title?.text = bigday?.title

    guard let days = bigday?.diffDays(dateNow: dateNow) else {
      return
    }

    if days >= 0 {
      leftDays?.text = String(days)
    } else {
      leftDays?.text = String(-(days))
      leftDays?.textColor = UIColor.brown
    }
  }
}
