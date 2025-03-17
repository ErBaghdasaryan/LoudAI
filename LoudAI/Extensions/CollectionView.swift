//
//  CollectionView.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) where T: IReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func registerReusableView<T: UICollectionReusableView>(_: T.Type, kind: String) where T: IReusableView {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: IReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }

    func dequeueCollectionReusableView<T: UICollectionReusableView>(with kind: String, indexPath: IndexPath) -> T where T: IReusableView {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue reusableView with identifier: \(T.reuseIdentifier)")
        }

        return reusableView
    }

    func getCurrentIndex() ->IndexPath? {
        let centerPoint = CGPoint(x: self.contentOffset.x + (self.frame.width / 2), y: (self.frame.height / 2));
        return self.indexPathForItem(at: centerPoint)
    }
}
