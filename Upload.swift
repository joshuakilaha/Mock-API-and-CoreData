//
//  Upload.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import Foundation
import SwiftUI

class upload: ObservableObject {
    
    @StateObject var api = ApiCall()
    @State var mock: Mock
    
    func upload(username: String, status: String) {
        
        api.Mock_Post_User(mocku: <#T##Mock#>)
    }
}
