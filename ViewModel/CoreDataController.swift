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
    
    enum State {
        case notAvailable
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published var status:State = .notAvailable

    static let shared = CoreDataController()
    
    
    let persistentContainerQueue = OperationQueue()
    
    @Published var mock = [Mock]()
    @Published var usr = [User]()
    @StateObject var api = ApiCall()
    
    var userService = UserService()
    
    //@StateObject private var userViewModel = UserViewModel(userService: UserService())
    
    //let container = NSPersistentContainer(name: "UserDataModel")
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
            
           // self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
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
          //  removeAllData()

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
    
    
//    do {
//        let request = NSBatchUpdateRequest(entity: Item.entity())
//        request.resultType = .updatedObjectIDsResultType
//        request.propertiesToUpdate = ["timestamp": Date()]
//
//        let result = try viewContext.execute(request) as? NSBatchUpdateResult
//        let objectIDArray = result?.result as? [NSManagedObjectID]
//        let changes = [NSUpdatedObjectsKey: objectIDArray]
//        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [viewContext])
//    } catch {
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    }
    
    func importUser() async throws {
        
        status = .loading
        
        do {
            let userData =  try await userService.fetchUsers()
            
           status = .success
            
            //MARK: To Do Add Remove func
            //removeAllData()
            
            for datum in userData {
                try backgroundContext.performAndWait {
                    //self.removeAllData()
                    self.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    let user = User(context: self.viewContext)
                    
                    user.id = datum.id
                    user.name = datum.name
                    user.status = datum.status
                    try self.save()
                    //self.saveu(backgroundContext: context)
                    //self.saveUser(context: context)
                   // self.updateDB()
                    //self.saveUser(context: context)
                   // print(userData)
                    
                }
            }
            
        } catch {
            status = .failed(error: error)
            debugPrint(error)
        }
    }
    
    func updateDB() {
        do {
            let request = NSBatchUpdateRequest(entity: User.entity())
            request.resultType = .updatedObjectIDsResultType
            request.propertiesToUpdate = ["id": String.self]

            let result = try viewContext.execute(request) as? NSBatchUpdateResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes = [NSUpdatedObjectsKey: objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [viewContext])
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
    
//    func doubleData() {
//        let request: NSFetchRequest<User> = User.fetchRequest()
//        request.predicate = NSPredicate(format: "id = %@", id)
//                
//                do {
//                    let fetchResult = try  viewContext.fetch(request)
//                    if fetchResult.count > 0 {
//                        for doubledData in fetchResult {
//                            viewContext.delete(doubledData)
//                        }
//                    }
//                } catch {
//                    print(error)
//                }
//    }
     
    func addUser(context: NSManagedObjectContext, name:String, status: Bool) {
        
        let user = User(context: context)
        
        //user.id = id
        user.name = name
        user.status = status
        
        print(user)
        ApiCall().Mock_Post_User(user: user)
        saveUser(context: context)
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
//        user.name = userData.name
//        user.status = userData.status
        
        //user.id = responseUserPost.id
        
        //print(user)
    }
    
    
    func editUser(context: NSManagedObjectContext, user: User, name: String, status: Bool, id: String) {
        
        user.id = id
        user.name = name
        user.status = status
        
        ApiCall().Mock_UPDATE_User(user: user, id: id )
        saveUser(context: context)
        
    }
    
    
    func saveUser(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved Successfully")
        } catch {
            print("Unable to save User")
        }
    }
    
    func saveu(backgroundContext: NSManagedObjectContext) {
        persistentContainerQueue.maxConcurrentOperationCount = 1

        //add the save operation to the back of the queue
                persistentContainerQueue.addOperation(){
                
                    self.backgroundContext.performAndWait{
                        
                        do {
                            //update core data
                            try self.backgroundContext.save()
                            //try context.save()
                            
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                }
    }
    

}
