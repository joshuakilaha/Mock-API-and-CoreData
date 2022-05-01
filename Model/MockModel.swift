//
//  MockModel.swift
//  Mock
//
//  Created by mroot on 20/04/2022.
//

import Foundation

//MARK: -Dummy data
//[
//  {
//      "name": "Uploading Test 2 edit test 1",
//      "status": true,
//      "id": "14"
//  },
//  {
//      "name": "Final Test 1 Edit Test 2",
//      "status": true,
//      "id": "15"
//  }
//]

struct Mock: Codable {
    var id: String
    var name: String
    var status: Bool
}
