//
//  ContentView.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct ContentView: View {

    
    @StateObject var api = ApiCall()

    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            //MARK:  -TO DO  Place Contents on View Cell
            List{
               // NavigationLink()
                ForEach(api.mock, id: \.id) { user in
                    NavigationLink(destination: EditUser(user: user)) {
                        Text(user.name)
                    }
                   
                }
                .onDelete(perform: deleteUser)
             
            }
            .refreshable {
                api.Mock_Get_ALL()
            }
            
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //api.upload()
                        showAdd.toggle()
                    } label: {
                        Label("add", systemImage: "plus.circle")
                    }
                }
            }
        } .navigationViewStyle(.stack)
        .onAppear{
            api.Mock_Get_ALL()
        }
        
        .sheet(isPresented: $showAdd) {
            AddUser(user: Mock(id: "", name: "", status: ""))
        }
    }
    
    //MARK: Delete
    
    //MARK: -Handle Delete index
    func deleteUser(indexSet: IndexSet){
        withAnimation {
            let id = indexSet.map{ api.mock[$0].id }
            
            DispatchQueue.main.async {
                //let item = id
                api.Mock_DELETE_User1(id: id)
                self.api.Mock_Get_ALL()
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
