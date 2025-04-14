//
//  InstrumentsCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import SnapKit
import Combine
import LoudAIModel

class InstrumentsCell: UICollectionViewCell, IReusableView {

    private let titleLabel = UILabel(text: "Instruments",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 16))

    private let deleteButton = UIButton(type: .system)
    public let deleteTapped = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()

    private let firstLine = UIView()
    private let secondLine = UIView()

    private let countLabel = UILabel(text: "0/7",
                                     textColor: .white.withAlphaComponent(0.7),
                                     font: UIFont(name: "SFProText-Regular", size: 14))
    private let randomise = UIButton(type: .system)

    private var resultArrat: [String] = [] {
        willSet {
            self.countLabel.text = "\(newValue.count)/7"
            self.currentArraySubject.send(resultArrat)
        }
    }

    var collectionView: UICollectionView!
    private let collectionViewData: [InstrumentModel] = [
        .init(imageName: "drums", name: "Drums"),
        .init(imageName: "synth", name: "Synth"),
        .init(imageName: "Percussion", name: "Percussion"),
        .init(imageName: "bass", name: "Bass"),
        .init(imageName: "fx", name: "FX"),
        .init(imageName: "keys", name: "Keys"),
        .init(imageName: "vocal", name: "Vocals"),
        .init(imageName: "tonal-percussion", name: "Tonal Percussion"),
        .init(imageName: "guitar", name: "Guittar")
    ]

    public let currentArraySubject = PassthroughSubject<[String], Never>()

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

        firstLine.backgroundColor = UIColor(hex: "#353746")
        secondLine.backgroundColor = UIColor(hex: "#353746")

        countLabel.textAlignment = .left

        randomise.setTitle("Randomise", for: .normal)
        randomise.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        randomise.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        randomise.setImage(UIImage(named: "randomise"), for: .normal)
        randomise.tintColor = UIColor.white.withAlphaComponent(0.7)
        randomise.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        randomise.titleEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 6)
        randomise.layer.masksToBounds = true
        randomise.layer.cornerRadius = 12
        randomise.layer.borderWidth = 1
        randomise.layer.borderColor = UIColor(hex: "#E1E1E1")?.cgColor

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        let mylayout = UICollectionViewFlowLayout()
        mylayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.register(InstrCollectionViewCell.self)
        collectionView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self

        randomise.addTarget(self, action: #selector(randomiseTapped), for: .touchUpInside)

        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(firstLine)
        contentView.addSubview(countLabel)
        contentView.addSubview(randomise)
        contentView.addSubview(secondLine)
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

        firstLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }

        countLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(16)
        }

        randomise.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }

        secondLine.snp.makeConstraints { make in
            make.top.equalTo(randomise.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(secondLine.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }

    func returnResultArray() -> [String] {
        return self.resultArrat
    }

    @objc private func randomiseTapped() {
        resultArrat.removeAll()

        let random7 = collectionViewData.shuffled().prefix(7)

        resultArrat = random7.map { $0.name.uppercased() }

        for (index, model) in collectionViewData.enumerated() {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? InstrCollectionViewCell else { continue }

            if resultArrat.contains(model.name.uppercased()) {
                cell.shareCountInt = 1
            } else {
                cell.resetCount()
            }
        }

        currentArraySubject.send(self.resultArrat)
    }
}

//MARK: Collection view delegate
extension InstrumentsCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InstrCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        let model = self.collectionViewData[indexPath.row]
        cell.setup(with: model)
        
        cell.deleteSubject.sink { _ in
            cell.minusSharesCount()
            if let index = self.resultArrat.firstIndex(of: model.name.uppercased()) {
                self.resultArrat.remove(at: index)
            }
            print(self.resultArrat)
        }.store(in: &cell.cancellables)
        
        cell.sumSubject.sink { _ in
            if self.resultArrat.count < 7 {
                cell.plusSharesCount()
                self.resultArrat.append(model.name.uppercased())
            }
            print(self.resultArrat)
        }.store(in: &cell.cancellables)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 28)
    }
}
