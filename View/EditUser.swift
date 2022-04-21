//
//  EditUser.swift
//  Mock
//
//  Created by mroot on 21/04/2022.
//

import SwiftUI

struct EditUser: View {
    
    @StateObject var api = ApiCall()
    @State var user: Mock
    
   // @State var data = [Mock]()
    
    @State var name = ""
    @State var status = ""
    
    var body: some View {
        
        TextField("Name", text: $user.name)
      //  TextField("Status", text: $user.status)
        
        Button {
            //MARK:  -TO DO add -> (Dismiss to Content View)
            
            api.Mock_UPDATE_User(user: user, id: user.id)
        } label: {
            Label("Update", systemImage: "person.crop.circle.badge.checkmark")
        }

    }
    
}

struct EditUser_Previews: PreviewProvider {
    static var previews: some View {
        EditUser(user: Mock(id: "1", name: "john", status: true ))
    }
}
