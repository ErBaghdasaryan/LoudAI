//
//  GenreCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 27.03.25.
//

import UIKit
import Combine
import LoudAIModel

class GenreCell: UICollectionViewCell, IReusableView {

    private let header = UILabel(text: "Genre",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedGenre: GenreModel?
    private var collectionViewData: [GenreModel] = []
    public let indexSubject = PassthroughSubject<Int, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

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

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 77, height: 95)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(GenreCollectionViewCell.self)
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
            view.height.equalTo(20)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    func configure(with data: [GenreModel]) {
        self.collectionViewData = data
        self.collectionView.reloadData()
    }

    func getSelectedGenre() -> GenreModel? {
        return self.selectedGenre
    }
}

extension GenreCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GenreCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.updateSelectionState(isSelected: indexPath == selectedIndex)

        cell.configure(with: collectionViewData[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let previousIndex = selectedIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? GenreCollectionViewCell {
            previousCell.updateSelectionState(isSelected: false)
        }

        selectedIndex = indexPath
        selectedGenre = self.collectionViewData[indexPath.row]

        if let newCell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell {
            newCell.updateSelectionState(isSelected: true)
        }

        self.indexSubject.send(indexPath.row)
    }
}
