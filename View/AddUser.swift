//
//  AddUser.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct AddUser: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var coreData = CoreDataController.shared
    
   //@State var user: User
    
    @State var  name = ""
    @State var  status: Bool = true
    
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
                    //api.Mock_Post_User(user: user)
                    
//                    CoreDataController().addUser(context: managedObjContext, name: name, status: status)
//                    //CoreDataController().removeAllData()
//                    ApiCall().Mock_Get_ALL()
                    Task {
                        try await coreData.useradd(context:managedObjContext, name: name, status: status)
                    }
                    dismiss()
                } label: {
                    Text("Add")
                }
            }
            .padding()
            
            Form {
                Section {
                    TextField("Name", text: $name)
                    Toggle(isOn: $status) {
                        Text("Status")
                    }
                    
                }
            }
        }
    }
}
