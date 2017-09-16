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
  
  var ChecklistItem = ["A", "B"]
  
  // from Extension to App
  @IBAction func BackTo(_ sender: UIButton) {
    extensionContext?.open(URL(string: "daysleft://more")!, completionHandler: nil)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1 }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let day = ChecklistItem[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "BigDayOnToday", for: indexPath)
    return cell
  }
}

