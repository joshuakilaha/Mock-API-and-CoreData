//
//  UserCell.swift
//  Mock
//
//  Created by mroot on 21/04/2022.
//

import SwiftUI

struct UserCell: View {
    
    @StateObject var api = ApiCall()
    
    @State var showView = false
    
    var body: some View {
        NavigationView {
            List{
                ForEach(api.mock, id: \.id) { user in
                    NavigationLink(destination: EditUser(user: user)) {
                        VStack(alignment: .leading, spacing: 10){
                            Text(user.name)
                                .font(.title2)
                            if user.status == true {
                                Text("Active")
                                    .foregroundColor(.green)
                            } else {
                                Text("Offline")
                                    .foregroundColor(.red)
                            }
                            
                        }
                    }
                } .onDelete(perform: deleteUser)
            }
            .navigationTitle("Users")
        }
        .navigationViewStyle(.stack)
        
        .sheet(isPresented: $showView) {
            AddUser(user: Mock(id: "", name: "", status: true))
        }
        
    }
    //MARK: Detele Item
    private func deleteUser(indexSet: IndexSet) {
        
        let id = indexSet.map {api.mock[$0].id}
        
        DispatchQueue.main.async {
            let item = id
            api.Mock_DELETE_User1(id: item)
        }
    }
    
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell()
    }
}
