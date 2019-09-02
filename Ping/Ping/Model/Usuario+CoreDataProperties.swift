//
//  Usuario+CoreDataProperties.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 30/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import CoreData

extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var usuarioId: UUID?
    @NSManaged public var campainhas: NSOrderedSet?

}

// MARK: Generated accessors for campainhas
extension Usuario {

    @objc(insertObject:inCampainhasAtIndex:)
    @NSManaged public func insertIntoCampainhas(_ value: Campainha, at idx: Int)

    @objc(removeObjectFromCampainhasAtIndex:)
    @NSManaged public func removeFromCampainhas(at idx: Int)

    @objc(insertCampainhas:atIndexes:)
    @NSManaged public func insertIntoCampainhas(_ values: [Campainha], at indexes: NSIndexSet)

    @objc(removeCampainhasAtIndexes:)
    @NSManaged public func removeFromCampainhas(at indexes: NSIndexSet)

    @objc(replaceObjectInCampainhasAtIndex:withObject:)
    @NSManaged public func replaceCampainhas(at idx: Int, with value: Campainha)

    @objc(replaceCampainhasAtIndexes:withCampainhas:)
    @NSManaged public func replaceCampainhas(at indexes: NSIndexSet, with values: [Campainha])

    @objc(addCampainhasObject:)
    @NSManaged public func addToCampainhas(_ value: Campainha)

    @objc(removeCampainhasObject:)
    @NSManaged public func removeFromCampainhas(_ value: Campainha)

    @objc(addCampainhas:)
    @NSManaged public func addToCampainhas(_ values: NSOrderedSet)

    @objc(removeCampainhas:)
    @NSManaged public func removeFromCampainhas(_ values: NSOrderedSet)

}
