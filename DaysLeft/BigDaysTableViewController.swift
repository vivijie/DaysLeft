//
//  BigDaysTableViewController.swift
//  DaysLeft
//
//  Created by viviJIE on 8/27/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import UserNotifications

class BigDaysTableViewController: UITableViewController, AddBigDayViewControllerDelegate {
  
    var managedContext: NSManagedObjectContext!
    var bigdays: [BigDay] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSycnNotification()

        title = "YOUR DAYS"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BigDay")

        // Remove empty cells in UITableView
        tableView.tableFooterView = UIView(frame: .zero)
        // Set tableview background color
        tableView.backgroundColor = UIColor(displayP3Red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        fetchBigDays()
    }
    
    func fetchBigDays() {
        let fetchRequest:NSFetchRequest<BigDay> = BigDay.fetchRequest()
        
        do {
            bigdays = try managedContext.fetch(fetchRequest)
            sortByDaysLeft()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addBigDayViewControllerDidCancel(controller: AddBigDayViewController) {
      dismiss(animated: true, completion: nil)
    }

    // Add Row
    func addBigDayViewController(controller: AddBigDayViewController, title: String, date: Date, repeat_type: String, day_description: String) {

      let day = BigDay(entity: BigDay.entity(), insertInto: managedContext)

      day.title = title
      day.big_date = date
      day.repeat_type = repeat_type
      day.day_description = day_description
        
      do {
        bigdays.append(day)
        try managedContext.save()
        saveBigDayItemsToCloud()
      } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
      }
    
      sortByDaysLeft()
      saveBigDayItemsToCloud()
      self.tableView.reloadData()
      dismiss(animated: true, completion: nil)
    }

    // Edit Row
    func addBigDayViewController(controller: AddBigDayViewController, didFinishEditingItem item: BigDay) {

      do {
          try managedContext.save()
          saveBigDayItemsToCloud()
      } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
      }

      sortByDaysLeft()
      saveBigDayItemsToCloud()
      self.tableView.reloadData()
      dismiss(animated: true, completion: nil)
    }


    // Delete Row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

      let dayToDelete = bigdays[indexPath.row]
        
        if dayToDelete.day_description == "On" {
            UNUserNotificationCenter.current().removeNotification(dueDate: dayToDelete.big_date!)
        }
        
      managedContext.delete(dayToDelete)
      bigdays.remove(at: indexPath.row)
      do {
          try managedContext.save()
          tableView.deleteRows(at: [indexPath], with: .automatic)
          saveBigDayItemsToCloud()
      } catch let error as NSError {
          print("Saving error: \(error), description: \(error.userInfo)")
      }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int   {
    if bigdays.count > 0 {
      self.tableView.backgroundView = nil
    } else {
      
      let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: tableView.bounds.size.width,
                                                       height: tableView.bounds.size.height))
      noDataLabel.text = "tap + to add your days"
      noDataLabel.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
      noDataLabel.textAlignment = NSTextAlignment.center
      self.tableView.backgroundView = noDataLabel
      
    }
    return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return bigdays.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let day = bigdays[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "BigDayOne", for: indexPath)

      if let bigdayTableViewCell = cell as? BigDayTableViewCell {
          bigdayTableViewCell.bigday = day
      }
      return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "AddBigDay" {
          let navigationController = segue.destination as! UINavigationController
        
          let controller = navigationController.topViewController as! AddBigDayViewController
        
          controller.delegate = self
      } else if segue.identifier == "EditBigDay" {
          let navigationController = segue.destination as! UINavigationController
          let controller = navigationController.topViewController as! AddBigDayViewController
          controller.delegate = self
          if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
              controller.itemToEdit = bigdays[indexPath.row]
          }
      }
    }

    func sortByDaysLeft() {
      let dateNowNow = Date()
      var bigDayDaysLeft = [BigDay]()
      var bigDayDaysUntil = [BigDay]()

      // Check dyas left(+, >= 0) or days until(-, < 0)
      for bigDay in bigdays {
          if bigDay.diffDays(dateNow: dateNowNow) >= 0 {
              bigDayDaysLeft.append(bigDay)
          } else {
              bigDayDaysUntil.append(bigDay)
          }
      }

      // Sort by diff days
      let sortedBigDaysLeftByDiffDays = bigDayDaysLeft.sorted { $0.diffDays(dateNow: dateNowNow) < $1.diffDays(dateNow: dateNowNow) }
      let sortedBigDaysUntilByDiffDays = bigDayDaysUntil.sorted { $0.diffDays(dateNow: dateNowNow) > $1.diffDays(dateNow: dateNowNow) }


      bigdays = sortedBigDaysLeftByDiffDays + sortedBigDaysUntilByDiffDays

      self.tableView.reloadData()
    }
    
    // MARK: - Save item to iCloud
    
    func saveBigDayItemsToCloud() {
        print("Saving big days to iCloud")

        var daysBeforeDecode = [BigDayForSync]()

        fetchBigDays()
        
        for day in bigdays {
            let dayBeforeDecode = BigDayForSync()
            dayBeforeDecode.title = day.title!
            dayBeforeDecode.dueDate = day.big_date! as NSDate
            dayBeforeDecode.day_description = day.day_description!
            dayBeforeDecode.repeatKind = day.repeat_type!
            daysBeforeDecode.append(dayBeforeDecode)
        }

        let data = NSMutableData()

        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(daysBeforeDecode, forKey: "BigDayData")
        archiver.finishEncoding()
        
        // Save to iCloud
        let store = NSUbiquitousKeyValueStore.default
        store.set(data, forKey: "BigDayData")
        store.synchronize()
        
   }
    
    private func getSycnNotification() {
        let store = NSUbiquitousKeyValueStore.default
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyValuePairs), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: store)
        store.synchronize()
    }
    
    @objc func updateKeyValuePairs(notification: NSNotification) {
        print("updateKeyValuePairs")
        let userInfo = notification.userInfo
        let changeReason =  userInfo?["NSUbiquitousKeyValueStoreChangeReasonKey"]
        var reason = -1
        
        if (changeReason == nil) {
            return
        } else {
            reason = changeReason as! Int
        }
        
        if (reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange) {
            let changeKeys =  userInfo?["NSUbiquitousKeyValueStoreChangedKeysKey"] as! NSArray
            let store = NSUbiquitousKeyValueStore.default
            
            for key in changeKeys {
                if (key as AnyObject).isEqual("BigDayData") {
                    let data = store.object(forKey: "BigDayData") as! NSData
                    
                    var dataAfterDecode = [BigDayForSync]()

                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                    dataAfterDecode = unarchiver.decodeObject(forKey: "BigDayData") as! [BigDayForSync]
                    unarchiver.finishDecoding()
                    
                    
                    if dataAfterDecode.count > 0 {
                        for aDay in bigdays {
                            let dayToRemove = aDay
                            managedContext.delete(dayToRemove)
                        }
                        
                        do {
                            try managedContext.save()
                        } catch let error as NSError {
                            print("Saving error: \(error), description: \(error.userInfo)")
                        }
                        
                        for day in bigdays {
                            if day.day_description == "On" {
                                UNUserNotificationCenter.current().removeNotification(dueDate: day.big_date!)
                            }
                        }
                        
                        bigdays.removeAll()
                        
                        
                        for day in dataAfterDecode {
                            let bigday = BigDay(entity: BigDay.entity(), insertInto: managedContext)
                            bigday.title = day.title
                            bigday.big_date = day.dueDate as Date
                            bigday.repeat_type = day.repeatKind
                            bigday.day_description = day.day_description
                            bigdays.append(bigday)
                            
                            if bigday.day_description == "On" {
                                UNUserNotificationCenter.current().addNotification(title: bigday.title!, dueDate: bigday.big_date!, repeatKind: bigday.repeat_type!)
                            }
                        }
                        do {
                            try managedContext.save()
                            tableView.reloadData()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    } else {
                        for day in bigdays {
                            if day.day_description == "On" {
                                UNUserNotificationCenter.current().removeNotification(dueDate: day.big_date!)
                            }
                        }
                    }
                }
            }
        }
    }
}


