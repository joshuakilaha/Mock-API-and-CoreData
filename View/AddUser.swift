//
//  AddUser.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct AddUser: View {
    
    @StateObject var api = ApiCall()
     @State var user: Mock
    
    var body: some View {
        TextField("Name", text: $user.name)
        TextField("Status", text: $user.status)
        
        Button {
            //MARK:  -TO DO add -> (Dismiss to Content View)
            api.Mock_Post_User(user: user)
        } label: {
            Text("Add")
        }

    }
}
