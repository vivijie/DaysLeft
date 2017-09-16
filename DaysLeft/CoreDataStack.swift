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
  
//  lazy var managedContext: NSManagedObjectContext = {
//    return self.storeContainer.viewContext
//  }()
//
//
//  private lazy var storeContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: self.modelName)
//    container.loadPersistentStores{
//      (storeDescription, error) in
//      if let error = error as NSError? {
//        print("Unresolved error \(error), \(error.userInfo)")
//      }
//    }
//    return container
//  }()
  
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
}
