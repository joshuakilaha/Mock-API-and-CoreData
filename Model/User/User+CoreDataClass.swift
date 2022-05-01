//
//  User+CoreDataClass.swift
//  Mock
//
//  Created by mroot on 24/04/2022.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {

    enum CodingKeys: CodingKey {
        case id
        case name
        case status
    }
    
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            fatalError()
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
            fatalError()
        }
        
        self.init(entity: entity, insertInto: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(Bool.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(status, forKey: .status)
    }
}


extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}
