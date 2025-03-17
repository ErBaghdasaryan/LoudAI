//
//  PaymentButton.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import LoudAIModel

final class PaymentButton: UIButton {
    private let title = UILabel(text: "",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Bold", size: 24))
    private let tokensCount = UILabel(text: "",
                                      textColor: UIColor.white,
                                      font: UIFont(name: "SFProText-Regular", size: 14))
    private let saveLabel = UILabel(text: "Save 50%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 12))
    private let perWeek = UILabel(text: "",
                                  textColor: .white,
                                  font: UIFont(name: "SFProText-Semibold", size: 18))
    var isSelectedState: Bool {
        didSet {
            self.updateBorder()
        }
    }
    private var isAnnual: PlanPresentationModel
    private let borderLayer = CAShapeLayer()

    public init(isAnnual: PlanPresentationModel, isSelectedState: Bool = false) {
        self.isAnnual = isAnnual
        self.isSelectedState = isSelectedState
        super.init(frame: .zero)
        setupUI(isAnnual: isAnnual)
        self.setupBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }

    private func setupUI(isAnnual: PlanPresentationModel) {

        self.backgroundColor = UIColor.gray.withAlphaComponent(0.07)

        self.layer.cornerRadius = 20

        self.title.textAlignment = .left
        self.perWeek.textAlignment = .right

        self.saveLabel.layer.masksToBounds = true
        self.saveLabel.layer.cornerRadius = 12
        self.saveLabel.backgroundColor = UIColor(hex: "#FF4E4E")

        self.saveLabel.layer.zPosition = 1

        switch self.isAnnual {
        case .yearly:
            self.title.text = "Yearly"
            self.tokensCount.text = "( 1200 tokens )"
            self.perWeek.text = "6 300 ₽ "
            self.addSubview(saveLabel)
        case .weekly:
            self.title.text = "1 Weekly"
            self.tokensCount.text = "( 100 tokens )"
            self.perWeek.text = "1 300 ₽ "
            break
        }

        self.isSelectedState = false

        addSubview(title)
        addSubview(perWeek)
        addSubview(tokensCount)
        setupConstraints()
    }

    private func setupConstraints() {

        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.height.equalTo(26)
        }

        perWeek.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(18)
        }

        tokensCount.snp.makeConstraints { view in
            view.top.equalTo(title.snp.bottom).offset(4)
            view.leading.equalToSuperview().offset(12)
            view.height.equalTo(14)
        }

        switch self.isAnnual {
        case .yearly:
            saveLabel.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(-10)
                view.trailing.equalToSuperview().inset(11.5)
                view.height.equalTo(22)
                view.width.equalTo(70)
            }
        default:
            break
        }
    }

    public func setup(with isYearly: String) {
        self.title.text = isYearly
    }

    private func setupBorder() {
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
        updateBorder()
    }

    private func updateBorder() {
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        borderLayer.strokeColor = (isSelectedState ? UIColor(hex: "#4C19DE")?.cgColor : UIColor(hex: "#353746")?.cgColor)
        self.backgroundColor = isSelectedState ? UIColor(hex: "#080808") : UIColor.gray.withAlphaComponent(0.07)
    }

    func toggleSelection() {
        isSelectedState.toggle()
    }
}

enum PlanPresentationModel {
    case yearly
    case weekly
}
