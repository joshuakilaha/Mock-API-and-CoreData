//
//  UserService.swift
//  Mock
//
//  Created by mroot on 28/04/2022.
//

import Foundation

class UserService {
    
    //@Published user = [User]()
    var mock = [Mock]()
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
        case failedToEncode
    }
    
    func fetchUsers() async throws -> [Mock] {
        
        //check URL
        guard let url = URL(string: APIConstants.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        //get the URLSession
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //check the if the response is valid
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        //get the data
       let encodedData = try JSONDecoder().decode([Mock].self, from: data)
            return encodedData
    }
    

        func upload(user: User) async throws -> Data {
            
            guard let url = URL(string: APIConstants.baseURL) else {
                throw NetworkError.invalidURL
            }
            
            guard let userEncoded = try? JSONEncoder().encode(user) else {
                print("Failed to encode")
                throw NetworkError.failedToEncode
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = userEncoded // Set HTTP Request Body
            

            let (data, response) = try await URLSession.shared.upload(for: request, from: userEncoded)
            
            //check the if the response is valid
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200 else {
//                throw NetworkError.invalidResponse
//            }
            

            
            //print(response)
            //print(data, String(data: data, encoding: .utf8)!)
            //print(String(describing: response))
            return data
                        
        }
    
    
    func updateUser(user: User, id: String) async throws -> Data {
            
            //get URL
            guard let url = URL(string: APIConstants.baseURL.appending("/\(id)")) else {
                throw NetworkError.invalidURL
            }
            
            //get encoded data
           guard let encodedData = try? JSONEncoder().encode(user) else {
                throw NetworkError.failedToEncode
            }
            
            //HTTP Request
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = encodedData
            
            //URL Session
            let (data, _) = try await URLSession.shared.upload(for: request, from: encodedData)
            
            return data
            
        }

}
