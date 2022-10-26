//
//  DatabaseServiceInterface.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import RealmSwift

protocol DatabaseServiceInterface: AnyService {
    func add(
        _ object: Object,
        completion: ((Error?) -> Void)?
    )
    func update<T: Object>(
        where rule: @escaping (Query<T>) -> Query<Bool>,
        _ updateBlock: @escaping (T?) -> Void,
        completion: ((Error?) -> Void)?
    )
    func getAll<T: Object>(_ result: @escaping (Results<T>) -> Void)
    func getAllMapped<T: Object, M>(
        mapper: @escaping (T) -> M,
        _ result: @escaping ([M]) -> Void
    )
    func get<T: Object>(
        where rule: @escaping (Query<T>) -> Query<Bool>,
        _ result: @escaping (Results<T>) -> Void
    )
    func delete<T: Object>(where rule: @escaping (Query<T>) -> Query<Bool>)
    func deleteAll()
}

extension DatabaseServiceInterface {
    func add(
        _ object: Object
    ) {
        add(
            object,
            completion: nil
        )
    }

    func update<T: Object>(
        where rule: @escaping (Query<T>) -> Query<Bool>,
        _ updateBlock: @escaping (T?) -> Void
    ) {
        update(
            where: rule,
            updateBlock,
            completion: nil
        )
    }
}
