//
//  TodayViewController.swift
//  DaysLeft Extension
//
//  Created by neil on 9/15/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UITableViewController, NCWidgetProviding {
  
  lazy var coreDataStack = CoreDataStack(modelName: "DaysLeft")

  lazy var bigdays = coreDataStack.mostRecentDay()
  

  
  
  @IBOutlet weak var textBackground: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
      completionHandler(NCUpdateResult.newData)
  }
  
//  override func numberOfSections(in tableView: UITableView) -> Int {
//    if bigdays.count > 0 {
//      self.tableView.backgroundView = nil
//    } else {
//      
//      let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0,
//                                                       y: 0,
//                                                       width: tableView.bounds.size.width,
//                                                       height: tableView.bounds.size.height))
//      noDataLabel.text = "No Days"
//      noDataLabel.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
//      noDataLabel.textAlignment = NSTextAlignment.center
//      self.tableView.backgroundView = noDataLabel
//      
//    }
//    return 1
//  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  bigdays.count }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let day = bigdays[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "BigDayOnToday", for: indexPath)
    
    if let bigdayTableViewCell = cell as? TodayTableViewCell {
      bigdayTableViewCell.bigday = day
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    extensionContext?.open(URL(string: "daysleft://more")!, completionHandler: nil)
  }
  
  // Show less/more
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

    if (activeDisplayMode == NCWidgetDisplayMode.compact) {
      self.preferredContentSize = maxSize
    } else {
      let maxHeight = bigdays.count * 38
      self.preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(maxHeight))
    }
  }
//
//  private func updateDayTextBackgroundColor() {
//    textBackground.backgroundColor = daybgColorP3
//    textBackground.layer.cornerRadius = 5.0
//  }
//
}

