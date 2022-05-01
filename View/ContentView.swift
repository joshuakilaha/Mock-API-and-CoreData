//
//  ContentView.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var dataContext
    @ObservedObject private var networkManager = NetworkManager()
    
    //WARNING Issue solved here: https://twitter.com/andresr_develop/status/1509287460961927186?s=21
    @StateObject var coreData = CoreDataController.shared //observe state from CoreData
    
    @State private var showAdd = false //View Presentation to AddView
    
    //MARK: Fetch from CoreData
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) private var results: FetchedResults<User>
    
        var body: some View {
            
            NavigationView {
                switch coreData.status {
                case .success:
                    VStack {
                        List {
                            ForEach(results, id: \.self) { data in
                                NavigationLink(destination: EditUser(user: data)) {
                                    UserCell(name: data.name, status: data.status) //Single Cell view from UserCell View
                                }
                            } .onDelete(perform: deleteUser)
                        }
                        
                        .refreshable {
                                Task {
                                    try await coreData.importUser()
                                }
                            }
                        .onAppear {
                                UIRefreshControl.appearance().tintColor = .green
                                UIRefreshControl.appearance().attributedTitle = NSAttributedString("Refreshing…")
                        }
                        
                        //Check network Connection
                        if networkManager.isConnected {
                            NetworkRetryView(netStatus: networkManager.connectionDescription, image: networkManager.imageName)
                        }
                    } .navigationTitle("Users")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    //MARK: To Add User View
                                    showAdd.toggle()
                                } label: {
                                    Label("add", systemImage: "plus.circle")
                                }
                            }
                            
                            //MARK: -Edit button for Delete
                            ToolbarItem(placement: .navigationBarLeading) {
                                EditButton()
                            }
                        }
                case .loading:
                    ProgressView() //Loading view when Screen appears
                default:
                    EmptyView()
                }
                    
            }
            .navigationViewStyle(.stack)
            .task {
               await importData()
            }
            .sheet(isPresented: $showAdd) {
                AddUser()
            }
    }
        
        //MARK: -Delete
        func deleteUser(indexSet: IndexSet){
            withAnimation {
               indexSet.map{results[$0]} .forEach(dataContext.delete)

                let id = indexSet.map{results[$0].id}
                print("index is: \(String(describing: id))")
                UserService().Mock_DELETE_User(id: id)
        }
            CoreDataController().saveUser(context: dataContext)
    }
    
    //MARK: -Import User Data
    private func importData() async {
        do {
            try await coreData.importUser()
        } catch {
            print(error.localizedDescription)
        }
    }
}
        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
