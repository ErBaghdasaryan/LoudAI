//
//  TableView.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: IReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: IReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: IReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: IReusableView {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue HeaderFooterView with identifier: \(T.reuseIdentifier)")
        }
        return headerFooterView
    }

    public func addShadow() {
        self.layer.shadowColor = UIColor(hex: "#17171814")!.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
}
