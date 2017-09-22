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

// MARK: EquatableProperty
public func == <ManagedObject: NSManagedObject, Property: EquatableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func != <ManagedObject: NSManagedObject, Property: EquatableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func ~= <ManagedObject: NSManagedObject, Property: RegexMatchableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: String) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K LIKE %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func << <ManagedObject: NSManagedObject, Property: EquatableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: [Property]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs.map { $0._object } as NSArray])
}

// MARK: Optional<EquatableProperty>
public func == <ManagedObject: NSManagedObject, Property: EquatableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: Property?) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K == %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs?._object ?? NSNull()])
}

public func != <ManagedObject: NSManagedObject, Property: EquatableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: Property?) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K != %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs?._object ?? NSNull()])
}

public func ~= <ManagedObject: NSManagedObject, Property: RegexMatchableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: String) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K LIKE %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func << <ManagedObject: NSManagedObject, Property: EquatableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: [Property]) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K IN %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs.map { $0._object } as NSArray])
}

// MARK: ComparableProperty
public func < <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K < %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func > <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K > %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func <= <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K <= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func >= <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: Property) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K >= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs._object])
}

public func << <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: ClosedRange<Property>) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K BETWEEN %@", arguments: [lhs._kvcKeyPathString! as NSString, [rhs.lowerBound, rhs.upperBound] as NSArray])
}

public func << <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property>, rhs: CountableClosedRange<Property>) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K BETWEEN %@", arguments: [lhs._kvcKeyPathString! as NSString, [rhs.lowerBound, rhs.upperBound] as NSArray])
}

// MARK: Optional<ComparableProperty>
public func < <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: Property?) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K < %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs?._object ?? NSNull()])
}

public func > <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: Property?) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K > %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs?._object ?? NSNull()])
}
public func <= <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: Property?) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K <= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs?._object ?? NSNull()])
}

public func >= <ManagedObject: NSManagedObject, Property: ComparableProperty>(lhs: KeyPath<ManagedObject, Property?>, rhs: Property?) -> BasicPredicate<ManagedObject> {
    return BasicPredicate<ManagedObject>(format: "%K >= %@", arguments: [lhs._kvcKeyPathString! as NSString, rhs?._object ?? NSNull()])
}
