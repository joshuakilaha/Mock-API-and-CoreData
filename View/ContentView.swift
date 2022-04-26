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
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)]) var results: FetchedResults<User>
    
   // @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) var results: FetchedResults<User>

    @ObservedObject var api = ApiCall()
    @ObservedObject var networkCheck = NetworkCheck()

    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if networkCheck.isConnected {
                        List {
                            ForEach(results) { user in
                                NavigationLink(destination: EditUser(user: user)) {
                               //     UserCell(user: user) //user cell
                                    UserCell1(id: user.id, name: user.name, status: user.status)
                               }
                            }
                            .onDelete(perform: deleteUser) //Delete item on list
                        }
                        .refreshable {
            //               // api.Mock_Get_ALL(context: dataContext)
            //                Task { [self] in
            //                    await self.importData()
            //                }
                            CoreDataController().removeAllData()
                            api.Mock_Get_ALL()
                        }
            //            ForEach(results, id: \.id) { result in
            //                UserCell1(id: result.id ?? "4" , name: result.name ?? "Owen", status: result.status)
            //                let _ = print("\(String(describing: result.name!))")
            //            }
                    } else {
                        VStack {
                            List {
                                ForEach(results) { user in
                                    NavigationLink(destination: EditUser(user: user)) {
                                        UserCell1(id: user.id, name: user.name, status: user.status)
                                    }
                                }
                           // .onDelete(perform: deleteUser) //Delete item on list
                            }
                            HStack {
                                
                                Text(networkCheck.connectionDescription)
                                Image(systemName: networkCheck.imageName)
                                
                                Spacer()
                                
                                Button {
                                    print("checking for connection")
                                } label: {
                                    Text("Retry")
                                        .padding()
                                        .font(.headline)
                                        .foregroundColor(Color(.systemBlue))
                                }
                                .frame(width: 100)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding()
                            } .background(Color.red)
                                .padding()
                            
                                
                            
                        }
                    }
                }
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
        .onAppear  {
            CoreDataController().removeAllData()
            api.Mock_Get_ALL()
        }
        .sheet(isPresented: $showAdd) {
          //  AddUser(user: Mock(id: "", name: "", status: false))
           // AddUser(user: User(from: id: "", name: "", status: false))
        }
    }
    
    //MARK: Delete
    func deleteUser(indexSet: IndexSet){
        withAnimation {
           indexSet.map{results[$0]} .forEach(dataContext.delete)
            
            let id = indexSet.map{results[$0].id}
            print("index is: \(String(describing: id))")
            //let id = indexSet.map{ api.mock[$0].id } .forEach(dataContext.delete)
            api.Mock_DELETE_User(id: id)
            
//            DispatchQueue.main.async {
//                api.Mock_DELETE_User(id: id)
//               // self.api.Mock_Get_ALL(context: dataContext)
//            }
        }
        
        CoreDataController().saveUserCoreData(context: dataContext)
        
    }
    
    private func importData() async {
        do {
        try await CoreDataController().importUserCore()
        } catch {
           
            print("Unable to Import Data to Core Data\(error.localizedDescription)")
        }
    }
    
}
        
//        NavigationView {
//            ZStack {
//                Group {
//                    if networkCheck.isConnected {
//                        List {
//                            ForEach(results) { user in
//                                NavigationLink(destination: EditUser(user: user)) {
//                               //     UserCell(user: user) //user cell
//                                    UserCell1(id: user.id, name: user.name, status: user.status)
//                               }
//                            }
//                            .onDelete(perform: deleteUser) //Delete item on list
//                        }
//                        .refreshable {
//            //               // api.Mock_Get_ALL(context: dataContext)
//            //                Task { [self] in
//            //                    await self.importData()
//            //                }
//                            CoreDataController().removeAllData()
//                            api.Mock_Get_ALL()
//                        }
//            //            ForEach(results, id: \.id) { result in
//            //                UserCell1(id: result.id ?? "4" , name: result.name ?? "Owen", status: result.status)
//            //                let _ = print("\(String(describing: result.name!))")
//            //            }
//
//                        .navigationTitle("Users")
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarTrailing) {
//                                Button {
//                                    //api.upload()
//                                    showAdd.toggle()
//                                } label: {
//                                    Label("add", systemImage: "plus.circle")
//                                }
//                            }
//                        }
//                    } else {
//                        Text(networkCheck.connectionDescription)
//                    }
//                }
//            }
//        } .navigationViewStyle(.stack)
//        .onAppear  {
//          //api.Mock_Get_ALL(context: dataContext)
//            //await importData()
////            Task { [self] in
////                await self.importData()
////            }
//            CoreDataController().removeAllData()
//            api.Mock_Get_ALL()
//
//        }
//        .sheet(isPresented: $showAdd) {
//          //  AddUser(user: Mock(id: "", name: "", status: false))
//           // AddUser(user: User(from: id: "", name: "", status: false))
//        }
//    }
//
//    //MARK: Delete
//    func deleteUser(indexSet: IndexSet){
//        withAnimation {
//           indexSet.map{results[$0]} .forEach(dataContext.delete)
//
//            let id = indexSet.map{results[$0].id}
//            print("index is: \(String(describing: id))")
//            //let id = indexSet.map{ api.mock[$0].id } .forEach(dataContext.delete)
//            api.Mock_DELETE_User(id: id)
//
////            DispatchQueue.main.async {
////                api.Mock_DELETE_User(id: id)
////               // self.api.Mock_Get_ALL(context: dataContext)
////            }
//        }
//
//        CoreDataController().saveUserCoreData(context: dataContext)
//
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
