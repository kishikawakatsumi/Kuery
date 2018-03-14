//
//  Tests.swift
//  Kuery
//
//  Created by Kishikawa Katsumi on 2017/06/13.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import XCTest
import CoreData
@testable import Kuery

class QueryTests: XCTestCase {
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!

    var uuid = UUID()

    override func setUp() {
        super.setUp()
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: "Model", withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("unable to load Core Data model")
        }
        container = NSPersistentContainer(name: "Model", managedObjectModel: managedObjectModel)
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let _ = error {
                XCTFail("unable to load persistent store")
            }
        }
        context = container.viewContext

        do {
            let person1 = Person(context: context)
            person1.name = "Katsumi"
            person1.age = 36
            person1.weight = 60

            let components = DateComponents(calendar: Calendar(identifier: .gregorian), year: 1980, month: 10, day: 28)
            person1.birthday = components.date!

            let person2 = Person(context: context)
            person2.name = "Taro"
            person2.age = 24

            let person3 = Person(context: context)
            person3.name = "Hanako"
            person3.age = 18

            let dog1 = Dog(context: context)
            dog1.name = "Pochi"
            dog1.vaccinated = true
            dog1.age = 4

            person1.addToDogs(dog1)

            let dog2 = Dog(context: context)
            dog2.name = "Hachi"
            dog2.age = 6

            person2.addToDogs(dog2)

            let obj1 = TestObject(context: context)
            obj1.boolCol = false
            obj1.int16Col = 16
            obj1.int32Col = 32
            obj1.int64Col = 64
            obj1.intCol = 64
            obj1.floatCol = 1.23
            obj1.doubleCol = 12.3
            obj1.decimalCol = NSDecimalNumber(string: "0.123")
            obj1.stringCol = "string"
            obj1.nsstringCol = "nsstring"
            obj1.dataCol = "data".data(using: String.Encoding.utf8)!
            obj1.nsdataCol = "nsdata".data(using: String.Encoding.utf8)! as NSData
            obj1.dateCol = Date(timeIntervalSince1970: 1)
            obj1.nsdateCol = NSDate(timeIntervalSince1970: 2)
//            obj1.uuidCol = uuid
//            obj1.nsuuidCol = uuid as NSUUID
//            obj1.uriCol = URL(string: "https://example.com")!
//            obj1.nsuriCol = NSURL(string: "https://example.com")!

            let optObj1 = OptionalTestObject(context: context)
            optObj1.decimalCol = NSDecimalNumber(string: "0.123")
            optObj1.stringCol = "string"
            optObj1.nsstringCol = "nsstring"
            optObj1.dataCol = "data".data(using: String.Encoding.utf8)!
            optObj1.nsdataCol = "nsdata".data(using: String.Encoding.utf8)! as NSData
            optObj1.dateCol = Date(timeIntervalSince1970: 1)
            optObj1.nsdateCol = NSDate(timeIntervalSince1970: 2)
//            optObj1.uuidCol = uuid
//            optObj1.nsuuidCol = uuid as NSUUID
//            optObj1.uriCol = URL(string: "https://example.com")!
//            optObj1.nsuriCol = NSURL(string: "https://example.com")!

            let _ = OptionalTestObject(context: context)
            let _ = OptionalTestObject(context: context)

            try context.save()
        }  catch {
            XCTFail("Failed to save initial data")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchAll() {
        context.performAndWait {
            do {
                let results = try Query(Person.self).execute()
                XCTAssertEqual(results.count, 3)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Dog.self).execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self).execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self).execute()
                XCTAssertEqual(results.count, 3)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilter() {
        context.performAndWait {
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.boolCol == false)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.boolCol != false)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col == 16)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col != 16)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col > 15)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col >= 16)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col < 17)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col <= 16)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int16Col << (15...17))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int32Col == 32)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int32Col != 32)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int64Col == 64)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.int64Col != 64)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.intCol == 64)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.intCol != 64)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol == 1.23)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol != 1.23)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol < 1.24)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol <= 1.23)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol > 1.22)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol >= 1.23)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.floatCol << (0.0...2.0))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.doubleCol == 12.3)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.doubleCol != 12.3)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.decimalCol == NSDecimalNumber(string: "0.123"))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.decimalCol != NSDecimalNumber(string: "0.123"))
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.decimalCol == 0.123)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.decimalCol != 0.123)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.stringCol == "string")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.stringCol != "string")
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.stringCol ~= "str*")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsstringCol == "nsstring")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsstringCol != "nsstring")
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsstringCol ~= "??string")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dataCol == "data".data(using: String.Encoding.utf8)!)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dataCol != "data".data(using: String.Encoding.utf8)!)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdataCol == "nsdata".data(using: String.Encoding.utf8)! as NSData)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdataCol != "nsdata".data(using: String.Encoding.utf8)! as NSData)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dateCol == Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dateCol != Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dateCol < Date(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dateCol <= Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dateCol > Date(timeIntervalSince1970: 0))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.dateCol >= Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdateCol == NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdateCol != NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdateCol < NSDate(timeIntervalSince1970: 3))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdateCol <= NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdateCol > NSDate(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(TestObject.self)
                    .filter(\TestObject.nsdateCol >= NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.uuidCol == self.uuid)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.uuidCol != self.uuid)
//                    .execute()
//                XCTAssertEqual(results.count, 0)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.nsuuidCol == self.uuid as NSUUID)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.nsuuidCol != self.uuid as NSUUID)
//                    .execute()
//                XCTAssertEqual(results.count, 0)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.uriCol == URL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.uriCol != URL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 0)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.nsuriCol == NSURL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(TestObject.self)
//                    .filter(\TestObject.nsuriCol != NSURL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 0)
//            } catch {
//                XCTFail("unknown error occurred")
//            }

            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.decimalCol == NSDecimalNumber(string: "0.123"))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.decimalCol != NSDecimalNumber(string: "0.123"))
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.decimalCol == 0.123)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.decimalCol != 0.123)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.decimalCol == nil)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.decimalCol != nil)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.stringCol == "string")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.stringCol != "string")
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.stringCol == nil)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.stringCol != nil)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.stringCol ~= "str*")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsstringCol == "nsstring")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsstringCol != "nsstring")
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsstringCol == nil)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsstringCol != nil)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsstringCol ~= "??string")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dataCol == "data".data(using: String.Encoding.utf8)!)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dataCol != "data".data(using: String.Encoding.utf8)!)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdataCol == "nsdata".data(using: String.Encoding.utf8)! as NSData)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdataCol != "nsdata".data(using: String.Encoding.utf8)! as NSData)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol == Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol != Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol < Date(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol <= Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol > Date(timeIntervalSince1970: 0))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol >= Date(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol < nil)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol <= nil)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol > nil)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.dateCol >= nil)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdateCol == NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdateCol != NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdateCol < NSDate(timeIntervalSince1970: 3))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdateCol <= NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdateCol > NSDate(timeIntervalSince1970: 1))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(OptionalTestObject.self)
                    .filter(\OptionalTestObject.nsdateCol >= NSDate(timeIntervalSince1970: 2))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.uuidCol == self.uuid)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.uuidCol != self.uuid)
//                    .execute()
//                XCTAssertEqual(results.count, 2)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.nsuuidCol == self.uuid as NSUUID)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.nsuuidCol != self.uuid as NSUUID)
//                    .execute()
//                XCTAssertEqual(results.count, 2)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.uriCol == URL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.uriCol != URL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 2)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.nsuriCol == NSURL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 1)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
//            do {
//                let results = try Query(OptionalTestObject.self)
//                    .filter(\OptionalTestObject.nsuriCol != NSURL(string: "https://example.com")!)
//                    .execute()
//                XCTAssertEqual(results.count, 2)
//            } catch {
//                XCTFail("unknown error occurred")
//            }
        }
    }

    func testFilterString() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name == "Katsumi")
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Katsumi")
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name != "Katsumi")
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterInt() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age > 20)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age < 20)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age <= 18)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age < 18)
                    .execute()
                XCTAssertEqual(results.count, 0)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age >= 18)
                    .execute()
                XCTAssertEqual(results.count, 3)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age > 18)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age == 36)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].age, 36)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age != 36)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterFloat() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.weight == 60)
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterBool() {
        context.performAndWait {
            do {
                let results = try Query(Dog.self)
                    .filter(\Dog.vaccinated == true)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Pochi")
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Dog.self)
                    .filter(\Dog.vaccinated != true)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Hachi")
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterDate() {
        let components = DateComponents(calendar: Calendar(identifier: .gregorian), year: 1980, month: 10, day: 28)
        let date = components.date!

        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.birthday == date)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].age, 36)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterObject() {
        context.performAndWait {
            do {
                let person = try Query(Person.self)
                    .filter(\.name == "Katsumi")
                    .execute()[0]

                let results = try Query(Dog.self)
                    .filter(\Dog.owner == person)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Pochi")
                XCTAssertEqual(results[0].age, 4)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterAnd() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name == "Katsumi" && \Person.age == 36)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Katsumi")
                XCTAssertEqual(results[0].age, 36)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterOr() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name == "Katsumi" || \Person.age < 20)
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterNot() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(!(\Person.name == "Katsumi"))
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterChain() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name == "Katsumi")
                    .filter(\Person.age == 36)
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Katsumi")
                XCTAssertEqual(results[0].age, 36)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterIn() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name << ["Katsumi", "Hanako"])
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age << [36, 20])
                    .execute()
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "Katsumi")
                XCTAssertEqual(results[0].age, 36)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterBetween() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.age << (18...24))
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.weight << (50...70))
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterLike() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name ~= "Ka*")
                    .execute()
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Dog.self)
                    .filter(\Dog.name ~= "??chi")
                    .execute()
                XCTAssertEqual(results.count, 2)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testSort() {
        context.performAndWait {
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name == "Katsumi" || \Person.name == "Taro")
                    .sort(\Person.age)
                    .execute()
                XCTAssertEqual(results.count, 2)
                XCTAssertEqual(results[0].name, "Taro")
                XCTAssertEqual(results[1].name, "Katsumi")
            } catch {
                XCTFail("unknown error occurred")
            }
            do {
                let results = try Query(Person.self)
                    .filter(\Person.name == "Katsumi" || \Person.name == "Taro")
                    .sort(\Person.age)
                    .reverse()
                    .execute()
                XCTAssertEqual(results.count, 2)
                XCTAssertEqual(results[0].name, "Katsumi")
                XCTAssertEqual(results[1].name, "Taro")
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testPredicate() {
        context.performAndWait {
            do {
                let predicate = Query(Person.self)
                    .predicate
                XCTAssertNil(predicate)
            }

            do {
                let predicate = Query(Person.self)
                    .filter(\Person.name == "Katsumi")
                    .predicate
                XCTAssertEqual(predicate, NSPredicate(format: "name = \"Katsumi\""))
            }
        }
    }

    func testBuild() {
        context.performAndWait {
            do {
                let request = Query(Person.self).build()
                XCTAssertNil(request.predicate)
                XCTAssertNil(request.sortDescriptors)
            }

            do {
                let request = Query(Person.self)
                    .filter(\Person.name == "Katsumi")
                    .build()
                XCTAssertEqual(request.predicate, NSPredicate(format: "name = \"Katsumi\""))
                XCTAssertNil(request.sortDescriptors)
            }

            do {
                let request = Query(Person.self)
                    .sort(\Person.age)
                    .build()
                XCTAssertNil(request.predicate)
                guard let descriptors = request.sortDescriptors else {
                    return XCTFail("Request sort descriptors are unexpectedly nil")
                }
                XCTAssertEqual(descriptors, [NSSortDescriptor(key: "age", ascending: true)])
            }
        }
    }

    func testController() {
        context.performAndWait {
            do {
                _ = try Query(Person.self).controller(for: context)
                XCTFail("Controller creation should have failed")
            } catch {
                // expect to fail because we're missing a sort descriptor
            }

            do {
                let controller = try Query(Person.self)
                    .sort(\Person.name)
                    .controller(for: context)
                XCTAssertEqual(controller.managedObjectContext, context)
                XCTAssertNil(controller.sectionNameKeyPath)
                XCTAssertNil(controller.cacheName)
            } catch {
                XCTFail("unknown error occurred")
            }

            do {
                let controller = try Query(Person.self)
                    .sort(\Person.name)
                    .controller(for: context, sectionNameKeyPath: "name")
                XCTAssertEqual(controller.managedObjectContext, context)
                XCTAssertEqual(controller.sectionNameKeyPath, "name")
                XCTAssertNil(controller.cacheName)
            } catch {
                XCTFail("unknown error occurred")
            }

            do {
                let controller = try Query(Person.self)
                    .sort(\Person.name)
                    .controller(for: context, sectionNameKeyPath: "name", cacheName: "test")
                XCTAssertEqual(controller.managedObjectContext, context)
                XCTAssertEqual(controller.sectionNameKeyPath, "name")
                XCTAssertEqual(controller.cacheName, "test")
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }
}
