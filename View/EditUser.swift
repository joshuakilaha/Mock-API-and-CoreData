//
//  EditUser.swift
//  Mock
//
//  Created by mroot on 21/04/2022.
//

import SwiftUI

struct EditUser: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var api = ApiCall()
    
    @State private var id = ""
    @State private var name = ""
    @State private var status: Bool = true
   // @State var user: Mock
    
    var user: FetchedResults<User>.Element
    
    @State private var statusToggle: Bool = true
    
//    @State var name = ""
//    @State var status = ""
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("Edit User")) {
                    TextField("Name", text: $name)
                    
                    Toggle(isOn: $status) {
                        Text("Status")
                    }
                }
            }

        } .onAppear{
            id = user.id!
            name = user.name!
            status = user.status
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //MARK:  -TO DO add -> (Dismiss to Content View)
                   // api.Mock_UPDATE_User(user: user, id: user.id!)
                    dismiss()
                } label: {
                    Label("Update", systemImage: "person.crop.circle.badge.checkmark")
                }
            }
        }
    }
    
}

//struct EditUser_Previews: PreviewProvider {
//    static var previews: some View {
//        //EditUser(user: Mock(id: "1", name: "john", status: true ))
//        EditUser(user: us)
//    }
//}
