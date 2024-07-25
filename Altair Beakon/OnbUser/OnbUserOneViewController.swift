//
//  OnbUserOneViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 23.07.2024.
//

import UIKit

class OnbUserOneViewController: UIViewController {
    
    var imageView: UIImageView?
    var textTopLabel: UILabel?
    var nextButton: UIButton?
    var tap = 0
    
    var oneView: UIView?
    var twoView: UIView?
    var threeView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        createInterface()
    }
    

    func createInterface() {
        
        imageView = UIImageView(image: .onbUser1)
        imageView!.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        oneView = createViews()
        twoView = createViews()
        threeView = createViews()
        
        view.addSubview(oneView!)
        view.addSubview(twoView!)
        view.addSubview(threeView!)
        
        twoView?.snp.makeConstraints({ make in
            make.height.equalTo(5)
            make.width.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        })
        
        oneView?.snp.makeConstraints({ make in
            make.height.equalTo(5)
            make.width.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(twoView!.snp.left).inset(-10)
        })
        oneView?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        
        threeView?.snp.makeConstraints({ make in
            make.height.equalTo(5)
            make.width.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(twoView!.snp.right).inset(-10)
        })
        
        textTopLabel = UILabel()
        textTopLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        textTopLabel?.textColor = .white
        textTopLabel?.numberOfLines = 2
        textTopLabel?.text = "Manage your personal finances"
        textTopLabel?.textAlignment = .center
        
        view.addSubview(textTopLabel!)
        textTopLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(oneView!.snp.bottom).inset(-15)
        })
        
        nextButton = UIButton(type: .system)
        nextButton?.layer.cornerRadius = 16
        nextButton?.setTitle("Next", for: .normal)
        nextButton?.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton?.setTitleColor(.white, for: .normal)
        nextButton?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        view.addSubview(nextButton!)
        nextButton?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        nextButton?.addTarget(self, action: #selector(loadTapped), for: .touchUpInside)
         
    }
    
    
    @objc func loadTapped() {
        tap += 1
        
        switch tap {
        case 1:
            UIView.animate(withDuration: 0.4) { [self] in
                oneView?.backgroundColor = UIColor(red: 237/255, green: 225/255, blue: 253/255, alpha: 1)
                twoView?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
                imageView?.image = .onbUser2
                textTopLabel?.text = "Plan your spending in one app"
            }
        case 2:
            UIView.animate(withDuration: 0.4) { [self] in
                threeView?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
                twoView?.backgroundColor = UIColor(red: 237/255, green: 225/255, blue: 253/255, alpha: 1)
                imageView?.image = .onbUser3
                textTopLabel?.text = "Accurately plan your budget and control"
            }
        case 3:
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        default:
            return
        }
        
    }


   
    
    
    
    func createViews() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 237/255, green: 225/255, blue: 253/255, alpha: 1)
        view.layer.cornerRadius = 2.5
        return view
    }
    
    
    
    
}






extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
