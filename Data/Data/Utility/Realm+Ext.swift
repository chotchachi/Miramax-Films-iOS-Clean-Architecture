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
    func save<R: RMOperator>(entity: R, update: Bool = true) -> Observable<Void> where R: Object  {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entity, update: update ? .all : .error)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func delete<R: RMOperator>(entity: R) -> Observable<Void> where R: Object {
        return Observable.create { observer in
            do {
                guard let object = self.base.object(ofType: R.self, forPrimaryKey: entity.primaryKey()) else { fatalError() }

                try self.base.write {
                    self.base.delete(object)
                }

                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
