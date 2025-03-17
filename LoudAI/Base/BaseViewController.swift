//
//  BaseViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import Combine
import LoudAIViewModel

public protocol IViewModelableController {
    associatedtype ViewModel

    var viewModel: ViewModel? { get }
}

class BaseViewController: UIViewController {
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(resetProgress), name: Notification.Name("ResetCompleted"), object: nil)
    }

    func setupUI() {

    }

    func setupViewModel() {
        
    }

    @objc func resetProgress() {
        
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showBadAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func addSwipeToBack() {
        let swipeToRight = UISwipeGestureRecognizer(target: self, action: #selector(popAfterSwipeLeft))
        swipeToRight.direction = .right
        self.view.addGestureRecognizer(swipeToRight)
    }

    @objc private func popAfterSwipeLeft() {
        guard let navigationController = self.navigationController else { return }
        BaseRouter.popViewController(in: navigationController)
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        NotificationCenter.default.removeObserver(self)
        #endif
    }
}
