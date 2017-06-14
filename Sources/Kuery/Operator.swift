//
//  Operators.swift
//  Kuery
//
//  Created by Kishikawa Katsumi on 2017/06/14.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation
import CoreData

// MARK: Logical Operators

public func && <ManagedObject>(lhs: BasicPredicate<ManagedObject>, rhs: BasicPredicate<ManagedObject>) -> AndPredicate<ManagedObject> {
    return AndPredicate(left: lhs, right: rhs)
}

public func || <ManagedObject>(lhs: BasicPredicate<ManagedObject>, rhs: BasicPredicate<ManagedObject>) -> OrPredicate<ManagedObject> {
    return OrPredicate(left: lhs, right: rhs)
}

public prefix func ! <ManagedObject>(predicate: BasicPredicate<ManagedObject>) -> NotPredicate<ManagedObject> {
    return NotPredicate(original: predicate)
}

// MARK: String

public func == <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, String?>, rhs: String) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSString])
}

public func != <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, String?>, rhs: String) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSString])
}

public func ~= <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, String?>, rhs: String) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K LIKE %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSString])
}

public func << <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, String?>, rhs: [String]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSArray])
}

// MARK: Bool

public func == <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Bool>, rhs: Bool) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSNumber])
}

public func != <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Bool>, rhs: Bool) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSNumber])
}

public func << <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Bool>, rhs: [Bool]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSArray])
}

// MARK: URL

public func == <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, URL?>, rhs: URL) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSURL])
}

public func != <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, URL?>, rhs: URL) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSURL])
}

public func << <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, URL?>, rhs: [URL]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSArray])
}

// MARK: UUID

public func == <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, UUID?>, rhs: UUID) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSUUID])
}

public func != <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, UUID?>, rhs: UUID) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSUUID])
}

public func << <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, UUID?>, rhs: [UUID]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSArray])
}

// MARK: Object

public func == <ManagedObject: NSManagedObject, RelationObject: NSManagedObject>(lhs: KeyPath<ManagedObject, RelationObject?>, rhs: RelationObject) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs])
}

public func != <ManagedObject: NSManagedObject, RelationObject: NSManagedObject>(lhs: KeyPath<ManagedObject, RelationObject?>, rhs: RelationObject) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs])
}

public func << <ManagedObject: NSManagedObject, RelationObject: NSManagedObject>(lhs: KeyPath<ManagedObject, RelationObject?>, rhs: [RelationObject]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSArray])
}

// MARK: Numeric

public func < <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K < %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as! NSNumber])
}

public func > <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K > %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as! NSNumber])
}

public func <= <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K <= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as! NSNumber])
}

public func >= <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K >= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as! NSNumber])
}

public func == <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as! NSNumber])
}

public func != <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as! NSNumber])
}

public func << <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: [Property]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSArray])
}

public func << <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: ClosedRange<Property>) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K BETWEEN %@", arguments: [lhs._kvcKeyPathString! as NSString, [rhs.lowerBound, rhs.upperBound] as NSArray])
}

public func << <ManagedObject: NSManagedObject, Property: Numeric>(lhs: KeyPath<ManagedObject, Property>, rhs: CountableClosedRange<Property>) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K BETWEEN %@", arguments: [lhs._kvcKeyPathString! as NSString, [rhs.lowerBound, rhs.upperBound] as NSArray])
}

// MARK: Date

public func < <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Date?>, rhs: Date) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K < %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSDate])
}

public func > <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Date?>, rhs: Date) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K > %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSDate])
}

public func <= <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Date?>, rhs: Date) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K <= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSDate])
}

public func >= <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Date?>, rhs: Date) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K >= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSDate])
}

public func == <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Date?>, rhs: Date) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSDate])
}

public func != <ManagedObject: NSManagedObject>(lhs: KeyPath<ManagedObject, Date?>, rhs: Date) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs as NSDate])
}
