//
//  TestObject+CoreDataProperties.swift
//  KueryTests
//
//  Created by Kishikawa Katsumi on 2017/09/22.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//
//

import Foundation
import CoreData


extension TestObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestObject> {
        return NSFetchRequest<TestObject>(entityName: "TestObject")
    }

    @NSManaged public var boolCol: Bool
    @NSManaged public var int16Col: Int16
    @NSManaged public var int32Col: Int32
    @NSManaged public var int64Col: Int64
    @NSManaged public var intCol: Int
    @NSManaged public var floatCol: Float
    @NSManaged public var doubleCol: Double
    @NSManaged public var decimalCol: NSDecimalNumber
    @NSManaged public var stringCol: String
    @NSManaged public var nsstringCol: NSString
    @NSManaged public var dataCol: Data
    @NSManaged public var nsdataCol: NSData
    @NSManaged public var dateCol: Date
    @NSManaged public var nsdateCol: NSDate
    @NSManaged public var uuidCol: UUID
    @NSManaged public var nsuuidCol: NSUUID
    @NSManaged public var uriCol: URL
    @NSManaged public var nsuriCol: NSURL

}
