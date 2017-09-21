//
//  Person+CoreDataProperties.swift
//  KueryTests
//
//  Created by Kishikawa Katsumi on 2017/09/22.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int32
    @NSManaged public var birthday: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var nickname: String?
    @NSManaged public var weight: Float
    @NSManaged public var dogs: NSSet?

}

// MARK: Generated accessors for dogs
extension Person {

    @objc(addDogsObject:)
    @NSManaged public func addToDogs(_ value: Dog)

    @objc(removeDogsObject:)
    @NSManaged public func removeFromDogs(_ value: Dog)

    @objc(addDogs:)
    @NSManaged public func addToDogs(_ values: NSSet)

    @objc(removeDogs:)
    @NSManaged public func removeFromDogs(_ values: NSSet)

}
