//
//  CoreDataController.swift
//  Mock
//
//  Created by mroot on 22/04/2022.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class CoreDataController: ObservableObject {
    
    enum State {
        case notAvailable
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published var status:State = .notAvailable

    static let shared = CoreDataController()
    
    var userService = UserService()
    
    let container = NSPersistentContainer(name: "UserDataModel")
    
    
    var viewContext: NSManagedObjectContext {
         return container.viewContext
     }
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error!!! Failed to Load Data\(error.localizedDescription)")
                return
            }
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    var backgroundContext: NSManagedObjectContext {
         return container.newBackgroundContext()
     }
 
    
    func save() throws {
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    
    func importUser() async throws {
        
        status = .loading
        do {
            let userData =  try await userService.fetchUsers()
            
           status = .success
            for datum in userData {
                try backgroundContext.performAndWait {
                    //removeAllData()
                    self.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    let user = User(context: self.viewContext)
                    
                    user.id = datum.id
                    user.name = datum.name
                    user.status = datum.status
                    try self.save()
                }
            }
        } catch {
            status = .failed(error: error)
            debugPrint(error)
        }
    }
    
    
    func useradd(context: NSManagedObjectContext, name:String, status: Bool) async  throws{
        
        let user = User(context: context)
        user.name = name
        user.status = status
        
        let responseUserPost = try await userService.upload(user: user)
        //print(responseUserPost, String(data: responseUserPost, encoding: .utf8)!)
        let userData = try JSONDecoder().decode(Mock.self, from: responseUserPost)
        //print(userData)
        user.id = userData.id        
        print(userData.id)
    }
    
    func editUserCoreData(context: NSManagedObjectContext, user: User, id: String, name: String, status: Bool) async throws {
            
            let user = User(context: context)
            
            user.id = id
            user.name = name
            user.status = status
            
            //get post User Service
            let updatedUser = try await userService.updateUser(user: user, id: id)
        print(updatedUser, String(data: updatedUser, encoding: .utf8)!)
            try save()
            
        }
    
    func saveUser(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved Successfully")
        } catch {
            print("Unable to save User")
        }
    }
    
    func removeAllData() {
        
         let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
         
         do {
             try viewContext.execute(deleteRequest)
             try self.save()
         } catch {
             print("remove Error!! here \(error)")
         }
     }

}
