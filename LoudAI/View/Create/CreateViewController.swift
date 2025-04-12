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
import LoudAIModel

class CreateViewController: BaseViewController {

    var viewModel: ViewModel?

    private let titleLabel = UILabel(text: "Music generation...",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 24))
    private let subTitleLabel = UILabel(text: "Generation  usually takes about a 5 minutes",
                                        textColor: .white.withAlphaComponent(0.7),
                                     font: UIFont(name: "SFProText-Regular", size: 16))
    private let image = UIImageView(image: UIImage(named: "generationImage"))
    private let nice = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let model = self.viewModel?.model else { return }

        self.viewModel?.createAdvancedRequest(model: model)
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        self.titleLabel.textAlignment = .center
        self.subTitleLabel.textAlignment = .center

        self.subTitleLabel.numberOfLines = 0
        self.subTitleLabel.lineBreakMode = .byWordWrapping

        nice.setTitle("Nice", for: .normal)
        nice.setTitleColor(UIColor.white, for: .normal)
        nice.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        nice.setImage(UIImage(named: "nice"), for: .normal)
        nice.tintColor = UIColor.white
        nice.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        nice.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 16)
        nice.backgroundColor = UIColor(hex: "#4C19DE")
        nice.layer.masksToBounds = true
        nice.layer.cornerRadius = 16

        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(image)
        self.view.addSubview(nice)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()

        self.viewModel?.createAdvancedSuccessSubject.sink { success in
            if success {
                guard let model = self.viewModel?.advancedResponse else { return }

                DispatchQueue.main.async {
                    self.showSuccessAlert(message: "You have successfully passed the generation stage, and access to the recording will be available in the History section within the next five minutes.")
                }

                self.viewModel?.startPollingForGeneratedTrack(by: model.id)

            } else {
                DispatchQueue.main.async {
                    self.showBadAlert(message: "Write the text that you want to generate, without which it is impossible to continue.")
                }
            }
        }.store(in: &cancellables)

        self.viewModel?.getMusicSuccessSubject.sink { model in

            guard let secondModel = self.viewModel?.model else { return }

            let totalSeconds = secondModel.duration
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            let durationToSend = String(format: "%02d:%02d", minutes, seconds)

            let model = SavedMusicModel(genre: secondModel.genre,
                                        subGenre: secondModel.genreBlend,
                                        duration: durationToSend,
                                        musics: model.items)

            self.viewModel?.addMusic(model)
            DispatchQueue.main.async {
                self.showSuccessAlert(message: "Your music is ready, you can see it in the History section..")
            }

            guard let navigationController = self.navigationController else { return }
            CreateRouter.popViewController(in: navigationController)

        }.store(in: &cancellables)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(223)
            view.leading.equalToSuperview().offset(43)
            view.trailing.equalToSuperview().inset(43)
            view.height.equalTo(26)
        }

        subTitleLabel.snp.makeConstraints { view in
            view.top.equalTo(titleLabel.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(43)
            view.trailing.equalToSuperview().inset(43)
            view.height.equalTo(40)
        }

        image.snp.makeConstraints { view in
            view.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(71)
            view.trailing.equalToSuperview().inset(71)
            view.bottom.equalToSuperview().inset(274)
        }

        nice.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(43)
            view.trailing.equalToSuperview().inset(43)
            view.height.equalTo(40)
        }

    }

}

//MARK: Make buttons actions
extension CreateViewController {
    
    private func makeButtonsAction() {
        nice.addTarget(self, action: #selector(niceTapped), for: .touchUpInside)
    }

    @objc func niceTapped() {
        guard let navigationController = self.navigationController else { return }
        CreateRouter.popViewController(in: navigationController)
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
