import Foundation
import RealmSwift

/// Represents a type that can be persisted using Realm.
public protocol Persistable {
    associatedtype ManagedObject: Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
