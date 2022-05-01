//
//  EditUser.swift
//  Mock
//
//  Created by mroot on 21/04/2022.
//

import SwiftUI

struct EditUser: View {
    
    @Environment(\.managedObjectContext) var coreData
    @Environment(\.dismiss) var dismiss
    
    var coreDataEdit = CoreDataController.shared
    
    @State  var id = ""
    @State  var name = ""
    @State  var status: Bool = true
    
    @State private var statusToggle: Bool = true

    
    var user: FetchedResults<User>.Element
    
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

        }
        .onAppear{
            print("\(String(describing: user))")
            id = user.id
            name = user.name
            status = user.status
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //MARK:  -TO DO add -> (Dismiss to Content View)
                    Task {
                        try await coreDataEdit.editUserCoreData(context: coreData, user: user, id: id, name: name, status: status)
                    }
                    dismiss()
                } label: {
                    Label("Update", systemImage: "person.crop.circle.badge.checkmark")
                }
            }
        }
    }
    
}
