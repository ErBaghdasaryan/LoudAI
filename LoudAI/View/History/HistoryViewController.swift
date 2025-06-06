//
//  HistoryViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIViewModel
import SnapKit
import StoreKit
import LoudAIModel
import ApphudSDK

class HistoryViewController: BaseViewController {

    var viewModel: ViewModel?
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadMusics()
        self.collectionView.reloadData()

        self.setupNavigationItems()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 122)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(MusicCollectionViewCell.self)
        collectionView.register(EmptyCollectionViewCelll.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.insetsLayoutMarginsFromSafeArea = false

        self.view.addSubview(collectionView)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(125)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }
    }

}

//MARK: Make buttons actions
extension HistoryViewController {

    private func makeButtonsAction() {

    }

    private func showEditMusicViewController(with model: SavedMusicModel) {
        guard let navigationController = self.navigationController else { return }

        HistoryRouter.showEditViewController(in: navigationController,
                                             navigationModel: .init(model: model))
    }

    private func setPageToGenerate() {
        NotificationCenter.default.post(name: Notification.Name("SetPageToGenerate"), object: nil, userInfo: nil)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 113, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let leftLabel = UILabel(text: "History",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Bold", size: 24))
        button.frame = CGRect(x: 0, y: 0, width: 110, height: 32)

        let proButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: leftLabel)

        navigationItem.leftBarButtonItem = leftButton

        if !Apphud.hasActiveSubscription() {
            navigationItem.rightBarButtonItem = proButton
        }
    }
    
    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }
        
        //        if Apphud.hasActiveSubscription() {
        //            SettingsRouter.showUpdatePaymentViewController(in: navigationController)
        //        } else {
        HistoryRouter.showPaymentViewController(in: navigationController)
        //        }
    }

    private func deleteMusic(for index: Int) {
        self.viewModel?.deleteMusic(at: index)
        self.viewModel?.loadMusics()
        self.collectionView.reloadData()
    }
}

extension HistoryViewController: IViewModelableController {
    typealias ViewModel = IHistoryViewModel
}

//MARK: Collection view delegate
extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.savedMusics.isEmpty ?? true ? 1 : self.viewModel!.savedMusics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.viewModel?.savedMusics.isEmpty ?? true {

            let cell: EmptyCollectionViewCelll = collectionView.dequeueReusableCell(for: indexPath)

            cell.addSubject.sink { [weak self] _ in
                self?.setPageToGenerate()
            }.store(in: &cell.cancellables)

            return cell
        } else {
            let cell: MusicCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let model = self.viewModel?.savedMusics[indexPath.row] {
                cell.configure(firstImage: model.genre,
                               secondImage: model.subGenre,
                               title: "\(model.genre) + \(model.subGenre)",
                               data: [model.genre, model.subGenre, model.duration])
            }

            cell.deleteTapped.sink { [weak self] _ in
                if let model = self?.viewModel?.savedMusics[indexPath.row] {
                    self?.deleteMusic(for: model.id!)
                }
            }.store(in: &cell.cancellables)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.viewModel?.savedMusics[indexPath.row] {
            self.showEditMusicViewController(with: model)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel?.savedMusics.isEmpty ?? true {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 343, height: 122)
        }
    }
}

//MARK: Preview
import SwiftUI

struct HistoryViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let historyViewController = HistoryViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) -> HistoryViewController {
            return historyViewController
        }
        
        func updateUIViewController(_ uiViewController: HistoryViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) {
        }
    }
}
