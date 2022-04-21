//
//  NetworkManager.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import Foundation

class ApiCall: ObservableObject {
    
    @Published var mock = [Mock]()
    
    func Mock_Get_ALL(){
        
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
            print("Invalid URL!!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let mockDecoded = try JSONDecoder().decode([Mock].self, from: data)
                
                DispatchQueue.main.async {
                    self.mock = mockDecoded
                }
                
            } catch {
                //print("Something went wrong")
               // print(error.localizedDescription)
                debugPrint(error)
            }
        }
        task.resume()
    }
    
    
    
    func Mock_Post_User(mocku: Mock) {
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
            print("Invalid URL!!")
            return
        }
        
        guard let mockEncoded = try? JSONEncoder().encode(mocku) else {
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
    
    
    
    func Mock_DELETE_User(paramiters: [String: Any]) {
        guard let url = URL(string: "https://625f27a5873d6798e2b38701.mockapi.io/details") else {
            print("Invalid URL!!")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: paramiters)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        request.httpBody = data // Set HTTP Request Body
        
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
    
    func Mock_UPDATE_User(user: Mock, id: String) {
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
    
    func Mock_DELETE_User1(id: [String]) {

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
