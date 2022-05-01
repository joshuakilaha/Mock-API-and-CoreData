//
//  User+CoreDataProperties.swift
//  Mock
//
//  Created by mroot on 24/04/2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var status: Bool

}

extension User : Identifiable {

}
