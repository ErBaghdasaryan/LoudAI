//
//  CreateViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 11.04.25.
//
import UIKit
import LoudAIViewModel
import SnapKit
import StoreKit

class CreateViewController: BaseViewController {

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
extension CreateViewController {
    
    private func makeButtonsAction() {

    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 113, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let leftLabel = UILabel(text: "Create",
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
            CreateRouter.showPaymentViewController(in: navigationController)
//        }
    }
}

extension CreateViewController: IViewModelableController {
    typealias ViewModel = ICreateViewModel
}

//MARK: Preview
import SwiftUI

struct CreateViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let createViewController = CreateViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<CreateViewControllerProvider.ContainerView>) -> CreateViewController {
            return createViewController
        }

        func updateUIViewController(_ uiViewController: CreateViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CreateViewControllerProvider.ContainerView>) {
        }
    }
}
