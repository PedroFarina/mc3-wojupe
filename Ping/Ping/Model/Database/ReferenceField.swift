//
//  ReferenceField.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 06/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class ReferenceField<T: EntityObject> {
    private let record: CKRecord
    private let key: String
    private let action: CKRecord_Reference_Action
    public private(set) var referenceValue: CKRecord.Reference?
    private lazy var _value: T? = {
        guard let referenceValue = referenceValue else {
            return nil
        }
        return DataController.shared().getEntityByID(referenceValue.recordID) as? T
    }()

    public var value: T? {
        get {
            return _value
        }
        set {
            if let newValue = newValue {
                referenceValue = CKRecord.Reference(recordID: newValue.record.recordID, action: action)
                record.setValue(referenceValue, forKey: key)
            } else {
                referenceValue = nil
                record.setValue(nil, forKey: key)
            }
            _value = newValue
        }
    }

    public init(record: CKRecord, key: String, action: CKRecord_Reference_Action) {
        self.record = record
        self.key = key
        self.action = action
        self.referenceValue = record.value(forKey: key) as? CKRecord.Reference
    }
}

extension ReferenceField {
    static func == (lhs: T, rhs: ReferenceField) -> Bool {
        return lhs == rhs.value
    }
    static func != (lhs: T, rhs: ReferenceField) -> Bool {
        return lhs != rhs.value
    }

    static func == (lhs: ReferenceField, rhs: T) -> Bool {
        return lhs.value == rhs
    }
    static func != (lhs: ReferenceField, rhs: T) -> Bool {
        return lhs.value != rhs
    }
}
