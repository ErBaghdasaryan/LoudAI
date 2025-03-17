//
//  OnboardingCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import SnapKit

final class OnboardingCell: UICollectionViewCell, IReusableView {

    private var image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        self.addSubview(image)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    public func setup(image: String) {
        self.image.image = UIImage(named: image)
    }
}
