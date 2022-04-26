//
//  NetworkCheck.swift
//  Mock
//
//  Created by mroot on 26/04/2022.
//

import Foundation
import Network

class NetworkCheck: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkCheck")
    @Published var isConnected = true
    
    
    var connectionDescription: String {
        if isConnected {
            return "Connected"
        } else {
            return "Not Connected"
        }
    }
    
    var imageName: String {
        return "wifi.slash"
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
