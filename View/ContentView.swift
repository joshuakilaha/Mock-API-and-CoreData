//
//  ContentView.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct ContentView: View {
    
   // @StateObject private var userViewModel = UserViewModel(userService: UserService())

    @ObservedObject var coreData = CoreDataController.shared
    // @ObservedObject var coreData: CoreDataController = CoreDataController.shared
    
    @Environment(\.managedObjectContext) var dataContext
    
    
        //Fetch from CoreData
//    @FetchRequest(entity: User.entity(), sortDescriptors: [SortDescriptor(\.id, order: .reverse)]) var results: FetchedResults<User>
 
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) private var results: FetchedResults<User>
    
    
        var body: some View {
            
            NavigationView {
                switch coreData.status {
                case .success:
                    List(results, id: \.self) { data in
                        UserCell(name: data.name, status: data.status)

                        } .refreshable {
                            Task {
                                //coreData.removeAllData()
                                //coreData.doubleData()
                                
                                try await coreData.importUser()                                //coreData.updateDB()
                            }
                        }
                        .onAppear {
                            UIRefreshControl.appearance().tintColor = .green
                            UIRefreshControl.appearance().attributedTitle = NSAttributedString("Refreshing…")
                        }
                case .loading:
                    ProgressView()
                default:
                    EmptyView()
                }
                    
            } 
            .task {
                await importData()
            }
            
//            NavigationView {
//                switch userViewModel.state {
//                case .success(let data):
//                    VStack {
//                        List {
//                            ForEach(data, id: \.id) { users in
//                                UserCell(id: users.id, name: users.name, status: users.status)
//                            }
//                        } .refreshable {
//                            Task {
//                                await userViewModel.getUsersData()
//                            }
//                        }
//                    } .navigationTitle("Users")
//
//                case .loading:
//                    ProgressView()
//                default:
//                    EmptyView()
//                }
//            }
//            .task {
//                await userViewModel.getUsersData()
//            }
        
    }
        private func importData() async {
            do {
                try await coreData.importUser()
            } catch {
                print("at import viewContent\(error.localizedDescription)")
            }
        }
    
}
        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


























//struct ContentView: View {
//
//    @Environment(\.managedObjectContext) var dataContext
//
//
//    //Fetch from CoreData
//    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: false)]) var results: FetchedResults<User>
//
//
//    @StateObject var api = ApiCall()
//    @StateObject var networkCheck = NetworkCheck()
//    @StateObject var coreData = CoreDataController()
//
//    @State private var showAdd = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Group {
//                    if networkCheck.isConnected {
//                        List {
//                            ForEach(results) { user in
//                                NavigationLink(destination: EditUser(user: user)) {
//                                    UserCell(id: user.id, name: user.name, status: user.status)
//                               }
//                            }
//                            .onDelete(perform: deleteUser) //Delete item on list
//                        }.refreshable{
//                            coreData.removeAllData()
//                            api.Mock_Get_ALL()
//                        }
//                    } else {
//                        VStack {
//                            List {
//                                ForEach(results) { user in
//                                    NavigationLink(destination: EditUser(user: user)) {
//                                        UserCell(id: user.id, name: user.name, status: user.status)
//                                    }
//                                }
//                            }
//                            HStack {
//
//                                Text(networkCheck.connectionDescription)
//                                Image(systemName: networkCheck.imageName)
//
//                                Spacer()
//
//                                Button {
//                                    print("checking for connection")
//                                } label: {
//                                    Text("Retry")
//                                        .padding()
//                                        .font(.headline)
//                                        .foregroundColor(Color(.systemBlue))
//                                }
//                                .frame(width: 100)
//                                .background(Color.white)
//                                .clipShape(Capsule())
//                                .padding()
//                            } .background(Color.red)
//                                .padding()
//                        }
//                    }
//                }
//            }
//
//            .navigationTitle("Users")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        //api.upload()
//                        showAdd.toggle()
//                    } label: {
//                        Label("add", systemImage: "plus.circle")
//                    }
//                }
//            }
//        }
//        .onAppear {
//            coreData.removeAllData()
//            api.Mock_Get_ALL()
//        }
//        .navigationViewStyle(.stack)
//
//
//        .sheet(isPresented: $showAdd) {
//            AddUser()
//        }
//    }
//
//
//    //MARK: Delete
//    func deleteUser(indexSet: IndexSet){
//        withAnimation {
//           indexSet.map{results[$0]} .forEach(dataContext.delete)
//
//            let id = indexSet.map{results[$0].id}
//            print("index is: \(String(describing: id))")
//
//            api.Mock_DELETE_User(id: id)
//
//        CoreDataController().saveUser(context: dataContext)
//    }
//}
//
//
//    private func importData() async {
//        do {
//        try await CoreDataController().importUserCore()
//        } catch {
//
//            print("Unable to Import Data to Core Data\(error.localizedDescription)")
//        }
//    }
//
//}
