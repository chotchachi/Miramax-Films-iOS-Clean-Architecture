//
//  RMBookmarkPerson.swift
//  Data
//
//  Created by Thanh Quang on 08/10/2022.
//

import RealmSwift
import Domain

public final class RMBookmarkPerson: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var name: String = ""
    @Persisted var profilePath: String?
    @Persisted var birthday: String?
    @Persisted var biography: String?
    @Persisted var createAt: Date = Date()
}

extension RMBookmarkPerson: RMOperator {
    public func primaryKey() -> Int {
        return _id
    }
}

extension RMBookmarkPerson: DomainConvertibleType {
    public func asDomain() -> BookmarkPerson {
        return BookmarkPerson(id: _id, name: name, profilePath: profilePath, birthday: birthday, biography: biography, createAt: createAt)
    }
}

extension BookmarkPerson: RealmRepresentable {
    public func asRealm() -> RMBookmarkPerson {
        return RMBookmarkPerson.build { object in
            object._id = id
            object.name = name
            object.profilePath = profilePath
            object.birthday = birthday
            object.biography = biography
            object.createAt = createAt
        }
    }
}
