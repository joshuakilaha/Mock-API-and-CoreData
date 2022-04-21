//
//  AddUser.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import SwiftUI

struct AddUser: View {
    
    @StateObject var api = ApiCall()
     @State var mocku: Mock
    
    var body: some View {
        
      //  TextField("Id", text: $mocku.userid)
        TextField("Name", text: $mocku.name)
        TextField("Status", text: $mocku.status)
        
        Button {
            //api.Mock_Post_User(mocku: mocku)
            api.Mock_Post_User(mocku: mocku)
           // api.upload()
        } label: {
            Text("Add")
        }

    }
}


//struct AddUser_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUser(mocku: Mock(userid: "1", name: "yusuf", status: "ok"))
//    }
//}
