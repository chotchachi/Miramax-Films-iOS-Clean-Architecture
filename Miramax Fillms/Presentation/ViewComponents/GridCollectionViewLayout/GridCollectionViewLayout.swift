//
//  GridCollectionViewLayout.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit

public protocol GridCollectionViewLayoutDelegate: AnyObject {
    func numberOfColumns(_ collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForRow row: Int, inSection section: Int) -> GridCollectionViewLayout.RowHeight
    func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment
}

public class GridLayoutAttributes: UICollectionViewLayoutAttributes {
    var index: GridIndex?
}

public struct GridIndex {
    let row: Int
    let column: Int
}

public class GridCollectionViewLayout: UICollectionViewFlowLayout {

    public enum Alignment: String {
        case top, bottom, center
    }

    public enum RowHeight {
        case maxItemHeight
        case custom(CGFloat)
    }
    
    public enum ElementKind: String {
        case header = "elementKindHeader"
        case footer = "elementKindFooter"
        case cell = "elementKindCell"
    }

    weak var delegate: GridCollectionViewLayoutDelegate?

    let defaultNumberOfColumns = 3
    let defaultCellAlignment: Alignment = .center
    
    var columnSpacing: CGFloat = 0
    var rowSpacing: CGFloat = 0
    var sectionSpacing: CGFloat = 32

    var estimatedColumnSpan = 1
    var estimatedCellHeight: CGFloat = 60

    private var attributes: [ElementKind: [IndexPath: GridLayoutAttributes]] = [:]

    private var collectionViewWidth: CGFloat {
        guard let collectionView = collectionView else { return .zero }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }

    private var collectionViewHeight: CGFloat = 0

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }

    private func reset() {
        self.attributes = [.cell: [:], .header: [:], .footer: [:]]
    }

    public override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        guard self.attributes.isEmpty else { return }
        guard self.delegate?.numberOfColumns(collectionView) ?? defaultNumberOfColumns > 0 else { return }

        reset()

        let numberOfSections = collectionView.numberOfSections
        (0..<numberOfSections).forEach { section in
            prepareSuplementaryView(kind: .header, at: section)
            prepareCells(at: section)
            prepareSuplementaryView(kind: .footer, at: section)

            if section < numberOfSections - 1 {
                collectionViewHeight += sectionSpacing
            }
        }
    }

    private func prepareCells(at section: Int) {
        guard let collectionView = collectionView else { return }
        let itemsCount = collectionView.numberOfItems(inSection: section)

        let numberOfColumns = self.delegate?.numberOfColumns(collectionView) ?? defaultNumberOfColumns
        let alignment = self.delegate?.collectionView(collectionView, alignmentForSection: section) ?? defaultCellAlignment
        
        var row = 0
        var itemIndex = 0

        while (itemsCount - itemIndex) > 0 {
            let rowHeight = self.delegate?.collectionView(collectionView, heightForRow: row, inSection: section) ?? .maxItemHeight
            let columnWidth = (collectionViewWidth - CGFloat(numberOfColumns - 1) * columnSpacing) / CGFloat(numberOfColumns)

            var rowHeightExact: CGFloat!
            
            var availableSpan = numberOfColumns
            (0..<numberOfColumns).forEach { column in
                guard itemIndex < itemsCount else { return }
                guard availableSpan > 0, availableSpan + column == numberOfColumns else { return }
                let indexPath = IndexPath(item: itemIndex, section: section)
                let index = GridIndex(row: row, column: column)

                let cellSpan = min(availableSpan, self.delegate?.collectionView(collectionView, columnSpanForItemAt: index, indexPath: indexPath) ?? estimatedColumnSpan)

                let cellWidth = columnWidth * CGFloat(cellSpan) + CGFloat(cellSpan - 1) * columnSpacing
                
                var itemHeight: CGFloat!
                
                switch rowHeight {
                case .maxItemHeight:
                    itemHeight = self.delegate?.collectionView(collectionView, heightForItemAt: index, indexPath: indexPath) ?? estimatedCellHeight
                    rowHeightExact = itemHeight
                case .custom(let height):
                    itemHeight = min(height, self.delegate?.collectionView(collectionView, heightForItemAt: index, indexPath: indexPath) ?? estimatedCellHeight)
                    rowHeightExact = height
                }

                let cellXPosition = CGFloat(column) * (columnWidth + columnSpacing)
                let cellYPosition: CGFloat
                switch alignment {
                case .top:
                    cellYPosition = collectionViewHeight
                case .bottom:
                    cellYPosition = collectionViewHeight + (rowHeightExact! - itemHeight)
                case .center:
                    cellYPosition = collectionViewHeight + (rowHeightExact! - itemHeight) / 2
                }

                let cellOrigin = CGPoint(x: cellXPosition, y: cellYPosition)
                let cellSize = CGSize(width: cellWidth, height: itemHeight)

                let attributes = GridLayoutAttributes(forCellWith: indexPath)
                attributes.index = index
                attributes.frame = CGRect(origin: cellOrigin, size: cellSize)

                self.attributes[.cell]?[indexPath] = attributes

                itemIndex += 1
                availableSpan -= cellSpan
            }

            row += 1
            collectionViewHeight += rowHeightExact!

            guard itemIndex < itemsCount else { continue }
            collectionViewHeight += rowSpacing
        }
    }

    private func prepareSuplementaryView(kind: ElementKind, at section: Int) {
        guard let collectionView = collectionView else { return }
        guard let height = self.delegate?.collectionView(collectionView, heightForSupplementaryView: kind, at: section) else { return }

        let indexPath = IndexPath(row: 0, section: section)
        let attributes = GridLayoutAttributes(forSupplementaryViewOfKind: kind.rawValue, with: indexPath)
        attributes.frame = CGRect(x: 0, y: collectionViewHeight, width: collectionViewWidth, height: height)
        self.attributes[kind]?[indexPath] = attributes

        collectionViewHeight += height
    }

    public override func invalidateLayout() {
        super.invalidateLayout()
        collectionViewHeight = 0
        attributes.removeAll()
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.values.flatMap { $0.values }.filter { $0.frame.intersects(rect) }
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let kind = ElementKind(rawValue: elementKind) else { return nil }
        return attributes[kind]?[indexPath]
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[.cell]?[indexPath]
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let oldBounds = collectionView?.bounds else { return false }
        return oldBounds.size != newBounds.size
    }

}
