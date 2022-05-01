//
//  MockApp.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

@main
struct MockApp: App {
    
    @ObservedObject var userCoreDataController = CoreDataController.shared
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, userCoreDataController.container.viewContext)
                
        }
    }
}
