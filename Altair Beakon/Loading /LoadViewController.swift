//
//  LoadViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 23.07.2024.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    var progressLabel: UILabel?
    var timer: Timer?
    var progress: Int = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        createInterface()
        startProgress()
    }
    
    
    func createInterface() {
        
        let imageView = UIImageView(image: .logoPNG)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(280)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        
        let indicatorView = UIActivityIndicatorView(style: .medium)
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-15)
            make.top.equalTo(imageView.snp.bottom).inset(-40)
        }
        indicatorView.color = .white
        indicatorView.startAnimating()
        
        
        progressLabel = {
            let label = UILabel()
            label.text = "0%"
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = .white
            return label
        }()
        view.addSubview(progressLabel!)
        progressLabel?.snp.makeConstraints({ make in
            make.left.equalTo(indicatorView.snp.right).inset(-5)
            make.centerY.equalTo(indicatorView)
        })
        
    }
    
    
    
    
    func startProgress() {
        progress = 0
        progressLabel?.text = "\(progress)%"      //ПОРМЕНЯТЬ НА timeInterval: 0.07
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
            if progress < 100 {
                progress += 1
                progressLabel?.text = "\(progress)%"
            } else {
                timer?.invalidate()
                timer = nil
                if isBet == false {
                    if UserDefaults.standard.object(forKey: "tab") != nil {
                        self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                    } else {
                       self.navigationController?.setViewControllers([OnbUserOneViewController()], animated: true)
                    }
                } else {
                    
                }
            }
        }


}
