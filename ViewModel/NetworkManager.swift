//
//  NetworkManager.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import Foundation
import CoreData

class ApiCall: ObservableObject {
    
     var userCoreData = CoreDataController()
    
    @Published var mock = [Mock]()
    @Published var userD = [User]()
    
    enum NetworkError: Error {
        case badUrl
        case invalidRequest
    }
    
    
    //MARK: GET Request
    func Mock_Get_ALL() {
        
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
            print("Invalid URL!!")
            return
        }
        
        
        
//        let data = //raw json data in Data object
//        let context = persistentContainer.newBackgroundContext()
//        let decoder = JSONDecoder()
//        decoder.userInfo[.context] = context
//
//        _ = try decoder.decode(MyManagedObject.self, from: data) //we'll get the value from another context using a fetch request later...
//
//        try context.save() //make sure to save your data once decoding is complete
        
        
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data1 = data, error == nil else {
                return
            }
            
            do {
               
                let context = self.userCoreData.backgroundContext
                let decoder = JSONDecoder()
                decoder.userInfo[.context] = context
                
                _ = try decoder.decode([User].self, from: data1)
                try context.save()
                
              //  let mockDecoded = try JSONDecoder().decode([User].self, from: data1)
                

//                DispatchQueue.main.async {
//                    self.userD = mockDecoded
//                    //  self.userCoreData.saveUserCoreData(context: context)
//
//
//                }
//
            } catch {
                //print("Something went wrong")
                // print(error.localizedDescription)
                debugPrint(error)
            }
        }
        task.resume()
    }
//    func Mock_Get_ALL(context: NSManagedObjectContext) async{
//
//        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
//            print("Invalid URL!!")
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data1 = data, error == nil else {
//                return
//            }
//
//            do {
//                let mockDecoded = try JSONDecoder().decode([Mock].self, from: data1)
//
//
//                DispatchQueue.main.async {
//                    self.mock = mockDecoded
//                    //  self.userCoreData.saveUserCoreData(context: context)
//                    self.userCoreData.addUser(context: context)
//
//                }
//
//            } catch {
//                //print("Something went wrong")
//                // print(error.localizedDescription)
//                debugPrint(error)
//            }
//        }
//        task.resume()
//    }
    
    func Mock_Get_ALL1() async throws -> [Mock] {

        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
            print("Invalid URL!!")
            throw NetworkError.badUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let mockDecoded = try? JSONDecoder().decode([Mock].self, from: data)
        return mockDecoded ?? []
        
    }
        

//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            DispatchQueue.main.async {
//                let mockDecoded = try? JSONDecoder().decode([Mock].self, from: data)
//                self.mock = return mockDecoded
//               // return mockDecoded
//            }

//
//            guard let url = url else {
//                throw NetworkError.badUrl
//            }
//
//            let (data, response) = try await URLSession.shared.data(from: url)
//
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//                throw NetworkError.invalidRequest
//            }
//
//            let vegetables = try? JSONDecoder().decode([VegetableDTO].self, from: data)
//            return vegetables ?? []
//        }
//
    
    
//    func postUser() async throws -> [Mock] -> {
//        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
//            throw NetworkError.badUrl
//            print("Invalid URL!!")
//
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody =  // Set HTTP Request Body
//
//
//        let (data, _) try await URLSession.shared.dataTask(with: request)
//    }

    
    //MARK: POST Request
    
    func Mock_Post_User(user: User) {
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
            print("Invalid URL!!")
            return
        }
        
        guard let mockEncoded = try? JSONEncoder().encode(user) else {
            print("Failed to Encode")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = mockEncoded // Set HTTP Request Body
        
        // Perform HTTP Request
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            print(response as Any)
            if let error = error {
                print(error)
                return
            }
            guard let data = data else{
                return
            }
            print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            
        }.resume()
        
    }
    
    //MARK: UPDATE Request
    
    func Mock_UPDATE_User(user: User, id: String) {
        print("ID is: \(String(describing: id))")
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details/\(id)") else {
            print("Invalid URL!!")
            return
        }
        
        guard let mockEncoded = try? JSONEncoder().encode(user) else {
            print("Failed to Encode")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = mockEncoded // Set HTTP Request Body
        
    
        
        // Perform HTTP Request
            URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            print(response as Any)
                
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            
            }
        .resume()
    }
    
    
    //MARK: DELETE Request
    
    func Mock_DELETE_User(id: [String]) {

        print(id)
        let joinId = id.joined(separator: "")
        print(joinId)
        
        //let user = 5
        //let id = 3
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details/\(joinId)") else {
            print("Inavlid URL!!")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            print(response as Any)
            if let error = error {
                print(error.localizedDescription)
                debugPrint(error)
                return
            }
//            guard let data = data else {
//                return
//            }
            print("Successfully Deleted!!")
        }.resume()


    }
}
