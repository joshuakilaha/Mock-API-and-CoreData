//
//  UserCell.swift
//  Mock
//
//  Created by mroot on 21/04/2022.
//

import SwiftUI

struct UserCell: View {
    
   // @State var user: Mock
    
//    @State private var name = ""
//    @State private var status: Bool = true
    
    let id: String
    let name: String
    let status: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10 ){
            Text(name)
                .font(.title2)
                .fontWeight(.semibold)
            if status == true {
                Text("Active")
                    .font(.title3)
                    .fontWeight(.light)
                    .italic()
                    .foregroundColor(.green)
            } else {
                Text("Offline")
                    .foregroundColor(.red)
                    .font(.title3)
                    .fontWeight(.light)
                    .italic()
            }
        }
    }
    
//    var body: some View {
//
//        VStack(alignment: .leading, spacing: 10 ){
//            Text(user.name)
//                .font(.title2)
//                .fontWeight(.semibold)
//            if user.status == true {
//                Text("Active")
//                    .font(.title3)
//                    .fontWeight(.light)
//                    .italic()
//                    .foregroundColor(.green)
//            } else {
//                Text("Offline")
//                    .foregroundColor(.red)
//                    .font(.title3)
//                    .fontWeight(.light)
//                    .italic()
//            }
//        }
//    }
    
}


struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(id: "1", name: "John Cena", status: true)
    }
}


//struct UserCell_Previews: PreviewProvider {
//    static var previews: some View {
//        UserCell(user: Mock(id: "4", name: "John Cena", status: false))
//    }
//}
