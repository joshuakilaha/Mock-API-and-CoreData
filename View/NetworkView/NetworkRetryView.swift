//
//  NetworkRetryView.swift
//  Mock
//
//  Created by mroot on 01/05/2022.
//

import SwiftUI

struct NetworkRetryView: View {
    
    @StateObject private var coredata = CoreDataController()
    
    let netStatus: String
        let image: String
        
        var body: some View {
            HStack {
                Text(netStatus)
                    .padding()
                Image(systemName: image)
                
                Spacer()
                
                Button {
                    Task {
                        try await coredata.importUser()
                    }
                } label: {
                    Text("Retry")
                        .padding()
                        .font(.headline)
                        .foregroundColor(Color(.systemBlue))
                }
                .frame(width: 80, height: 25)
                .background(Color.white)
                .clipShape(Capsule())
                .padding()

            }
            .background(Color.blue)
        }
}

struct NetworkRetryView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkRetryView(netStatus: "Not Connected", image: "")
    }
}
