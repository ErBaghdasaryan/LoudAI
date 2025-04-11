//
//  GenreBlendsCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import Combine
import LoudAIModel

class GenreBlendsCell: UICollectionViewCell, IReusableView {

    private let header = UILabel(text: "Genry Blends",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedGenre: GenreModel?
    private var collectionViewData: [GenreModel] = []
    public let indexSubject = PassthroughSubject<Int, Never>()
    private let deleteButton = UIButton(type: .system)

    public let deleteTapped = PassthroughSubject<Void, Never>()

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

        backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)
        layer.cornerRadius = 16

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

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        self.addSubview(header)
        self.addSubview(collectionView)
        self.addSubview(deleteButton)
        setupConstraints()
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview()
            view.height.equalTo(20)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(header)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(16)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.trailing.equalToSuperview().offset(12)
            view.bottom.equalToSuperview().inset(12)
        }
    }

    func configure(with data: [GenreModel]) {
        self.collectionViewData = data
        self.collectionView.reloadData()
    }

    func getSelectedGenre() -> GenreModel? {
        return self.selectedGenre
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }
}

extension GenreBlendsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
