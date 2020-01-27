//
//  ReferenceList.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 09/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit

public class ReferenceList<T: EntityObject> {
    private let record: CKRecord
    private let key: String
    public var recordReferences: [CKRecord.Reference] = []
    private var _references: [T] =  []
    public private(set) var references: [T] {
        get {
            if _references.count != recordReferences.count {
                for record in recordReferences {
                    guard let reference = DataController.shared().getEntityByID(record.recordID) as? T else {
                        continue
                    }
                    _references.append(reference)
                }
            }
            return _references
        }
        set {
            _references = newValue
        }
    }

    public init(record: CKRecord, key: String) {
        self.record = record
        if let refs = record.value(forKey: key) as? [CKRecord.Reference] {
            self.recordReferences = refs
        }
        self.key = key
    }

    public func append(_ value: T, action: CKRecord_Reference_Action) {
        references.append(value)
        let ref = CKRecord.Reference(recordID: value.record.recordID, action: action)
        recordReferences.append(ref)
        record[key] = recordReferences
    }

    public func firstIndex(of value: T) -> Int? {
        return references.firstIndex(of: value)
    }

    public func contains(_ value: T) -> Bool {
        return references.contains(value)
    }

    public func remove(at index: Int) {
        references.remove(at: index)
        recordReferences.remove(at: index)
        record.setValue(recordReferences, forKey: key)
    }

    public func removeAll() {
        references = []
        recordReferences = []
        record.setValue(recordReferences, forKey: key)
    }
}

extension ReferenceList {
    static func == (lhs: [T], rhs: ReferenceList) -> Bool {
        let count = lhs.count
        if count != rhs.references.count {
            return false
        }
        var ret: Bool = true
        for index in 0..<count {
            ret = ret && lhs[index] == rhs.references[index]
        }

        return ret
    }
    static func != (lhs: [T], rhs: ReferenceList) -> Bool {
        let count = lhs.count
        if count != rhs.references.count {
            return true
        }
        var ret: Bool = false
        for index in 0..<count {
            ret = ret || lhs[index] == rhs.references[index]
        }

        return ret
    }

    static func == (lhs: ReferenceList, rhs: [T]) -> Bool {
        let count = rhs.count
        if count != lhs.references.count {
            return false
        }
        var ret: Bool = true
        for index in 0..<count {
            ret = ret && rhs[index] == lhs.references[index]
        }

        return ret
    }
    static func != (lhs: ReferenceList, rhs: [T]) -> Bool {
        let count = rhs.count
        if count != lhs.references.count {
            return true
        }
        var ret: Bool = false
        for index in 0..<count {
            ret = ret || rhs[index] == lhs.references[index]
        }

        return ret
    }
}
