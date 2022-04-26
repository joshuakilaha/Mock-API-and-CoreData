//
//  MainScreen.swift
//  Mock
//
//  Created by mroot on 26/04/2022.
//

import SwiftUI

struct MainScreen: View {
    
    @Environment(\.managedObjectContext) var dataContext
    
    //Fetch from CoreData
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)]) var results: FetchedResults<User>
    
    @StateObject var api = ApiCall() //Call functions from API
    @ObservedObject var networkCheck = NetworkCheck() //Check Internet Connection
    
    
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            
            Group {
                ZStack {
                    if networkCheck.isConnected {
                        List {
                            ForEach(results) { user in
                                NavigationLink(destination: EditUser(user: user)) {
                                    UserCell1(id: user.id, name: user.name, status: user.status)
                                }
                            } .onDelete(perform: deleteUser)
                        
                        } .refreshable {
                            CoreDataController().removeAllData()
                            api.Mock_Get_ALL()
                        }
                        .onAppear {
                            CoreDataController().removeAllData()
                            api.Mock_Get_ALL()
                        }
                } else {
                    VStack {
                        List {
                            ForEach(results) { useroffline in
                                NavigationLink(destination: EditUser(user: useroffline)) {
                                    UserCell1(id: useroffline.id, name: useroffline.name, status: useroffline.status)
                                }
                            }
                        }
                        HStack {
                            Text(networkCheck.connectionDescription)
                            Button {
                                print("check Internet settings")
                            } label: {
                                Text("Retry")
                            }

                        }
                        
                    
                    }
                }
            }
        }
            .navigationTitle("Users")
        }
        .navigationViewStyle(.stack)
        

        .sheet(isPresented: $showAdd) {
          //  AddUser(user: Mock(id: "", name: "", status: false))
           // AddUser(user: User(from: id: "", name: "", status: false))
        }
    }
    
    func deleteUser(indexSet: IndexSet) {
        withAnimation {
           indexSet.map{results[$0]} .forEach(dataContext.delete)
            
            let id = indexSet.map{results[$0].id}
            print("index is: \(String(describing: id))")
            api.Mock_DELETE_User(id: id)
        }        
        CoreDataController().saveUserCoreData(context: dataContext)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
