//
//  Campainha+CoreDataProperties.swift
//  Ping
//
//  Created by Wolfgang Walder on 02/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//
//

import Foundation
import CoreData

extension Campainha {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Campainha> {
        return NSFetchRequest<Campainha>(entityName: "Campainha")
    }

    @NSManaged public var descricao: String?
    @NSManaged public var titulo: String?
    @NSManaged public var url: String?
    @NSManaged public var senha: String?
    @NSManaged public var dono: Usuario?

}
