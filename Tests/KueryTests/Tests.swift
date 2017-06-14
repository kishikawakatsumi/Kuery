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

            try context.save()
        }  catch {
            XCTFail("Failed to save initial data")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchAll() {
        context.perform {
            do {
                let results = try Query(Person.self).execute()
                XCTAssertEqual(results.count, 3)
            } catch {
                XCTFail("unknown error occurred")
            }
        }
    }

    func testFilterString() {
        context.perform {
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
        context.perform {
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
        context.perform {
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
        context.perform {
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

        context.perform {
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
        context.perform {
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
        context.perform {
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
        context.perform {
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
        context.perform {
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
        context.perform {
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
        context.perform {
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
        context.perform {
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

    func testSort() {
        context.perform {
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
}
