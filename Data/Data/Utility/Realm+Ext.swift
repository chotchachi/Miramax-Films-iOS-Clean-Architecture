//
//  Realm+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 23/09/2022.
//

import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension Reactive where Base == Realm {
    func save<R: RMOperator>(entity: R, update: Bool = true) -> Completable where R: Object  {
        return Completable.create { completable in
            do {
                try self.base.write {
                    self.base.add(entity, update: update ? .all : .error)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    func delete<R: RMOperator>(entity: R) -> Completable where R: Object {
        return Completable.create { completable in
            do {
                guard let object = self.base.object(ofType: R.self, forPrimaryKey: entity.primaryKey()) else { fatalError() }

                try self.base.write {
                    self.base.delete(object)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func delete<R: RMOperator>(entities: [R]) -> Completable where R: Object {
        return Completable.create { completable in
            do {
                try self.base.write {
                    self.base.delete(entities)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
