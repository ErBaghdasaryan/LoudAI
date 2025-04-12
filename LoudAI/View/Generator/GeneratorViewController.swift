//
//  GeneratorViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIViewModel
import LoudAIModel
import SnapKit
import StoreKit

class GeneratorViewController: BaseViewController {

    var viewModel: ViewModel?
    private let segmentControl = UISegmentedControl(items: ["Generator",
                                                    "Text to Music"])
    private let promtView = TextViewWithCounter(placeholder: "Epic score that feels like the beginning of an epic saga.")
    private let generate = UIButton(type: .system)
    private let add = UIButton(type: .system)
    var collectionView: UICollectionView!
    private var selectedCells: [CellType] = []
    private let allCells: [CellType] = [.genre, .subGenre, .duration, .instruments, .genreBlends, .energy, .structure, .tempo, .key, .add]
    private var isFirstTime: Bool = true

    private var currentSubgenreIndex: Int = 1

    private var currentGenre: String?
    private var currentSubGenre: String?
    private var currentDuration: Int?
    private var currentInstruments: [String]?
    private var currentGenreBlend: String?
    private var currentEnergy: String?
    private var currentStructureID: Int?
    private var currentBPM: Int?
    private var currentKeyRoot: String?
    private var currentKeyQuality: String?

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

        generate.setTitle("Generate", for: .normal)
        generate.setTitleColor(UIColor.white, for: .normal)
        generate.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        generate.setImage(UIImage(named: "addSong"), for: .normal)
        generate.tintColor = UIColor.white
        generate.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        generate.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 16)
        generate.backgroundColor = UIColor(hex: "#4C19DE")
        generate.layer.masksToBounds = true
        generate.layer.cornerRadius = 16

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(GenreCell.self)
        collectionView.register(SubGenreCell.self)
        collectionView.register(DurationCell.self)
        collectionView.register(InstrumentsCell.self)
        collectionView.register(GenreBlendsCell.self)
        collectionView.register(EnergyCell.self)
        collectionView.register(StructureCell.self)
        collectionView.register(TempoCell.self)
        collectionView.register(KeyCell.self)
        collectionView.register(AddCell.self)

        self.segmentControl.selectedSegmentIndex = 0

        self.view.addSubview(segmentControl)
        self.view.addSubview(collectionView)
        self.view.addSubview(generate)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()

        self.viewModel?.loadGenres()

        self.viewModel?.createByPromptSuccessSubject.sink { success in
            if success {
                guard let model = self.viewModel?.byPromptResponse else { return }

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
            
            let model = SavedMusicModel(genre: "Prompt",
                                        subGenre: "Generation",
                                        duration: "automatically defined duration",
                                        musics: model.items)

            self.viewModel?.addMusic(model)
            DispatchQueue.main.async {
                self.showSuccessAlert(message: "Your music is ready, you can see it in the History section..")
            }
        }.store(in: &cancellables)
    }

    func setupConstraints() {

        segmentControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(120)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(42)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(segmentControl.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview().inset(149)
        }

        generate.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(97)
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
        self.add.addTarget(self, action: #selector(byPromptTapped), for: .touchUpInside)
        self.generate.addTarget(self, action: #selector(generateAdvancedMusic), for: .touchUpInside)
    }

    @objc func generateAdvancedMusic() {
        guard let navigationController = self.navigationController else { return }

        guard let genre = self.currentGenre else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let subGenre = self.currentSubGenre else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let duration = self.currentDuration else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let instruments = self.currentInstruments else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let genryBlends = self.currentGenreBlend else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let energy = self.currentEnergy else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let structureID = self.currentStructureID else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let tempo = self.currentBPM else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let keyRoot = self.currentKeyRoot else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let keyQuality = self.currentKeyQuality else {
            self.showBadAlert(message: "Please check all the fields again and fill in all of them so that we can perform the generation.")
            return
        }

        guard let userID = self.viewModel?.userID else {
            return
        }

        let bundle = Bundle.main.bundleIdentifier ?? ""

        let model = AdvancedSendModel(userID: userID,
                                      appBundle: bundle,
                                      genre: genre,
                                      subGenre: subGenre,
                                      duration: duration,
                                      instruments: instruments,
                                      genreBlend: genryBlends,
                                      energy: energy,
                                      structureID: structureID,
                                      bpm: tempo,
                                      keyRoot: keyRoot,
                                      keyQuality: keyQuality)

        GeneratorRouter.showCreateViewController(in: navigationController,
                                                 navigationModel: model)
    }

    @objc func byPromptTapped() {
        guard !self.promtView.getText().isEmpty else {
            self.showBadAlert(message: "Write the text that you want to generate, without which it is impossible to continue.")
            return
        }
        let prompt = self.promtView.getText()

        guard let userID = self.viewModel?.userID else {
            return
        }

        let bundle = Bundle.main.bundleIdentifier ?? ""

        self.viewModel?.createByPromptRequest(userId: userID,
                                              bundle: bundle,
                                              prompt: prompt)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.isPromtMode(false)
        case 1:
            self.isPromtMode(true)
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
            GeneratorRouter.showPaymentViewController(in: navigationController)
//        }
    }

    private func isPromtMode(_ bool: Bool) {
        if bool {
            self.collectionView.removeFromSuperview()
            self.generate.removeFromSuperview()
            self.view.addSubview(promtView)
            self.view.addSubview(add)

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

            self.isFirstTime = false
        } else {
            if !isFirstTime {
                self.promtView.removeFromSuperview()
                self.add.removeFromSuperview()
            }
            self.view.addSubview(collectionView)
            self.view.addSubview(generate)

            collectionView.snp.makeConstraints { view in
                view.top.equalTo(segmentControl.snp.bottom).offset(16)
                view.leading.equalToSuperview().offset(16)
                view.trailing.equalToSuperview().inset(16)
                view.bottom.equalToSuperview().inset(149)
            }

            generate.snp.makeConstraints { view in
                view.bottom.equalToSuperview().inset(97)
                view.leading.equalToSuperview().offset(16)
                view.trailing.equalToSuperview().inset(16)
                view.height.equalTo(40)
            }

        }
    }

    private func dequeueCell(for type: CellType, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        switch type {
        case .subGenre:
            let cell: SubGenreCell = collectionView.dequeueReusableCell(for: indexPath)

            if let models = self.viewModel?.genreItems {
                cell.configure(with: models[currentSubgenreIndex].subGenres)
            }

            cell.currentSubGenreSubject.sink { [weak self] subGenre in
                self?.currentSubGenre = subGenre
            }.store(in: &cell.cancellables)

            return cell
        case .duration:
            let cell: DurationCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.valueChanged.sink { [weak self] seconds in
                self?.currentDuration = seconds
            }.store(in: &cell.cancellables)

            return cell
        case .instruments:
            let cell: InstrumentsCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.currentArraySubject.sink { [weak self] array in
                self?.currentInstruments = array
            }.store(in: &cell.cancellables)

            return cell
        case .genreBlends:
            let cell: GenreBlendsCell = collectionView.dequeueReusableCell(for: indexPath)

            if let models = self.viewModel?.genreItems {
                cell.configure(with: models)
            }

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.currentGenreBlendsSubject.sink { [weak self] genreBlends in
                self?.currentGenreBlend = genreBlends.title
            }.store(in: &cell.cancellables)

            return cell
        case .energy:
            let cell: EnergyCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.currentEnergySubject.sink { [weak self] energy in
                self?.currentEnergy = energy
            }.store(in: &cell.cancellables)

            return cell
        case .structure:
            let cell: StructureCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.currentStructureSubject.sink { [weak self] structureIndex in
                self?.currentStructureID = structureIndex
            }.store(in: &cell.cancellables)

            return cell
        case .tempo:
            let cell: TempoCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.valueChanged.sink { [weak self] value in
                self?.currentBPM = value
            }.store(in: &cell.cancellables)

            return cell
        case .key:
            let cell: KeyCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.deleteTapped.sink { [weak self] index in
                self?.removeCell(type)
            }.store(in: &cell.cancellables)

            cell.currentValuesSubject.sink { [weak self] values in
                self?.currentKeyRoot = values.0
                self?.currentKeyQuality = values.1
            }.store(in: &cell.cancellables)

            return cell
        case .genre:
            break
        case .add:
            break
        }
        return UICollectionViewCell()
    }

    private func addCell(from index: Int) {
        let cellToAdd: CellType

        switch index {
        case 0: cellToAdd = .subGenre
        case 1: cellToAdd = .duration
        case 2: cellToAdd = .instruments
        case 3: cellToAdd = .genreBlends
        case 4: cellToAdd = .energy
        case 5: cellToAdd = .structure
        case 6: cellToAdd = .tempo
        case 7: cellToAdd = .key
        default: return
        }

        guard !self.selectedCells.contains(cellToAdd) else { return }

        self.selectedCells.append(cellToAdd)
        self.collectionView.reloadData()
    }

    private func removeCell(_ type: CellType) {
        guard let index = self.selectedCells.firstIndex(of: type) else { return }

        self.selectedCells.remove(at: index)

        let indexPath = IndexPath(item: index + 1, section: 0)

        self.collectionView.performBatchUpdates {
            self.collectionView.deleteItems(at: [indexPath])
        }

        if let addCellIndexPath = IndexPath(item: self.selectedCells.count + 1, section: 0) as IndexPath?,
           let addCell = self.collectionView.cellForItem(at: addCellIndexPath) as? AddCell {
            addCell.updateSelectedCells(self.selectedCells)
        }
    }
}

extension GeneratorViewController: IViewModelableController {
    typealias ViewModel = IGeneratorViewModel
}

extension GeneratorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedCells.count + 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell: GenreCell = collectionView.dequeueReusableCell(for: indexPath)

            if let models = self.viewModel?.genreItems {
                cell.configure(with: models)
            }

            cell.indexSubject.sink { [weak self] index in
                guard let self = self else { return }

                self.currentSubgenreIndex = index
                self.addCell(from: 0)

                self.collectionView.reloadData()

            }.store(in: &cell.cancellables)

            cell.currentGenreSubject.sink { [weak self] genre in
                guard let self = self else { return }

                self.currentGenre = genre.title

            }.store(in: &cell.cancellables)

            return cell
        } else if indexPath.item == selectedCells.count + 1 {
            let cell: AddCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.updateSelectedCells(selectedCells)

            cell.indexSubject.sink { [weak self] index in
                self?.addCell(from: index)
                cell.updateSelectedCells(self?.selectedCells ?? [])
            }.store(in: &cell.cancellables)

            return cell
        } else {
            let cellType = selectedCells[indexPath.item - 1]
            return dequeueCell(for: cellType, indexPath: indexPath, collectionView: collectionView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width

            if indexPath.item == 0 {
                return CGSize(width: width, height: 122)
            } else if indexPath.item == selectedCells.count + 1 {
                return CGSize(width: width, height: 80)
            } else {
                let cellType = selectedCells[indexPath.item - 1]

                switch cellType {
                case .subGenre:
                    return CGSize(width: width, height: 98)
                case .duration:
                    return CGSize(width: width, height: 98)
                case .instruments:
                    return CGSize(width: width, height: 440)
                case .genreBlends:
                    return CGSize(width: width, height: 148)
                case .energy:
                    return CGSize(width: width, height: 85)
                case .structure:
                    return CGSize(width: width, height: 400)
                case .tempo:
                    return CGSize(width: width, height: 110)
                case .key:
                    return CGSize(width: width, height: 180)
                default:
                    return CGSize(width: width, height: 80)
                }
            }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
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

enum CellType: Equatable {
    case genre,
         subGenre,
         duration,
         instruments,
         genreBlends,
         energy,
         structure,
         tempo,
         key,
         add
}
