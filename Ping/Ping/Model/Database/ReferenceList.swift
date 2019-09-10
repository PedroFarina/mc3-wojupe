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
    private var _references: [CKRecord.Reference] = []
    public private(set) var references: [T] = []

    public init(record: CKRecord, key: String) {
        self.record = record
        if let refs = record.value(forKey: key) as? [CKRecord.Reference] {
            self._references = refs
        }
        self.key = key
    }

    public func append(_ value: T, action: CKRecord_Reference_Action) {
        references.append(value)
        let ref = CKRecord.Reference(recordID: value.record.recordID, action: action)
        _references.append(ref)
        record[key] = _references
    }

    public func firstIndex(of value: T) -> Int? {
        return references.firstIndex(of: value)
    }

    public func contains(_ value: T) -> Bool {
        return references.contains(value)
    }

    public func remove(at index: Int) {
        references.remove(at: index)
        _references.remove(at: index)
        record.setValue(_references, forKey: key)
    }
}
//public class ReferenceList<T: EntityObject> {
//    private let record: CKRecord
//    private let key: String
//    public var references: [ReferenceField<T>] = [] {
//        didSet {
//            var refs: [CKRecord.Reference] = []
//            for reference in references {
//                if let ref = reference.referenceValue {
//                    refs.append(ref)
//                }
//            }
//            record.setValue(refs, forKey: key)
//        }
//    }
//
//    public init(record: CKRecord, key: String) {
//        self.record = record
//        self.key = key
//    }
//
//    public func append(_ value: T, action: CKRecord_Reference_Action) {
//        references.append(ReferenceField<T>(record: self.record, key: self.key, action: action))
//    }
//
//    public func firstIndex(of value: T) -> Int? {
//        return references.firstIndex(where: { (ref) -> Bool in
//            return ref.value == value
//        })
//    }
//
//    public func contains(_ value: T) -> Bool {
//        return references.contains(where: { (ref) -> Bool in
//            return ref.value == value
//        })
//    }
//
//    public func remove(at index: Int) {
//        references.remove(at: index)
//    }
//}

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
