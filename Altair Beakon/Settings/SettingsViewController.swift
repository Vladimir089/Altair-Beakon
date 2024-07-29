//
//  SettingsViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 29.07.2024.
//

import UIKit
import StoreKit
import WebKit

class SettingsViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
        view.backgroundColor = .white
    }
    

    func settings() {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        let shareButton = createButton(title: "Share app", image: .share)
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(label.snp.bottom).inset(-30)
        }
        shareButton.addTarget(self, action: #selector(shareApps), for: .touchUpInside)
        
        
        let rateButton = createButton(title: "Rate Us", image: .rate)
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(shareButton.snp.bottom).inset(-15)
        }
        rateButton.addTarget(self, action: #selector(rateApps), for: .touchUpInside)
        
        let policyButton = createButton(title: "Usage Policy", image: .policy)
        view.addSubview(policyButton)
        policyButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rateButton.snp.bottom).inset(-15)
        }
        policyButton.addTarget(self, action: #selector(policy), for: .touchUpInside)
        
    }
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "google.com"
        present(webVC, animated: true, completion: nil)
    }
    
    @objc func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "ссылка на приложение") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    @objc func shareApps() {
        let appURL = URL(string: "ссылка на приложение")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func createButton(title: String, image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.centerY).offset(2)
        }
        
        
        let image = image.resize(targetSize: CGSize(width: 18, height: 18))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.centerY).offset(-2)
        }
        
        
        
        return button
    }

}



class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
