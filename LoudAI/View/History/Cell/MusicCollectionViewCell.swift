//
//  MusicCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 25.03.25.
//

import UIKit
import SnapKit
import Combine

class MusicCollectionViewCell: UICollectionViewCell, IReusableView {

    private let cyrcleView = UIView()
    private let firstImage = UIImageView()
    private let secondImage = UIImageView()
    private let titleLabel = UILabel(text: "Key",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 16))

    private let deleteButton = UIButton(type: .system)
    public let deleteTapped = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()

    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedRoot: String?
    private var collectionViewData: [String] = []

    private var selectedQuality = "minor"

    public let currentValuesSubject = PassthroughSubject<(String, String), Never>()

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

        cyrcleView.layer.cornerRadius = 45
        cyrcleView.layer.borderColor = UIColor.white.cgColor
        cyrcleView.layer.borderWidth = 1

        self.firstImage.layer.masksToBounds = true
        self.firstImage.layer.cornerRadius = 12
        self.firstImage.contentMode = .scaleAspectFill

        self.secondImage.layer.masksToBounds = true
        self.secondImage.layer.cornerRadius = 12
        self.secondImage.contentMode = .scaleAspectFill

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

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

        contentView.addSubview(cyrcleView)
        contentView.addSubview(firstImage)
        contentView.addSubview(secondImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {

        cyrcleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(90)
            make.width.equalTo(90)
        }

        firstImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(72)
            make.width.equalTo(72)
        }

        secondImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.equalToSuperview().offset(41)
            make.height.equalTo(72)
            make.width.equalTo(72)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(secondImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(40)
            make.height.equalTo(18)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(titleLabel.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.bottom.equalToSuperview().inset(12)
        }
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }
}

extension MusicCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        selectedRoot = self.collectionViewData[indexPath.row]

        if let newCell = collectionView.cellForItem(at: indexPath) as? SubGenreCollectionViewCell {
            newCell.updateSelectionState(isSelected: true)
        }

        self.currentValuesSubject.send((selectedRoot!, self.selectedQuality))
    }
}
