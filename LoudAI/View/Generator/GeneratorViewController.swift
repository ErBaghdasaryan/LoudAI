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

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

    }

}

//MARK: Make buttons actions
extension GeneratorViewController {
    
    private func makeButtonsAction() {

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
