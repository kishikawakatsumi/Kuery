//
//  OptionalTestObject+CoreDataProperties.swift
//  KueryTests
//
//  Created by Kishikawa Katsumi on 2017/09/22.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//
//

import Foundation
import CoreData


extension OptionalTestObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OptionalTestObject> {
        return NSFetchRequest<OptionalTestObject>(entityName: "OptionalTestObject")
    }

    @NSManaged public var decimalCol: NSDecimalNumber?
    @NSManaged public var stringCol: String?
    @NSManaged public var nsstringCol: NSString?
    @NSManaged public var dataCol: Data?
    @NSManaged public var nsdataCol: NSData?
    @NSManaged public var dateCol: Date?
    @NSManaged public var nsdateCol: NSDate?
    @NSManaged public var uuidCol: UUID?
    @NSManaged public var nsuuidCol: NSUUID?
    @NSManaged public var uriCol: URL?
    @NSManaged public var nsuriCol: NSURL?

}
