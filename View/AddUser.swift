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
            api.Mock_Post_User(mocku: user)
        } label: {
            Text("Add")
        }

    }
}
