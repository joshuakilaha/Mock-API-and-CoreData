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
