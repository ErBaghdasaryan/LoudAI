//
//  KeyCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import SnapKit
import Combine

class KeyCell: UICollectionViewCell, IReusableView {

    private let titleLabel = UILabel(text: "Key",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 16))
    private let segmentControl = UISegmentedControl(items: ["Minor",
                                                    "Major"])

    private let deleteButton = UIButton(type: .system)
    public let deleteTapped = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()

    var collectionView: UICollectionView!
    private var selectedIndex: IndexPath?
    private var selectedRoot: String?
    private var collectionViewData: [String] = ["C#/Db", "D#/Eb", "F#/Gb", "G#/Ab", "Bb", "C", "D", "E", "F", "G", "A", "B"]

    private var selectedQuality = "minor"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    private func setupUI() {
        backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)
        layer.cornerRadius = 16

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)
        segmentControl.selectedSegmentTintColor = UIColor.white
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.7)], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        self.segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

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

        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(segmentControl)
        contentView.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(16)
        }

        segmentControl.snp.makeConstraints { view in
            view.top.equalTo(titleLabel.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(42)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(segmentControl.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.bottom.equalToSuperview().inset(12)
        }
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedQuality = "minor"
        case 1:
            self.selectedQuality = "major"
        default:
            break
        }
    }

    public func returnSelectedQuality() -> String {
        return self.selectedQuality
    }

    public func returnSelectedRoot() -> String {
        return self.selectedQuality
    }
}

extension KeyCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
    }
}
