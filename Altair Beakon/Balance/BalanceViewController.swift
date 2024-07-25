//
//  BalanceViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 23.07.2024.
//




import UIKit

var valueArr: [(UIImage, String, String, String)] = [(UIImage.usd, "USD", "US dollar", "$"), (UIImage.eur, "EUR", "Euro", "€") , (UIImage.jpy, "JPY" , "Japanese yen" , "¥") , (UIImage.chf, "CHF" , "Swiss franc" , "₣") , (UIImage.try, "TRY" , "Turkish lira" , "₺") , (UIImage.kzt , "KZT" , "Kazakhstani tenge", "₸") , (UIImage.gbp, "GBP" , "Pound sterling" , "£"), (UIImage.thb, "THB" , "Thai baht" , "฿")]

var balanceArr = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]

protocol BalanceViewControllerDelegate: AnyObject {
    func reloadData(index: Int)
}

class BalanceViewController: UIViewController {
    
    var selectedValueArr = 0
    var valueImageView: UIImageView?
    var nameLabel: UILabel?
    var balanceLabelCount: UILabel?
    
    
    var editBalanceView: UIView?
    var editBalanceTextField: UITextField?
    var editBalanceImageView: UIImageView?
    var labelValEditBalance: UILabel?
    var saveEditBalanceButton: UIButton?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsInterface()
        view.backgroundColor = .white
        loadValute()
    }
    
    
    func loadValute() {
        if let value: Int = UserDefaults.standard.integer(forKey: "valute") as? Int{
            selectedValueArr = value
            reloadData(index: value)
        }
        if let balance: [Double] = UserDefaults.standard.array(forKey: "balanceArr") as? [Double] {
            balanceArr = balance
            loadBalance()
        }
    }
    
    func loadBalance() {
        balanceLabelCount?.text = "\(valueArr[selectedValueArr].3)\(balanceArr[selectedValueArr])"
    }
    

    func settingsInterface() {
        
        
        let imageView = UIImageView()
        imageView.image = .BG
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let balanceLabel = UILabel()
        balanceLabel.text = "Balance"
        balanceLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        balanceLabel.textColor = .black
        view.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        let usdView = UIView()
        usdView.layer.cornerRadius  = 8
        usdView.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
        view.addSubview(usdView)
        usdView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(102)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(balanceLabel.snp.centerY)
        }
        
        
        valueImageView = {
            let imageView = UIImageView()
            imageView.image = valueArr[selectedValueArr].0
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            return imageView
        }()
        usdView.addSubview(valueImageView!)
        valueImageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(16)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        })
        
        nameLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .white
            label.text = valueArr[selectedValueArr].1
            return label
        }()
        usdView.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.left.equalTo(valueImageView!.snp.right).inset(-5)
        })
        
        let arrowDownImageView: UIImageView = {
            let imageView = UIImageView(image: .arrowDown.resize(targetSize: CGSize(width: 20, height: 20)))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()
        usdView.addSubview(arrowDownImageView)
        arrowDownImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        let valuteChangeGesture = UITapGestureRecognizer(target: self, action: #selector(changeValue))
        usdView.addGestureRecognizer(valuteChangeGesture)
        
      
        balanceLabelCount = UILabel()
        balanceLabelCount?.text = "\(valueArr[selectedValueArr].3)0.00"
        balanceLabelCount?.textColor = .black
        balanceLabelCount?.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(balanceLabelCount!)
        balanceLabelCount?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(balanceLabel.snp.bottom).inset(-5)
        })
        
        
        let editButton = UIButton(type: .system)
        editButton.setImage(.pencil.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal)
        editButton.backgroundColor = .clear
        editButton.tintColor = .black
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(balanceLabelCount!)
        }
        editButton.addTarget(self, action: #selector(openEditBalance), for: .touchUpInside)
        
        editBalanceView = {
            let view = UIView()
            view.alpha = 0
            view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            
            let balanceLabel = UILabel()
            balanceLabel.text = "Balance"
            balanceLabel.font = .systemFont(ofSize: 22, weight: .semibold)
            balanceLabel.textColor = .black
            view.addSubview(balanceLabel)
            balanceLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(32)
            }
            
            editBalanceTextField = UITextField()
            editBalanceTextField?.placeholder = "Balance"
            editBalanceTextField?.backgroundColor = .white
            editBalanceTextField?.delegate = self
            editBalanceTextField?.borderStyle = .none
            editBalanceTextField?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            editBalanceTextField?.leftViewMode = .always
            editBalanceTextField?.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            editBalanceTextField?.rightViewMode = .always
            editBalanceTextField?.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
            editBalanceTextField?.layer.borderWidth = 1
            editBalanceTextField?.layer.cornerRadius = 16
            editBalanceTextField?.keyboardType = .decimalPad
            view.addSubview(editBalanceTextField!)
            editBalanceTextField?.snp.makeConstraints({ make in
                make.height.equalTo(54)
                make.left.right.equalToSuperview().inset(20)
                make.top.equalTo(balanceLabel.snp.bottom).inset(-23)
            })
            
            editBalanceImageView = UIImageView()
            editBalanceImageView?.clipsToBounds = true
            editBalanceImageView?.contentMode = .scaleAspectFit
            editBalanceImageView?.image = valueArr[selectedValueArr].0
            editBalanceImageView?.backgroundColor = .clear
            view.addSubview(editBalanceImageView!)
            editBalanceImageView?.snp.makeConstraints({ make in
                make.height.width.equalTo(16)
                make.left.equalToSuperview().inset(30)
                make.top.equalTo(editBalanceTextField!.snp.bottom).inset(-15)
            })
            
            labelValEditBalance = UILabel()
            labelValEditBalance?.text = "USD"
            labelValEditBalance?.font = .systemFont(ofSize: 16, weight: .semibold)
            labelValEditBalance?.textColor = .black
            view.addSubview(labelValEditBalance!)
            labelValEditBalance?.snp.makeConstraints({ make in
                make.centerY.equalTo(editBalanceImageView!)
                make.left.equalTo(editBalanceImageView!.snp.right).inset(-5)
            })
            
            let cancelButton = UIButton(type: .system)
            cancelButton.backgroundColor = .clear
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1), for: .normal)
            cancelButton.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.cornerRadius = 16
            cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            view.addSubview(cancelButton)
            cancelButton.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.left.equalToSuperview().inset(20)
                make.right.equalTo(view.snp.centerX).offset(-7.5)
                make.top.equalTo(labelValEditBalance!.snp.bottom).inset(-15)
            }
            cancelButton.addTarget(self, action: #selector(hideEditBalance), for: .touchUpInside)
            
            saveEditBalanceButton = UIButton(type: .system)
            saveEditBalanceButton?.setTitle("Add", for: .normal)
            saveEditBalanceButton?.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            saveEditBalanceButton?.setTitleColor(.white, for: .normal)
            saveEditBalanceButton?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            saveEditBalanceButton?.layer.cornerRadius = 16
            view.addSubview(saveEditBalanceButton!)
            saveEditBalanceButton?.snp.makeConstraints({ make in
                make.height.equalTo(54)
                make.left.equalTo(view.snp.centerX).offset(7.5)
                make.right.equalToSuperview().inset(20)
                make.top.equalTo(labelValEditBalance!.snp.bottom).inset(-15)
            })
            saveEditBalanceButton?.isEnabled = false
            saveEditBalanceButton?.alpha = 0.5
            saveEditBalanceButton?.addTarget(self, action: #selector(saveBalance), for: .touchUpInside)
            
            
            return view
        }()
        view.addSubview(editBalanceView!)
        editBalanceView?.snp.makeConstraints({ make in
            make.height.equalTo(264)
            make.left.right.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        })
        
        let gestureHideKey = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureHideKey)
        
        
        
    }
    
    
    
    @objc func saveBalance() {
        let textInput = editBalanceTextField?.text?.replacingOccurrences(of: ",", with: ".") ?? "0.0"
        let text = Double(textInput) ?? 0.0
        balanceArr[selectedValueArr] = text
        UserDefaults.standard.setValue(balanceArr, forKey: "balanceArr")
        balanceLabelCount?.text = "\(valueArr[selectedValueArr].3)\(String(describing: text))"
        hideEditBalance()
    }

    
    @objc func openEditBalance() {
        if balanceLabelCount?.text != "\(valueArr[selectedValueArr].3)0.0" , balanceLabelCount?.text != "\(valueArr[selectedValueArr].3)0.00"  {
            editBalanceTextField?.text = "\(balanceArr[selectedValueArr])"
        } else {
            editBalanceTextField?.text = ""
        }
        UIView.animate(withDuration: 0.2) {
            self.editBalanceView?.alpha = 1
        }
    }
    
    @objc func hideEditBalance() {
        UIView.animate(withDuration: 0.2) {
            self.editBalanceView?.alpha = 0
        }
        editBalanceTextField?.text = ""
    }
    
    func checkSaveEditBalance() {
        if editBalanceTextField?.text?.count ?? 0 > 0 {
            UIView.animate(withDuration: 0.2) { [self] in
                saveEditBalanceButton?.isEnabled = true
                saveEditBalanceButton?.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2) { [self] in
                saveEditBalanceButton?.isEnabled = false
                saveEditBalanceButton?.alpha = 0.5
            }
        }
    }
    
    @objc func hideKeyboard() {
        checkSaveEditBalance()
        view.endEditing(true)
    }
    
    @objc func changeValue() {
        let vc = ValuteViewController()
        vc.delegate = self
        vc.index = selectedValueArr
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension BalanceViewController: BalanceViewControllerDelegate {
    func reloadData(index: Int) {
        selectedValueArr = index
        valueImageView?.image = valueArr[selectedValueArr].0
        nameLabel?.text = valueArr[selectedValueArr].1
        labelValEditBalance?.text = valueArr[selectedValueArr].1
        editBalanceImageView?.image = valueArr[selectedValueArr].0
        loadBalance()
        
    }
}


extension BalanceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkSaveEditBalance()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkSaveEditBalance()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveEditBalance()
        return true
    }
}
