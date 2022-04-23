//
//  MockApp.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

@main
struct MockApp: App {
//    init(){
//        Task { [self] in
//            await self.importData()
//        }
//    }
//
//    private func importData() async {
//        do {
//            try await CoreDataController.shared.importUserCore()
//        } catch {
//            print(error)
//        }
//    }
//
    @StateObject private var userCoreDataController = CoreDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, userCoreDataController.container.viewContext)
        }
    }
}
