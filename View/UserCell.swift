//
//  UserCell.swift
//  Mock
//
//  Created by mroot on 21/04/2022.
//

import SwiftUI

struct UserCell: View {
    
   // var id: String
    var name: String
    var status: Bool

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
}
