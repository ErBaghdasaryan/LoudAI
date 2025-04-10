//
//  AddCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 27.03.25.
//

import UIKit
import Combine
import LoudAIModel

class AddCell: UICollectionViewCell, IReusableView {

    var collectionView: UICollectionView!
    let istrumentsData = ["Genre", "Duration", "Instrument", "Genry Blend", "Energy", "Structure", "Tempo", "Key"]
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

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 56, height: 80)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(IntrumentCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        self.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

//    func configure(with title: String, and image: UIImage) {
//        self.image.image = image
//        self.date.text = title
//    }
}

extension AddCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.istrumentsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IntrumentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        if indexPath.row == 0 {
            cell.configure(with: self.istrumentsData[indexPath.row], isGenre: true)
        } else {
            cell.configure(with: self.istrumentsData[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(indexPath.row == 0) {
            self.indexSubject.send(indexPath.row)
        }
    }
}
