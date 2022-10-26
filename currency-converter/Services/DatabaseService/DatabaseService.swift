//
//  DatabaseService.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import RealmSwift

final class DatabaseService: DatabaseServiceInterface {
    func add(
        _ object: Object,
        completion: ((Error?) -> Void)?
    ) {
        performInWorkingQueue {
            do {
                let db: Realm = try .init()
                try db.write {
                    db.add(object)
                }
                completion?(nil)
            } catch {
                completion?(error)
            }
        }
    }

    func update<T: Object>(
        where rule: @escaping (Query<T>) -> Query<Bool>,
        _ updateBlock: @escaping (T?) -> Void,
        completion: ((Error?) -> Void)?
    ) {
        performInWorkingQueue {
            do {
                let db: Realm = try .init()
                let object: T? = db.objects(T.self).where(rule).first
                try db.write {
                    updateBlock(object)
                }
                completion?(nil)
            } catch {
                completion?(error)
            }
        }
    }

    func getAll<T: Object>(_ result: @escaping (Results<T>) -> Void) {
        performInWorkingQueue {
            let db: Realm = try! .init()
            result(db.objects(T.self))
        }
    }

    func getAllMapped<T: Object, M>(
        mapper: @escaping (T) -> M,
        _ result: @escaping ([M]) -> Void
    ) {
        performInWorkingQueue {
            let db: Realm = try! .init()
            let objects: [T] = db.objects(T.self).map { $0 }
            let mappedObjects: [M] = objects.map { mapper($0) }
            result(mappedObjects)
        }
    }

    func get<T: Object>(
        where rule: @escaping (Query<T>) -> Query<Bool>,
        _ result: @escaping (Results<T>) -> Void
    ) {
        performInWorkingQueue {
            let db: Realm = try! .init()
            result(
                db.objects(T.self).where(rule)
            )
        }
    }

    func delete<T: Object>(where rule: @escaping (Query<T>) -> Query<Bool>) {
        performInWorkingQueue {
            let db: Realm = try! .init()
            let objects: Results<T> = db.objects(T.self).where(rule)
            try! db.write {
                objects.forEach(db.delete)
            }
        }
    }

    func deleteAll() {
        performInWorkingQueue {
            let db: Realm = try! .init()
            try! db.write {
                db.deleteAll()
            }
        }
    }
}
