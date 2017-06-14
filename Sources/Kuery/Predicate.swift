//
//  Predicate.swift
//  Kuery
//
//  Created by Kishikawa Katsumi on 2017/06/14.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

public protocol Predicate {
    associatedtype ResultType
    var predicate: NSPredicate { get }
}

public struct BasicPredicate<ManagedObject>: Predicate {
    public typealias ResultType = ManagedObject

    let format: String
    let arguments: [AnyObject]

    public var predicate: NSPredicate {
        return NSPredicate(format: format, argumentArray: arguments)
    }
}

public struct AndPredicate<ManagedObject>: Predicate {
    public typealias ResultType = ManagedObject

    let left: BasicPredicate<ResultType>
    let right: BasicPredicate<ResultType>

    public var predicate: NSPredicate {
        return NSCompoundPredicate(type: .and, subpredicates: [left.predicate, right.predicate])
    }
}

public struct OrPredicate<ManagedObject>: Predicate {
    public typealias ResultType = ManagedObject

    let left: BasicPredicate<ResultType>
    let right: BasicPredicate<ResultType>

    public var predicate: NSPredicate {
        return NSCompoundPredicate(type: .or, subpredicates: [left.predicate, right.predicate])
    }
}

public struct NotPredicate<ManagedObject>: Predicate {
    public typealias ResultType = ManagedObject

    let original: BasicPredicate<ResultType>

    public var predicate: NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: original.predicate)
    }
}
