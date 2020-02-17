//
//  DataProperty.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 03/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class DataProperty<T: Equatable> {
    private let record: CKRecord
    private let key: String
    public var value: T {
        get {
            guard let val = record.value(forKey: key) as? T else {
                fatalError("Não foi possível converter a data para a tipagem indicada.")
            }
            return val
        }
        set {
            record.setValue(newValue, forKey: key)
        }
    }

    init(record: CKRecord, key: String) {
        self.record = record
        self.key = key
    }
}

extension DataProperty {
    static func == (lhs: T, rhs: DataProperty) -> Bool {
        return lhs == rhs.value
    }
    static func != (lhs: T, rhs: DataProperty) -> Bool {
        return lhs != rhs.value
    }
    static func == (lhs: DataProperty, rhs: T) -> Bool {
        return lhs.value == rhs
    }
    static func != (lhs: DataProperty, rhs: T) -> Bool {
        return lhs.value != rhs
    }
}
