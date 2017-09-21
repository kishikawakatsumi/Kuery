//
//  Dog+CoreDataProperties.swift
//  KueryTests
//
//  Created by Kishikawa Katsumi on 2017/09/22.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var age: Int32
    @NSManaged public var name: String?
    @NSManaged public var vaccinated: Bool
    @NSManaged public var owner: Person?

}
