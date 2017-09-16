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
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
      completionHandler(NCUpdateResult.newData)
  }
  
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
}

