//
//  UserViewModel.swift
//  Mock
//
//  Created by mroot on 28/04/2022.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    
    @Published var mock = [Mock]()
    
    //view States
    enum State {
        case notAvailable
        case loading
        case success(data: [Mock])
        case failed(error: Error)
    }
    
    @Published var state: State = .notAvailable
    var userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func getUsersData() async {
        
        self.state = .loading
        
        do {
            let usersData = try await userService.fetchUsers()
            self.state = .success(data: usersData)
            //print(usersData)

        } catch {
            self.state = .failed(error: error)
            debugPrint(error)
        }
    }
}
