//
//  PrivacyViewController.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import UIKit
import WebKit
import SnapKit

final class PrivacyViewController: BaseViewController {

    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        view.backgroundColor = .white
        self.title = "Privacy Policy"
        self.navigationController?.navigationBar.tintColor = .black
        self.webView.backgroundColor = .clear
        if let url = URL(string: "https://docs.google.com/document/d/1ig0Hw9Aysead0QeZWrJCsmCw5tneJ2SWYHaCI8HXJf8/edit?usp=sharing") {
            webView.load(URLRequest(url: url))
        }

        setupConstraints()
    }

    private func setupConstraints() {
        self.view.addSubview(webView)

        webView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
        }
    }

    override func setupViewModel() {

    }

}

import SwiftUI

struct PrivacyViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let privacyViewController = PrivacyViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PrivacyViewControllerProvider.ContainerView>) -> PrivacyViewController {
            return privacyViewController
        }

        func updateUIViewController(_ uiViewController: PrivacyViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PrivacyViewControllerProvider.ContainerView>) {
        }
    }
}
