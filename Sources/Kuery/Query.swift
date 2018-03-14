//
//  Query.swift
//  Kuery
//
//  Created by Kishikawa Katsumi on 2017/06/14.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation
import CoreData

public enum QueryError: Error {
    case needsSortDescriptor
}

public class Query<ResultType> where ResultType : NSFetchRequestResult {
    private let fetchRequest: NSFetchRequest<ResultType>

    public init(_: ResultType.Type) {
        fetchRequest = NSFetchRequest(entityName: String(describing: ResultType.self))
    }

    public func execute() throws -> [ResultType] {
        return try fetchRequest.execute()
    }

    public func filter<P: Predicate>(_ predicate: @autoclosure () -> P) -> Query where P.ResultType == ResultType {
        if let currentPredicate = fetchRequest.predicate {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPredicate, predicate().predicate])
            return self
        }
        fetchRequest.predicate = predicate().predicate
        return self
    }

    public func sort(_ keyPath: PartialKeyPath<ResultType>) -> Query {
        let sortDescriptor = NSSortDescriptor(key: keyPath._kvcKeyPathString!, ascending: true)
        if let sortDescriptors = fetchRequest.sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors + [sortDescriptor]
            return self
        }
        fetchRequest.sortDescriptors = [sortDescriptor]
        return self
    }

    public func reverse() -> Query {
        if let sortDescriptors = fetchRequest.sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors.flatMap { $0.reversedSortDescriptor as? NSSortDescriptor }
            return self
        }
        return self
    }

    public func build() -> NSFetchRequest<ResultType> {
        let request = NSFetchRequest<ResultType>(entityName: String(describing: ResultType.self))

        request.predicate = fetchRequest.predicate
        request.sortDescriptors = fetchRequest.sortDescriptors

        return request
    }

    public func controller(for context: NSManagedObjectContext, sectionNameKeyPath: String? = nil, cacheName: String? = nil) throws -> NSFetchedResultsController<ResultType> {
        let request = build()

        guard !(request.sortDescriptors?.isEmpty ?? true) else {
            throw QueryError.needsSortDescriptor
        }

        return NSFetchedResultsController<ResultType>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
    }

    public var predicate: NSPredicate? {
        return fetchRequest.predicate
    }
}
