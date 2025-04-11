//
//  SubGenreCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import Combine
import LoudAIModel

class SubGenreCell: UICollectionViewCell, IReusableView {

    private let header = UILabel(text: "Sub Genre",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedGenre: String?
    private var collectionViewData: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.header.textAlignment = .left

        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(SubGenreCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        self.addSubview(header)
        self.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(18)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    func configure(with data: [String]) {
        self.collectionViewData = data
        self.collectionView.reloadData()
    }

    func getSelectedGenre() -> String? {
        return self.selectedGenre
    }
}

extension SubGenreCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SubGenreCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.updateSelectionState(isSelected: indexPath == selectedIndex)

        cell.setup(with: collectionViewData[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let text = collectionViewData[indexPath.row]
        let font = UIFont(name: "SFProText-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)

        let textWidth = text.size(withAttributes: [.font: font]).width

        return CGSize(width: textWidth + 16, height: 28)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let previousIndex = selectedIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? SubGenreCollectionViewCell {
            previousCell.updateSelectionState(isSelected: false)
        }

        selectedIndex = indexPath
        selectedGenre = self.collectionViewData[indexPath.row]

        if let newCell = collectionView.cellForItem(at: indexPath) as? SubGenreCollectionViewCell {
            newCell.updateSelectionState(isSelected: true)
        }
    }
}
