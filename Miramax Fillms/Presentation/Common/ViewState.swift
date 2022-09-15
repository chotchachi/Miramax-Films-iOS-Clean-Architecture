//
//  ViewState.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/09/2022.
//

enum ViewState<Entity>: Equatable where Entity: Equatable {
    case initial
    case paging([Entity], next: Int)
    case populated([Entity])
    case empty
    case error(Error)

    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (let .paging(lhsEntities, _), let .paging(rhsEntities, _)):
            return lhsEntities == rhsEntities
        case (let .populated(lhsEntities), let .populated(rhsEntities)):
            return lhsEntities == rhsEntities
        case (.empty, .empty):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }

    var currentEntities: [Entity] {
        switch self {
        case .populated(let entities):
            return entities
        case .paging(let entities, _):
            return entities
        case .initial, .empty, .error:
            return []
        }
    }

    var currentPage: Int {
        switch self {
        case .initial, .populated, .empty, .error:
            return 1
        case .paging(_, let page):
            return page
        }
    }

    var isInitialPage: Bool {
        return currentPage == 1
    }

    var needsPrefetch: Bool {
        switch self {
        case .initial, .populated, .empty, .error:
            return false
        case .paging:
            return true
        }
    }

}
