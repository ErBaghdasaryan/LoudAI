//
//  NotificationViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import LoudAIViewModel
import SnapKit
//import ApphudSDK

class NotificationViewController: BaseViewController {

    var viewModel: ViewModel?

    private let background = UIImageView(image: UIImage(named: "onboarding5"))
    private let bottomView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.6
        view.isUserInteractionEnabled = false
        return view
    }()
    private let afterBottom = UIView()
    private let header = UILabel(text: "Enable Motifications",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 24))
    private let subheader = UILabel(text: "So as not to miss important changes.",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 16))
    private let nextButton = UIButton(type: .system)
    private let maybeLater = UIButton(type: .system)
    private let terms = UIButton(type: .system)
    private let privacy = UIButton(type: .system)
    private let restore = UIButton(type: .system)
    private var buttonsStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.nextButton.setTitle("Continue", for: .normal)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.layer.cornerRadius = 20
        self.nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 20)
        self.nextButton.backgroundColor = UIColor(hex: "#4C19DE")

        self.bottomView.layer.masksToBounds = true
        self.bottomView.layer.cornerRadius = 16
        self.afterBottom.layer.masksToBounds = true
        self.afterBottom.layer.cornerRadius = 16
        self.afterBottom.backgroundColor = .black.withAlphaComponent(0.4)

        self.background.frame = self.view.bounds

        self.subheader.numberOfLines = 2
        self.subheader.lineBreakMode = .byWordWrapping

        self.privacy.setTitle("Privacy Policy", for: .normal)
        self.privacy.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        self.privacy.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.terms.setTitle("Terms of Use", for: .normal)
        self.terms.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        self.terms.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.restore.setTitle("Restore Purchases", for: .normal)
        self.restore.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        self.restore.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.buttonsStack = UIStackView(arrangedSubviews: [terms,
                                                           restore,
                                                           privacy],
                                        axis: .horizontal,
                                        spacing: 0)
        self.buttonsStack.distribution = .fillEqually

        maybeLater.setTitle("Maybe later", for: .normal)
        maybeLater.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        maybeLater.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)
        maybeLater.setImage(UIImage(named: "maybeLater"), for: .normal)
        maybeLater.tintColor = UIColor(hex: "#8D929B")
        maybeLater.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
        maybeLater.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 16)

        self.view.addSubview(background)
        self.view.addSubview(bottomView)
        self.view.addSubview(afterBottom)
        self.view.addSubview(header)
        self.view.addSubview(subheader)
        self.view.addSubview(nextButton)
        self.view.addSubview(maybeLater)
        self.view.addSubview(buttonsStack)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(276)
        }

        afterBottom.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(276)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(16)
            view.leading.equalToSuperview().offset(70)
            view.trailing.equalToSuperview().inset(70)
            view.height.equalTo(26)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(73)
            view.trailing.equalToSuperview().inset(73)
            view.height.equalTo(40)
        }

        nextButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(112)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(56)
        }

        maybeLater.snp.makeConstraints { view in
            view.top.equalTo(nextButton.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(32)
        }

        buttonsStack.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(42)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(14)
        }
    }

}

//MARK: Make buttons actions
extension NotificationViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTaped), for: .touchUpInside)
        maybeLater.addTarget(self, action: #selector(maybeLaterTaped), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        restore.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
    }

    @objc func restoreTapped() {
        guard let navigationController = self.navigationController else { return }
        self.restorePurchase { result in
            if result {
                self.showSuccessAlert(message: "You have successfully restored your purchases.")
            } else {
                self.showBadAlert(message: "Your purchase could not be restored. Please try again later.")
            }
        }
    }

    @MainActor
    public func restorePurchase(escaping: @escaping(Bool) -> Void) {
//        Apphud.restorePurchases { subscriptions, _, error in
//            if let error = error {
//                print(error.localizedDescription)
//                escaping(false)
//            }
//            if subscriptions?.first?.isActive() ?? false {
//                escaping(true)
//            }
//            if Apphud.hasActiveSubscription() {
//                escaping(true)
//            }
//        }
    }

    @objc func termsTapped() {
        guard let navigationController = self.navigationController else { return }

        NotificationRouter.showTermsViewController(in: navigationController)
    }

    @objc func privacyTapped() {
        guard let navigationController = self.navigationController else { return }

        NotificationRouter.showPrivacyViewController(in: navigationController)
    }

    @objc func maybeLaterTaped() {
        guard let navigationController = self.navigationController else { return }

        NotificationRouter.showPaymentViewController(in: navigationController)
        self.viewModel?.isEnabled = true
    }

    @objc func nextButtonTaped() {
        guard let navigationController = self.navigationController else { return }

        NotificationRouter.showPaymentViewController(in: navigationController)
        self.viewModel?.isEnabled = true
    }
}

extension NotificationViewController: IViewModelableController {
    typealias ViewModel = INotificationViewModel
}


//MARK: Preview
import SwiftUI

struct NotificationViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let notificationViewController = NotificationViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<NotificationViewControllerProvider.ContainerView>) -> NotificationViewController {
            return notificationViewController
        }

        func updateUIViewController(_ uiViewController: NotificationViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<NotificationViewControllerProvider.ContainerView>) {
        }
    }
}
