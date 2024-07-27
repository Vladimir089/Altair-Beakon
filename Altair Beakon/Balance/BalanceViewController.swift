//
//  BalanceViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 23.07.2024.
//




import UIKit
import CoreImage

var valueArr: [(UIImage, String, String, String)] = [(UIImage.usd, "USD", "US dollar", "$"), (UIImage.eur, "EUR", "Euro", "€") , (UIImage.jpy, "JPY" , "Japanese yen" , "¥") , (UIImage.chf, "CHF" , "Swiss franc" , "₣") , (UIImage.try, "TRY" , "Turkish lira" , "₺") , (UIImage.kzt , "KZT" , "Kazakhstani tenge", "₸") , (UIImage.gbp, "GBP" , "Pound sterling" , "£"), (UIImage.thb, "THB" , "Thai baht" , "฿")]


var balanceArr = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00]
var historyArr: [(String, String, String, String)] = []
var sortedHistoryArr: [(String, String, String, String)] = []

protocol BalanceViewControllerDelegate: AnyObject {
    func reloadData(index: Int)
}

class BalanceViewController: UIViewController {
    
    let catArr: [(UIImage, String)] = [(UIImage.oneCat, "Housing") , (UIImage.twoCat, "Food") , (UIImage.threeCat, "Clothes") , (UIImage.fourCat, "Medicine") , (UIImage.fiveCat , "Transport") , (UIImage.sixCat , "Study") , (UIImage.sevenCat , "Loans") , (UIImage.eadgeCat, "Other")]
    
    var butArrow: [UIButton] = []
    
    var selectedValueArr = 0
    var valueImageView: UIImageView?
    var nameLabel: UILabel?
    var balanceLabelCount: UILabel?
    
    
    var editBalanceView: UIView?
    var editBalanceTextField: UITextField?
    var editBalanceImageView: UIImageView?
    var labelValEditBalance: UILabel?
    var saveEditBalanceButton: UIButton?
    
    
    //Диаграмма
    var procentLabel: UILabel?
    var spentLabel: UILabel?
    
    //Коллекции
    var categoryCollection: UICollectionView?
    var selectedCategor: Int?
    
    
    var historyCollection: UITableView?
    var noHistoryView: UIView?
    var newHistoryView: UIView?
    var nameHistoryTextField: UITextField?
    var balanceNewHistoryTextField: UITextField?
    var selectedCategoryCreate: Int?
    var coyntryNewHistoryImageView: UIImageView?
    var coyntryNewHistoryLabel: UILabel?
    var createHistoryButton: UIButton?
    
    var editElement: [(String, String, String, String)] = []
    var isEdit = false
    
    
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
        
        if let savedHistory = UserDefaults.standard.array(forKey: "historyy") as? [[String]] {
            historyArr = savedHistory.map { ($0[0], $0[1], $0[2], $0[3]) }
            sortedHistoryArr = historyArr
            checkHistory()
            updateBalance()
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
       
        
        let gestureHideKey = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        editBalanceView?.addGestureRecognizer(gestureHideKey)
        
        let imageViewDiagram = UIImageView(image: .diagram)
        imageViewDiagram.contentMode = .scaleAspectFit
        view.addSubview(imageViewDiagram)
        imageViewDiagram.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(balanceLabelCount!.snp.bottom).inset(-15)
        }
        
        procentLabel = UILabel()
        procentLabel?.text = "0%"
        procentLabel?.font = .systemFont(ofSize: 11, weight: .regular)
        procentLabel?.textColor = .black
        imageViewDiagram.addSubview(procentLabel!)
        procentLabel!.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let moneySpentLabal = UILabel()
        moneySpentLabal.text = "Money spent"
        moneySpentLabal.font = .systemFont(ofSize: 17, weight: .semibold)
        moneySpentLabal.textColor = .black
        view.addSubview(moneySpentLabal)
        moneySpentLabal.snp.makeConstraints { make in
            make.top.equalTo(imageViewDiagram)
            make.left.equalTo(imageViewDiagram.snp.right).inset(-15)
        }
        
        spentLabel = UILabel()
        spentLabel?.text = "\(valueArr[selectedValueArr].3)0.00"
        spentLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        spentLabel?.textColor = .black
        view.addSubview(spentLabel!)
        spentLabel?.snp.makeConstraints({ make in
            make.left.equalTo(imageViewDiagram.snp.right).inset(-15)
            make.bottom.equalTo(imageViewDiagram.snp.bottom)
        })
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 195/255, green: 167/255, blue: 255/255, alpha: 1)
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(spentLabel!.snp.bottom).inset(-15)
        }
        
        
        categoryCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .horizontal
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cat")
            collection.showsHorizontalScrollIndicator = false
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.isUserInteractionEnabled = true
            layout.minimumLineSpacing = 15
            collection.dataSource = self
            return collection
        }()
        view.addSubview(categoryCollection!)
        categoryCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(69)
            make.top.equalTo(separatorView.snp.bottom).inset(-15)
        })
        
        let historyLabel = UILabel()
        historyLabel.text = "History"
        historyLabel.textColor = .black
        historyLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        view.addSubview(historyLabel)
        historyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(categoryCollection!.snp.bottom).inset(-15)
        }
        
        noHistoryView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            view.alpha = 0
            let label = UILabel()
            label.text = "There are no records"
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = .black
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            return view
        }()
        view.addSubview(noHistoryView!)
        noHistoryView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(86)
            make.top.equalTo(historyLabel.snp.bottom).inset(-15)
        })
        
        
        
        historyCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UITableView(frame: .zero, style: .plain)
            collection.register(UITableViewCell.self, forCellReuseIdentifier: "hist")
            layout.scrollDirection = .vertical
            collection.showsHorizontalScrollIndicator = false
            collection.backgroundColor = .white
            collection.delegate = self
            collection.isUserInteractionEnabled = true
            layout.minimumLineSpacing = 15
            collection.dataSource = self
            collection.layer.cornerRadius = 16
            return collection
        }()
        view.addSubview(historyCollection!)
        historyCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(historyLabel.snp.bottom).inset(-15)
        })
        
        let addHistoryButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(.blackPlus.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal)
            button.tintColor = .black
            return button
        }()
        view.addSubview(addHistoryButton)
        addHistoryButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(historyLabel)
        }
        addHistoryButton.addTarget(self, action: #selector(openNewHistory), for: .touchUpInside)
        
        
        newHistoryView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            view.alpha = 0
            
            let label = UILabel()
            label.text = "Record"
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(30)
            }
            
            nameHistoryTextField = {
                let textField = UITextField()
                textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                textField.leftViewMode = .always
                textField.rightViewMode = .always
                textField.borderStyle = .none
                textField.placeholder = "Name"
                textField.layer.borderWidth = 1
                textField.keyboardType = .decimalPad
                textField.delegate = self
                textField.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
                textField.layer.cornerRadius = 16
                return textField
            }()
            view.addSubview(nameHistoryTextField!)
            nameHistoryTextField?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(54)
                make.top.equalTo(label.snp.bottom).inset(-30)
            })
            
            let stackViewTop = UIStackView()
            stackViewTop.axis = .horizontal
            stackViewTop.distribution = .fillEqually
            view.addSubview(stackViewTop)
            stackViewTop.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.top.equalTo(nameHistoryTextField!.snp.bottom).inset(-10)
                make.height.equalTo(69)
            }
            
            let house = createViews(buttonmage: UIImage.onebut, text: "Housing", tag: 0)
            let food = createViews(buttonmage: UIImage.twobut, text: "Food", tag: 1)
            let clothes = createViews(buttonmage: UIImage.threebut, text: "Clothes", tag: 2)
            let medicine = createViews(buttonmage: UIImage.fourbut, text: "Medicine", tag: 3)
            stackViewTop.addArrangedSubview(house)
            stackViewTop.addArrangedSubview(food)
            stackViewTop.addArrangedSubview(clothes)
            stackViewTop.addArrangedSubview(medicine)
            
            let stackViewBot = UIStackView()
            stackViewBot.axis = .horizontal
            stackViewBot.distribution = .fillEqually
            view.addSubview(stackViewBot)
            stackViewBot.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.top.equalTo(stackViewTop.snp.bottom).inset(-5)
                make.height.equalTo(69)
            }
            
            let transport = createViews(buttonmage: UIImage.fivebut, text: "Transport", tag: 4)
            let study = createViews(buttonmage: UIImage.sixbut, text: "Study", tag: 5)
            let loans = createViews(buttonmage: UIImage.sevenbut, text: "Loans", tag: 6)
            let other = createViews(buttonmage: UIImage.edgebut, text: "Other", tag: 7)
            
            stackViewBot.addArrangedSubview(transport)
            stackViewBot.addArrangedSubview(study)
            stackViewBot.addArrangedSubview(loans)
            stackViewBot.addArrangedSubview(other)
            
            balanceNewHistoryTextField = {
                let textField = UITextField()
                textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                textField.leftViewMode = .always
                textField.rightViewMode = .always
                textField.borderStyle = .none
                textField.placeholder = "Balance"
                textField.layer.borderWidth = 1
                textField.keyboardType = .decimalPad
                textField.delegate = self
                textField.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
                textField.layer.cornerRadius = 16
                return textField
            }()
            view.addSubview(balanceNewHistoryTextField!)
            balanceNewHistoryTextField?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(54)
                make.top.equalTo(stackViewBot.snp.bottom).inset(-10)
            })
            
            coyntryNewHistoryImageView = UIImageView(image: valueArr[selectedValueArr].0)
            coyntryNewHistoryImageView?.contentMode = .scaleAspectFit
            coyntryNewHistoryImageView?.layer.cornerRadius = 8
            coyntryNewHistoryImageView?.clipsToBounds = true
            view.addSubview(coyntryNewHistoryImageView!)
            coyntryNewHistoryImageView?.snp.makeConstraints { make in
                make.height.width.equalTo(16)
                make.top.equalTo(balanceNewHistoryTextField!.snp.bottom).inset(-15)
                make.left.equalTo(balanceNewHistoryTextField!.snp.left).inset(10)
            }
            
            
            coyntryNewHistoryLabel = UILabel()
            coyntryNewHistoryLabel?.text = valueArr[selectedValueArr].1
            coyntryNewHistoryLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            coyntryNewHistoryLabel?.textColor = .black
            view.addSubview(coyntryNewHistoryLabel!)
            coyntryNewHistoryLabel?.snp.makeConstraints { make in
                make.centerY.equalTo(coyntryNewHistoryImageView!)
                make.left.equalTo(coyntryNewHistoryImageView!.snp.right).inset(-10)
            }
            
            
            let button = UIButton(type: .system)
            button.setImage(.arrowDown.resize(targetSize: CGSize(width: 18, height: 18)), for: .normal)
            button.tintColor = .black
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerY.equalTo(coyntryNewHistoryLabel!)
                make.left.equalTo(coyntryNewHistoryLabel!.snp.right).inset(-10)
            }
            button.addTarget(self, action: #selector(changeValue), for: .touchUpInside)
            
            let cancelButton = UIButton(type: .system)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            cancelButton.backgroundColor = .clear
            cancelButton.setTitleColor(UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1), for: .normal)
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
            cancelButton.layer.cornerRadius = 16
            view.addSubview(cancelButton)
            cancelButton.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.left.equalTo(balanceNewHistoryTextField!.snp.left)
                make.bottom.equalToSuperview().inset(20)
                make.right.equalTo(view.snp.centerX).offset(-7.5)
            }
            cancelButton.addTarget(self, action: #selector(hideNewHistory), for: .touchUpInside)
            
            createHistoryButton = UIButton(type: .system)
            createHistoryButton?.setTitle("Add", for: .normal)
            createHistoryButton?.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            createHistoryButton?.setTitleColor(.white, for: .normal)
            createHistoryButton?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            createHistoryButton?.layer.cornerRadius = 16
            createHistoryButton?.isUserInteractionEnabled = false
            createHistoryButton?.alpha = 0.5
            view.addSubview(createHistoryButton!)
            createHistoryButton?.snp.makeConstraints({ make in
                make.height.equalTo(54)
                make.right.equalTo(balanceNewHistoryTextField!.snp.right)
                make.bottom.equalToSuperview().inset(20)
                make.left.equalTo(view.snp.centerX).offset(7.5)
            })
            createHistoryButton?.addTarget(self, action: #selector(saveNewRecord), for: .touchUpInside)
            
            let gestureHideKey = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(gestureHideKey)
            
            
            
            return view
        }()
        view.addSubview(newHistoryView!)
        newHistoryView?.snp.makeConstraints({ make in
            make.height.equalTo(492)
            make.left.right.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        })
        
        
        view.addSubview(editBalanceView!)
        editBalanceView?.snp.makeConstraints({ make in
            make.height.equalTo(264)
            make.left.right.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        })
        
       
        
        
        checkHistory()
    }
    
    func updateBalance() {
        sortedHistoryArr.removeAll()
        
        
        let selectedValute = valueArr[selectedValueArr].1
        let selectedCategory = catArr[selectedCategor ?? 0].1
        
        for i in historyArr {
            if i.1 == selectedCategory , i.3 == selectedValute {
                sortedHistoryArr.append(i)
            }
        }
        checkHistory()
        historyCollection?.reloadData()
        
        var spent = 0
        for i in sortedHistoryArr {
            spent += Int(i.2) ?? 0
        }
        spentLabel?.text = "\(valueArr[selectedValueArr].3)\(spent)"
        if spent != 0 , balanceArr[selectedValueArr] != 0  {
            // Преобразование результата в целое число и форматирование текста
            let percentage = (Double(spent) / Double(balanceArr[selectedValueArr])) * 100
            procentLabel?.text = "\(Int(percentage))%"

        } else {
            procentLabel?.text = "0%"
        }
    }
    
    
    @objc func saveNewRecord() {
        
        let nameText = nameHistoryTextField?.text ?? ""
        let categoryText = catArr[selectedCategoryCreate ?? 0].1
        let balanceText = balanceNewHistoryTextField?.text ?? ""
        let valute = valueArr[selectedValueArr].1
        
        if isEdit == false {
            historyArr.append((nameText, categoryText, balanceText, valute))
            let historyArrayForUserDefaults = historyArr.map { [$0.0, $0.1, $0.2, $0.3] }
            UserDefaults.standard.setValue(historyArrayForUserDefaults, forKey: "historyy")
        } else {

            
            var coun = 0
            for i in historyArr {
                if i == editElement[0] {
                    historyArr[coun] = (nameText, categoryText, balanceText, valute)
                }
                coun += 1
            }
            
        }
        
       
        
        // Конвертируем кортежи в массивы для сохранения в UserDefaults
       
        editElement.removeAll()
        checkHistory()
        hideNewHistory()
        updateBalance()
        isEdit = false
    }
    
    func updateTable() {
        let historyArrayForUserDefaults = historyArr.map { [$0.0, $0.1, $0.2, $0.3] }
        UserDefaults.standard.setValue(historyArrayForUserDefaults, forKey: "historyy")
        checkHistory()
        hideNewHistory()
        updateBalance()
    }
    
    @objc func checkSaveNewHistoryButtonSave() {
        if nameHistoryTextField?.text?.count ?? 0 > 0 , balanceNewHistoryTextField?.text?.count ?? 0 > 0 , selectedCategoryCreate != nil {
            createHistoryButton?.isUserInteractionEnabled = true
            createHistoryButton?.alpha = 1
        } else {
            createHistoryButton?.isUserInteractionEnabled = false
            createHistoryButton?.alpha = 0.5
        }
    }
    
    @objc func hideNewHistory() {
        UIView.animate(withDuration: 0.2) {
            self.newHistoryView?.alpha = 0
            
        }
        selectedCategoryCreate = nil
        nameHistoryTextField?.text = ""
        balanceNewHistoryTextField?.text = ""
        for i in butArrow {
            if i.backgroundColor == UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1) {
                i.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            }
        }
    }
    
    @objc func openNewHistory() {
        isEdit = true
        UIView.animate(withDuration: 0.2) {
            self.newHistoryView?.alpha = 1
        }
    }
    
    func createViews(buttonmage: UIImage, text: String, tag: Int) -> UIView {
        let view = UIView()
        let button = UIButton(type: .system)

        button.setImage(buttonmage.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        button.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
        button.addTarget(self, action: #selector(butTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        button.tag = tag
        
        
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        butArrow.append(button)
        
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 11, weight: .regular)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).inset(-3)
            make.centerX.equalToSuperview()
        }
        return view
    }
    
    
    func checkHistory() {
        if sortedHistoryArr.count != 0 {
            noHistoryView?.alpha = 0
            historyCollection?.alpha = 1
        } else {
            noHistoryView?.alpha = 1
            historyCollection?.alpha = 0
        }
    }
    
    @objc func butTapped(sender: UIButton) {
        
        
        
        for i in butArrow {
            if i.backgroundColor == UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1) {
                i.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            }
        }
        checkSaveNewHistoryButtonSave()
        sender.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        
        butArrow[sender.tag] = sender
        selectedCategoryCreate = sender.tag
        print(selectedCategoryCreate)
 
        
    }
    
    @objc func saveBalance() {
        let textInput = editBalanceTextField?.text?.replacingOccurrences(of: ",", with: ".") ?? "0.0"
        let text = Double(textInput) ?? 0.0
        balanceArr[selectedValueArr] = text
        UserDefaults.standard.setValue(balanceArr, forKey: "balanceArr")
        balanceLabelCount?.text = "\(valueArr[selectedValueArr].3)\(String(describing: text))"
        hideEditBalance()
        updateBalance()
        
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
        checkSaveNewHistoryButtonSave()
        view.endEditing(true)
    }
    
    @objc func changeValue() {
        let vc = ValuteViewController()
        vc.delegate = self
        vc.index = selectedValueArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func applyTintColor(to image: UIImage, with color: UIColor) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(CIColor(color: color), forKey: kCIInputColorKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)

        let context = CIContext(options: nil)
        if let output = filter?.outputImage,
           let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }

}


extension BalanceViewController: BalanceViewControllerDelegate {
    func reloadData(index: Int) {
        selectedValueArr = index
        valueImageView?.image = valueArr[selectedValueArr].0
        nameLabel?.text = valueArr[selectedValueArr].1
        labelValEditBalance?.text = valueArr[selectedValueArr].1
        editBalanceImageView?.image = valueArr[selectedValueArr].0
        coyntryNewHistoryLabel?.text = valueArr[selectedValueArr].1
        coyntryNewHistoryImageView?.image = valueArr[selectedValueArr].0
        loadBalance()
        updateBalance()
        
    }
}


extension BalanceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkSaveEditBalance()
        checkSaveNewHistoryButtonSave()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkSaveEditBalance()
        checkSaveNewHistoryButtonSave()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveEditBalance()
        checkSaveNewHistoryButtonSave()
        return true
    }
}


extension BalanceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollection {
            return catArr.count
        } else {
            return sortedHistoryArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .clear
            
            let imageView = UIImageView(image: catArr[indexPath.row].0)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(48)
                make.top.centerX.equalToSuperview()
            }
            
            if selectedCategor == indexPath.row {
                let originalImage = imageView.image
                if let tintedImage = applyTintColor(to: originalImage!, with: UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)) {
                    imageView.image = tintedImage
                }
            }
            
            
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.textColor = .black
            label.text = catArr[indexPath.row].1
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "his", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 16
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(48)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(10)
            }
            
            for i in catArr {
                if i.1 == sortedHistoryArr[indexPath.row].1 {
                    imageView.image =  applyTintColor(to: i.0, with: UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1))
                }
            }
            
            let nameText = UILabel()
            nameText.text = sortedHistoryArr[indexPath.row].0
            nameText.font = .systemFont(ofSize: 17, weight: .semibold)
            nameText.textColor = .black
            cell.addSubview(nameText)
            nameText.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-10)
                make.top.equalTo(imageView.snp.top)
            }
            
            let categoryLabel = UILabel()
            categoryLabel.text = sortedHistoryArr[indexPath.row].1
            categoryLabel.font = .systemFont(ofSize: 16, weight: .regular)
            categoryLabel.textColor = UIColor(red: 183/255, green: 182/255, blue: 186/255, alpha: 1)
            cell.addSubview(categoryLabel)
            categoryLabel.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-10)
                make.bottom.equalTo(imageView.snp.bottom)
            }
            
            let balanceLabel = UILabel()
            balanceLabel.text = "\(valueArr[selectedValueArr].3)\(sortedHistoryArr[indexPath.row].2)"
            balanceLabel.textColor = .black
            balanceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.addSubview(balanceLabel)
            balanceLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(10)
            }
            
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            cell.addSubview(separatorView)
            separatorView.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection {
            return CGSize(width: 48, height: 69)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 72)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != historyCollection {
            selectedCategor = indexPath.row
            collectionView.reloadData()
            updateBalance()
            print(1)
        } else {
            print(23)
        }
    }
    
    
    
}
    
    
extension BalanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedHistoryArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hist", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }

        for i in catArr {
            if i.1 == sortedHistoryArr[indexPath.row].1 {
                imageView.image = applyTintColor(to: i.0, with: UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1))
            }
        }

        let nameText = UILabel()
        nameText.text = sortedHistoryArr[indexPath.row].0
        nameText.font = .systemFont(ofSize: 17, weight: .semibold)
        nameText.textColor = .black
        cell.addSubview(nameText)
        nameText.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.top.equalTo(imageView.snp.top)
        }

        let categoryLabel = UILabel()
        categoryLabel.text = sortedHistoryArr[indexPath.row].1
        categoryLabel.font = .systemFont(ofSize: 16, weight: .regular)
        categoryLabel.textColor = UIColor(red: 183/255, green: 182/255, blue: 186/255, alpha: 1)
        cell.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.bottom.equalTo(imageView.snp.bottom)
        }

        let balanceLabel = UILabel()
        balanceLabel.text = "\(valueArr[selectedValueArr].3)\(sortedHistoryArr[indexPath.row].2)"
        balanceLabel.textColor = .black
        balanceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }

        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        cell.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    // Метод для создания действий при свайпе
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        
        let editAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            
            self.isEdit = true
            
            
            let nameText = sortedHistoryArr[indexPath.row].0
            self.nameHistoryTextField?.text = nameText
            
            var cat = 0
            for i in self.catArr {
                if i.1 == sortedHistoryArr[indexPath.row].1 {
                    let categor: Int = cat
                    self.selectedCategoryCreate = categor
                    
                }
                cat += 1
            }
            self.butArrow[self.selectedCategoryCreate ?? 0].backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            
            
            self.balanceNewHistoryTextField?.text = sortedHistoryArr[indexPath.row].2
            
            self.editElement.append(sortedHistoryArr[indexPath.row])
            
            self.openNewHistory()
            
     
            
            completionHandler(true)
        }
        
        
        editAction.backgroundColor = .orange
        editAction.image = UIImage.whitePencil.resize(targetSize: CGSize(width: 20, height: 20))
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
}
