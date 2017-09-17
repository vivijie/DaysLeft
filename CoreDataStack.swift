//
//  CoreDataStack.swift
//  DaysLeft
//
//  Created by viviJIE on 9/16/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  var store: NSPersistentStore?
  
  private let modelName: String
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  lazy var managedContext:NSManagedObjectContext = {
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.coordinator
    
    return managedObjectContext
  }()
  
  lazy var coordinator: NSPersistentStoreCoordinator = {
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel)
    let documentsURL = self.applicationDocumentsDirectory
    let storeURL = documentsURL.appendingPathComponent(self.modelName)
    
    do {
      
      let options =
        [NSMigratePersistentStoresAutomaticallyOption: true]
      
      var error: NSError? = nil
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                         configurationName: nil,
                                         at: storeURL,
                                                 options: options
      )
    } catch {
      print("Error adding persistent store: \(error)")
    }
    
    return coordinator
  }()
  
  var managedObjectModel: NSManagedObjectModel = {
   
    let bundle = Bundle.main
    let modelURL = bundle.url(forResource: "DaysLeft", withExtension: "momd")!
    
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var applicationDocumentsDirectory: NSURL = {
    let fileManager = FileManager.default
    
    if let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.tdones.DaysLeft") {
      return url as NSURL
    } else {
      let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as Array<NSURL>
      return urls[0]
    }
  }()
  
  
  func saveContext() {
    guard managedContext.hasChanges else {
      return
    }
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
  func mostRecentDay() -> [BigDay] {
    var bigdays: [BigDay] = []
    
    let fetchRequest:NSFetchRequest<BigDay> = BigDay.fetchRequest()
    
    do {
      bigdays = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return sortByDaysLeft(bigdays: bigdays)
  }
  
  private func sortByDaysLeft(bigdays: [BigDay]) -> [BigDay] {
    let dateNowNow = Date()
    var bigDayDaysLeft = [BigDay]()
    var bigDayDaysUntil = [BigDay]()
    var sortBigDays = [BigDay]()
    
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
//    let sortedBigDaysUntilByDiffDays = bigDayDaysUntil.sorted { $0.diffDays(dateNow: dateNowNow) > $1.diffDays(dateNow: dateNowNow) }
//    sortBigDays = sortedBigDaysLeftByDiffDays + sortedBigDaysUntilByDiffDays
    
    sortBigDays = sortedBigDaysLeftByDiffDays
    return sortBigDays
  }
  
}
