//
//  GeneratorViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIViewModel
import SnapKit
import StoreKit

class GeneratorViewController: BaseViewController {

    var viewModel: ViewModel?
    private let segmentControl = UISegmentedControl(items: ["Generator",
                                                    "Text to Music"])
    private let promtView = CustomTextView(placeholder: "Epic score that feels like the beginning of an epic saga.")
    private let add = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)
        segmentControl.selectedSegmentTintColor = UIColor(hex: "#4C19DE")
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.7)], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        self.promtView.isHidden = true
        self.add.isHidden = true

        add.setTitle("Generate", for: .normal)
        add.setTitleColor(UIColor.white, for: .normal)
        add.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        add.setImage(UIImage(named: "addSong"), for: .normal)
        add.tintColor = UIColor.white
        add.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        add.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 16)
        add.backgroundColor = UIColor(hex: "#4C19DE")
        add.layer.masksToBounds = true
        add.layer.cornerRadius = 16

        self.view.addSubview(segmentControl)
        self.view.addSubview(promtView)
        self.view.addSubview(add)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        segmentControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(120)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(42)
        }

        promtView.snp.makeConstraints { view in
            view.top.equalTo(segmentControl.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview().inset(490)
        }

        add.snp.makeConstraints { view in
            view.top.equalTo(promtView.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }
    }

}

//MARK: Make buttons actions
extension GeneratorViewController {
    
    private func makeButtonsAction() {
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Segment1")
        case 1:
            self.promtView.isHidden = false
            self.add.isHidden = false
        default:
            break
        }
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 113, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let leftLabel = UILabel(text: "Generate",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Bold", size: 24))
        button.frame = CGRect(x: 0, y: 0, width: 110, height: 32)

        let proButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: leftLabel)

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = proButton
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

//        if Apphud.hasActiveSubscription() {
//            SettingsRouter.showUpdatePaymentViewController(in: navigationController)
//        } else {
            SettingsRouter.showPaymentViewController(in: navigationController)
//        }
    }
}

extension GeneratorViewController: IViewModelableController {
    typealias ViewModel = IGeneratorViewModel
}

//MARK: Preview
import SwiftUI

struct GeneratorViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let generatorViewController = GeneratorViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<GeneratorViewControllerProvider.ContainerView>) -> GeneratorViewController {
            return generatorViewController
        }

        func updateUIViewController(_ uiViewController: GeneratorViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<GeneratorViewControllerProvider.ContainerView>) {
        }
    }
}
