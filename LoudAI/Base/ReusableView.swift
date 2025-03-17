//
//  ReusableView.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit

protocol IReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension IReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
