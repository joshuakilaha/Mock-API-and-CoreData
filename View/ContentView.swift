//
//  ContentView.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var dataContext
    
    //var userD: User
    
    //Fetch from CoreData
//    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)]) var result: FetchedResults<User>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) var results: FetchedResults<User>

    @StateObject var api = ApiCall()

    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            List{
                ForEach(results, id: \.id) { user in
                  //  NavigationLink(destination: EditUser(user: user)) {
                       // UserCell(user: user) //user cell
                        UserCell(id: user.id!, name: user.name!, status: user.status)
                 //   }
                }
                .onDelete(perform: deleteUser) //Delete item on list
            }
            .refreshable {
                api.Mock_Get_ALL(context: dataContext)
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
            api.Mock_Get_ALL(context: dataContext)
        }
        .sheet(isPresented: $showAdd) {
            AddUser(user: Mock(id: "", name: "", status: false))
        }
    }
    
    //MARK: Delete
    func deleteUser(indexSet: IndexSet){
        withAnimation {
            let id = indexSet.map{ api.mock[$0].id }
            
            DispatchQueue.main.async {
                api.Mock_DELETE_User(id: id)
                self.api.Mock_Get_ALL(context: dataContext)
            }
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
