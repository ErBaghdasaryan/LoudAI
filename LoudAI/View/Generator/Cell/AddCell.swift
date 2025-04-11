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

    private var selectedTypes: [CellType] = []

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

    func updateSelectedCells(_ selected: [CellType]) {
        self.selectedTypes = selected
        self.collectionView.reloadData()
    }
}

extension AddCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.istrumentsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IntrumentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        let title = istrumentsData[indexPath.row]
        if indexPath.row == 0 {
            cell.configure(with: title, isGenre: true)
            return cell
        } else {
            cell.configure(with: title)
        }

        let type: CellType?
        switch indexPath.row {
        case 0: type = .subGenre
        case 1: type = .duration
        case 2: type = .instruments
        case 3: type = .genreBlends
        case 4: type = .energy
        case 5: type = .structure
        case 6: type = .tempo
        case 7: type = .key
        default: type = nil
        }

        if let type = type {
            let isAdded = selectedTypes.contains(type)
            cell.updateStateUI(isAdded: isAdded)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(indexPath.row == 0) {
            self.indexSubject.send(indexPath.row)

            if let cell = collectionView.cellForItem(at: indexPath) as? IntrumentCollectionViewCell {
                cell.updateStateUI(isAdded: true)
            }
        }
    }
}
