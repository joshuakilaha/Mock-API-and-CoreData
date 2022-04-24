//
//  AddUser.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct AddUser: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var api = ApiCall()
    @State var user: User
    
    var body: some View {
        VStack{
            HStack {
                Button {
                   dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                
                Button {
                    //MARK:  -TO DO add -> (Dismiss to Content View)
                    api.Mock_Post_User(user: user)
                    
                    dismiss()
                } label: {
                    Text("Add")
                }
            }
            .padding()
            
            Form {
                Section {
                   TextField("Name", text: $user.name)
                    Toggle(isOn: $user.status) {
                        Text("Status")
                    }
                    
                }
            }
        }
    }
}
