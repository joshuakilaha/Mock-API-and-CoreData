//
//  NetworkCheck.swift
//  Mock
//
//  Created by mroot on 26/04/2022.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected = true
    
    
    var connectionDescription: String {
        if isConnected {
            return "Not Connected"
        } else {
            return "Connected"
        }
    }
    
    var imageName: String {
        return "wifi.slash"
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .unsatisfied
            }
        }
        monitor.start(queue: queue)
    }
}
