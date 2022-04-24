//
//  CoreDataController.swift
//  Mock
//
//  Created by mroot on 22/04/2022.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataController: ObservableObject {

    static let shared = CoreDataController()
    
    @Published var mock = [Mock]()
    @StateObject var api = ApiCall()
    
    //let container = NSPersistentContainer(name: "UserDataModel")
    let container = NSPersistentContainer(name: "UserDataModel")
    
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error!!! Failed to Load Data\(error.localizedDescription)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
         return container.viewContext
     }
    
    var backgroundContext: NSManagedObjectContext {
         return container.newBackgroundContext()
     }
 
        
    
    func saveUserCoreData(context: NSManagedObjectContext) {
        
        mock.forEach { (data) in
            let entity = User(context: context)
            entity.id = data.id
            entity.name = data.name
            entity.status = data.status  
        }
        
        do {
            try context.save()
            print("Saved to CoreData Successfully")
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
        
    
    func save() throws {
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func importUserCore() async throws {
        
            let userApi = try await api.Mock_Get_ALL1()
            
            //MARK: To Do Add Remove func
            removeAllData()
            
            for mock in userApi {
                try await backgroundContext.perform {
                    let user = User(context: self.viewContext)
                    user.id = mock.id
                    user.name = mock.name
                    user.status = mock.status
                    try self.save()
                }
            }
            
        
    }
    
    func removeAllData() {
         let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
         
         do {
             try viewContext.execute(deleteRequest)
         } catch {
             print(error)
         }
     }
     
    
}
