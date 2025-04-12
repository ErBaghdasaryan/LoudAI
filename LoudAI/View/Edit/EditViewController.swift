//
//  EditViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 13.04.25.
//

import UIKit
import LoudAIViewModel
import SnapKit
import StoreKit
import LoudAIModel

class EditViewController: BaseViewController {

    var viewModel: ViewModel?

    private let cyrcleView = UIView()
    private let firstImage = UIImageView()
    private let secondImage = UIImageView()

    private let titleLabel = UILabel(text: "Key",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 24))

    var collectionView: UICollectionView!
    var collectionViewData: [LoadedMusicModel] = []

    private let share = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let model = self.viewModel?.model else { return }

        self.titleLabel.text = "\(model.model.genre) + \(model.model.subGenre)"
        self.firstImage.image = UIImage(named: model.model.genre)
        self.secondImage.image = UIImage(named: model.model.subGenre)
        self.collectionViewData = model.model.musics

    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        cyrcleView.layer.cornerRadius = 24
        cyrcleView.layer.borderColor = UIColor.white.cgColor
        cyrcleView.layer.borderWidth = 1

        self.firstImage.layer.masksToBounds = true
        self.firstImage.layer.cornerRadius = 12
        self.firstImage.contentMode = .scaleAspectFill

        self.secondImage.layer.masksToBounds = true
        self.secondImage.layer.cornerRadius = 12
        self.secondImage.contentMode = .scaleAspectFill

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 64)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(SongCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.insetsLayoutMarginsFromSafeArea = false

        share.setTitle("Share", for: .normal)
        share.setTitleColor(UIColor.white, for: .normal)
        share.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        share.setImage(UIImage(named: "addSong"), for: .normal)
        share.tintColor = UIColor.white
        share.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        share.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 16)
        share.backgroundColor = UIColor(hex: "#4C19DE")
        share.layer.masksToBounds = true
        share.layer.cornerRadius = 16

        self.view.addSubview(cyrcleView)
        self.view.addSubview(firstImage)
        self.view.addSubview(secondImage)
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(share)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        cyrcleView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(126)
            view.leading.equalToSuperview().offset(91)
            view.trailing.equalToSuperview().inset(91)
            view.height.equalTo(205)
        }

        firstImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(120)
            view.leading.equalToSuperview().offset(79)
            view.trailing.equalTo(cyrcleView.snp.trailing).inset(52)
            view.height.equalTo(164)
        }

        secondImage.snp.makeConstraints { view in
            view.top.equalTo(cyrcleView.snp.top).offset(47)
            view.leading.equalTo(cyrcleView.snp.leading).offset(50)
            view.trailing.equalToSuperview().inset(79)
            view.height.equalTo(164)
        }

        titleLabel.snp.makeConstraints { view in
            view.top.equalTo(secondImage.snp.bottom).offset(20)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(23)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(titleLabel.snp.bottom).offset(36)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview().inset(140)
        }

        share.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(41)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }
    }

}

//MARK: Make buttons actions
extension EditViewController {
    
    private func makeButtonsAction() {
        share.addTarget(self, action: #selector(sharetapped), for: .touchUpInside)
    }

    @objc func sharetapped() {
        let appStoreURL = URL(string: "https://apps.apple.com/us/app/loud-ai-app/id6744518487")!

        let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .openInIBooks,
            .markupAsPDF,
            .mail,
            .airDrop,
            .postToFacebook,
            .postToTwitter,
            .copyToPasteboard
        ]

        present(activityViewController, animated: true, completion: nil)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 113, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "customBack"), for: .normal)
        backbutton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backbutton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: backbutton)

        let title = UILabel(text: "History",
                            textColor: .white,
                            font:  UIFont(name: "SFProText-Bold", size: 24))

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = proButton
        navigationItem.titleView = title
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

//        if Apphud.hasActiveSubscription() {
//            SettingsRouter.showUpdatePaymentViewController(in: navigationController)
//        } else {
            EditRouter.showPaymentViewController(in: navigationController)
//        }
    }

    @objc func backTapped() {
        guard let navigationController = self.navigationController else { return }

        EditRouter.popViewController(in: navigationController)
    }
}

extension EditViewController: IViewModelableController {
    typealias ViewModel = IEditViewModel
}

//MARK: Collection view delegate
extension EditViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SongCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let model = self.collectionViewData[indexPath.row]
        cell.configure(with: model)

        cell.deleteTapped.sink { [weak self, weak cell] in
            guard let self = self,
                      let cell = cell,
                      let indexPath = self.collectionView.indexPath(for: cell) else { return }

                self.collectionViewData.remove(at: indexPath.row)
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [indexPath])
                }, completion: nil)
        }.store(in: &cell.cancellables)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 343, height: 64)
    }
}

//MARK: Preview
import SwiftUI

struct EditViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let editViewController = EditViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<EditViewControllerProvider.ContainerView>) -> EditViewController {
            return editViewController
        }

        func updateUIViewController(_ uiViewController: EditViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<EditViewControllerProvider.ContainerView>) {
        }
    }
}
