//
//  CalcViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 28.07.2024.
//

import UIKit

class CalcViewController: UIViewController {
    
    var collection: UICollectionView?
    var calcButton: UIButton?
    
    var incomeTextField, housingTextField, foodTextField, clotchesTextField, medicineTextField, transportTextField, studyTextField,loansTextFild, otherTextField: UITextField?
    
    var mountIncomeLabel, moneySpentLabel, percIncome, housingLabel, foodLabel, clotchLabel, medLabel, transLabel, studLabel, loansLabel, otherLabel: UILabel?
    var statView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createInterface()
    }
    
    
    func createInterface() {
        let imageView = UIImageView(image: .BG)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let calcLabel = UILabel()
        calcLabel.text = "Calculator"
        calcLabel.textColor = .black
        calcLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(calcLabel)
        calcLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            layout.scrollDirection = .vertical
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(calcLabel.snp.bottom).inset(-20)
        })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
        
        statView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            view.alpha = 0
            
            let balanceLabel = UILabel()
            balanceLabel.text = "Balance"
            balanceLabel.textColor = .black
            balanceLabel.font = .systemFont(ofSize: 22, weight: .semibold)
            view.addSubview(balanceLabel)
            balanceLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(20)
                make.centerX.equalToSuperview()
            }
            
            let mountIncomeTextLabel = createBalanceLabel(text: "Monthly income")
            view.addSubview(mountIncomeTextLabel)
            mountIncomeTextLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(balanceLabel.snp.bottom).inset(-24)
            }
            mountIncomeTextLabel.textColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            
            mountIncomeLabel = createLabel(text: "0")
            mountIncomeLabel?.textColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            view.addSubview(mountIncomeLabel!)
            mountIncomeLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(mountIncomeTextLabel)
                
            })
            let oneSep = UIView()
            oneSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(oneSep)
            oneSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(mountIncomeTextLabel.snp.bottom).inset(-10)
            }
            
            
            let spentTextLabel = createBalanceLabel(text: "Money spent")
            spentTextLabel.textColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            view.addSubview(spentTextLabel)
            spentTextLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(oneSep.snp.bottom).inset(-10)
            }
            moneySpentLabel = createBalanceLabel(text: "0")
            moneySpentLabel?.textColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            view.addSubview(moneySpentLabel!)
            moneySpentLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(spentTextLabel)
                
            })
            let twoSep = UIView()
            twoSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(twoSep)
            twoSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(spentTextLabel.snp.bottom).inset(-10)
            }
            
            let percLabel = createBalanceLabel(text: "Percentage of income")
            view.addSubview(percLabel)
            percLabel.snp.makeConstraints { make in
                make.top.equalTo(twoSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            percIncome = createBalanceLabel(text: "0 %")
            view.addSubview(percIncome!)
            percIncome?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(percLabel)
            })
            let threeSep = UIView()
            threeSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(threeSep)
            threeSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(percLabel.snp.bottom).inset(-10)
            }
            
            
            let housTextLabel = createBalanceLabel(text: "Housing")
            view.addSubview(housTextLabel)
            housTextLabel.snp.makeConstraints { make in
                make.top.equalTo(threeSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            housingLabel = createBalanceLabel(text: "0 %")
            view.addSubview(housingLabel!)
            housingLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(housTextLabel)
            })
            let fourSep = UIView()
            fourSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(fourSep)
            fourSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(housTextLabel.snp.bottom).inset(-10)
            }
            
            let foodTextLabel = createBalanceLabel(text: "Food")
            view.addSubview(foodTextLabel)
            foodTextLabel.snp.makeConstraints { make in
                make.top.equalTo(fourSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            foodLabel = createBalanceLabel(text: "0 %")
            view.addSubview(foodLabel!)
            foodLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(foodTextLabel)
            })
            let fiveSep = UIView()
            fiveSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(fiveSep)
            fiveSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(foodTextLabel.snp.bottom).inset(-10)
            }
            
            
            let clotchTextLabel = createBalanceLabel(text: "Clothes")
            view.addSubview(clotchTextLabel)
            clotchTextLabel.snp.makeConstraints { make in
                make.top.equalTo(fiveSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            clotchLabel = createBalanceLabel(text: "0 %")
            view.addSubview(clotchLabel!)
            clotchLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(clotchTextLabel)
            })
            let fixSep = UIView()
            fixSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(fixSep)
            fixSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(clotchTextLabel.snp.bottom).inset(-10)
            }
            
            let medTextLabel = createBalanceLabel(text: "Medicine")
            view.addSubview(medTextLabel)
            medTextLabel.snp.makeConstraints { make in
                make.top.equalTo(fixSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            medLabel = createBalanceLabel(text: "0 %")
            view.addSubview(medLabel!)
            medLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(medTextLabel)
            })
            let sixSep = UIView()
            sixSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(sixSep)
            sixSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(medTextLabel.snp.bottom).inset(-10)
            }
            
            let transTextLabel = createBalanceLabel(text: "Transport")
            view.addSubview(transTextLabel)
            transTextLabel.snp.makeConstraints { make in
                make.top.equalTo(sixSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            transLabel = createBalanceLabel(text: "0 %")
            view.addSubview(transLabel!)
            transLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(transTextLabel)
            })
            let sevenSep = UIView()
            sevenSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(sevenSep)
            sevenSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(transTextLabel.snp.bottom).inset(-10)
            }
            
            
            let studTextLabel = createBalanceLabel(text: "Study")
            view.addSubview(studTextLabel)
            studTextLabel.snp.makeConstraints { make in
                make.top.equalTo(sevenSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            studLabel = createBalanceLabel(text: "0 %")
            view.addSubview(studLabel!)
            studLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(studTextLabel)
            })
            let edgeSep = UIView()
            edgeSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(edgeSep)
            edgeSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(studTextLabel.snp.bottom).inset(-10)
            }
            
            let loansTextLabel = createBalanceLabel(text: "Loans")
            view.addSubview(loansTextLabel)
            loansTextLabel.snp.makeConstraints { make in
                make.top.equalTo(edgeSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            loansLabel = createBalanceLabel(text: "0 %")
            view.addSubview(loansLabel!)
            loansLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(loansTextLabel)
            })
            let tenSep = UIView()
            tenSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(tenSep)
            tenSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(loansTextLabel.snp.bottom).inset(-10)
            }
            
            let otherTextLabel = createBalanceLabel(text: "Other")
            view.addSubview(otherTextLabel)
            otherTextLabel.snp.makeConstraints { make in
                make.top.equalTo(tenSep.snp.bottom).inset(-10)
                make.left.equalToSuperview().inset(15)
            }
            otherLabel = createBalanceLabel(text: "0 %")
            view.addSubview(otherLabel!)
            otherLabel?.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(otherTextLabel)
            })
            let finalSep = UIView()
            finalSep.backgroundColor = UIColor(red: 220/255, green: 199/255, blue: 253/255, alpha: 1)
            view.addSubview(finalSep)
            finalSep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(otherTextLabel.snp.bottom).inset(-10)
            }
            
            let cancelBut = UIButton(type: .system)
            cancelBut.setTitle("Cancel", for: .normal)
            cancelBut.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            cancelBut.setTitleColor(UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1), for: .normal)
            cancelBut.layer.borderWidth = 1
            cancelBut.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
            cancelBut.layer.cornerRadius = 16
            cancelBut.addTarget(self, action: #selector(hideStat), for: .touchUpInside)
            view.addSubview(cancelBut)
            cancelBut.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(15)
            }
            
            return view
        }()
        view.addSubview(statView!)
        statView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(596)
            make.centerY.centerX.equalToSuperview()
        })
        
    }
    
    @objc func hideBalanceView() {
        UIView.animate(withDuration: 0.2) {
            self.statView?.alpha = 0
        }
        mountIncomeLabel?.text = "0"
        moneySpentLabel?.text = "0"
        percIncome?.text = "0 %"
        housingLabel?.text = "0 %"
        foodLabel?.text = "0 %"
        clotchLabel?.text = "0 %"
        medLabel?.text = "0 %"
        transLabel?.text = "0 %"
        studLabel?.text = "0 %"
        loansLabel?.text = "0 %"
        otherLabel?.text = "0 %"
    }
    
    func createBalanceLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    @objc func hideKeyboard() {
        checkFill()
        view.endEditing(true)
    }
    
    @objc func hideStat() {
        UIView.animate(withDuration: 0.3) {
            self.statView?.alpha = 0
        }
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    @objc func openBalance() {
        let income:Double  = Double(incomeTextField?.text ?? "1" ) ?? 1
        let housing:Double = Double(housingTextField?.text ?? "1" ) ?? 1
        let food:Double = Double(foodTextField?.text ?? "1" ) ?? 1
        let clotch:Double = Double(clotchesTextField?.text ?? "1" ) ?? 1
        let med:Double = Double(medicineTextField?.text ?? "1" ) ?? 1
        let trans:Double = Double(transportTextField?.text ?? "1" ) ?? 1
        let stud:Double = Double(studyTextField?.text ?? "1" ) ?? 1
        let loans:Double = Double(loansTextFild?.text ?? "1" ) ?? 1
        let other:Double = Double(otherTextField?.text ?? "1" ) ?? 1
        
        //moneyIncomeLabel
        mountIncomeLabel?.text = String(Int(income))
        
        //moneySpentLabel
        let allSpent = (housing + food + clotch + med + trans + stud + loans + other)
        moneySpentLabel?.text = String(Int(allSpent))
        
        //percIncome
        let procent = (allSpent / income) * 100
        percIncome?.text = "\(Int(procent)) %"
        
        //housing
        let house = (housing / allSpent) * 100
        housingLabel?.text = "\(Int(house)) %"
        
        //food
        let foode = (food / allSpent) * 100
        foodLabel?.text = "\(Int(foode)) %"
        
        //clotches
        let clotches = (clotch / allSpent) * 100
        clotchLabel?.text = "\(Int(clotches)) %"
        
        //med
        let medic = (med / allSpent) * 100
        medLabel?.text = "\(Int(medic)) %"
        
        //trans
        let transp = (trans / allSpent) * 100
        transLabel?.text = "\(Int(transp)) %"
        
        //stud
        let study = (stud / allSpent) * 100
        studLabel?.text = "\(Int(study)) %"
        
        //loans
        let loan = (loans / allSpent) * 100
        loansLabel?.text = "\(Int(loan)) %"
        
        //other
        let oth = (other / allSpent) * 100
        otherLabel?.text = "\(Int(oth)) %"
        
        
        UIView.animate(withDuration: 0.3) {
            self.statView?.alpha = 1
        }
        
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
        textField.layer.cornerRadius = 16
        return textField
    }
    
    @objc func clearAllTextFields() {
        view.endEditing(true)
        incomeTextField?.text = ""
        housingTextField?.text = ""
        foodTextField?.text = ""
        clotchesTextField?.text = ""
        medicineTextField?.text = ""
        transportTextField?.text = ""
        studyTextField?.text = ""
        loansTextFild?.text = ""
        otherTextField?.text = ""
        checkFill()
    }
    
    func checkFill() {
        if incomeTextField?.text?.count ?? 0 > 0, housingTextField?.text?.count ?? 0 > 0, foodTextField?.text?.count ?? 0 > 0, clotchesTextField?.text?.count ?? 0 > 0, medicineTextField?.text?.count ?? 0 > 0, transportTextField?.text?.count ?? 0 > 0, studyTextField?.text?.count ?? 0 > 0, loansTextFild?.text?.count ?? 0 > 0, otherTextField?.text?.count ?? 0 > 0 {
            calcButton?.alpha = 1
            calcButton?.isEnabled = true
        } else {
            calcButton?.alpha = 0.5
            calcButton?.isEnabled = false
        }
    }
    
    
    

}


extension CalcViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let incomeLabel = createLabel(text: "Income")
        cell.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        incomeTextField = createTextField()
        cell.addSubview(incomeTextField!)
        incomeTextField?.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview()
            make.top.equalTo(incomeLabel.snp.bottom).inset(-5)
        }
        
        
        let housingLabel = createLabel(text: "Housing")
        cell.addSubview(housingLabel)
        housingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(incomeTextField!.snp.bottom).inset(-15)
        }
        
        let foodLabel = createLabel(text: "Food")
        cell.addSubview(foodLabel)
        foodLabel.snp.makeConstraints { make in
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(incomeTextField!.snp.bottom).inset(-15)
        }
        
        housingTextField = createTextField()
        cell.addSubview(housingTextField!)
        housingTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.equalToSuperview()
            make.right.equalTo(cell.snp.centerX).offset(-7.5)
            make.top.equalTo(housingLabel.snp.bottom).inset(-5)
        })
        
        foodTextField = createTextField()
        cell.addSubview(foodTextField!)
        foodTextField!.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.right.equalToSuperview()
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(foodLabel.snp.bottom).inset(-5)
        }
        
        let clotchesLabel = createLabel(text: "Clothes")
        cell.addSubview(clotchesLabel)
        clotchesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(housingTextField!.snp.bottom).inset(-15)
        }
        
        let medicineLabel = createLabel(text: "Medicine")
        cell.addSubview(medicineLabel)
        medicineLabel.snp.makeConstraints { make in
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(housingTextField!.snp.bottom).inset(-15)
        }
        
        clotchesTextField = createTextField()
        cell.addSubview(clotchesTextField!)
        clotchesTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.equalToSuperview()
            make.right.equalTo(cell.snp.centerX).offset(-7.5)
            make.top.equalTo(clotchesLabel.snp.bottom).inset(-5)
        })
        
        medicineTextField = createTextField()
        cell.addSubview(medicineTextField!)
        medicineTextField!.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.right.equalToSuperview()
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(medicineLabel.snp.bottom).inset(-5)
        }
        
        let transportLabel = createLabel(text: "Transport")
        cell.addSubview(transportLabel)
        transportLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(clotchesTextField!.snp.bottom).inset(-15)
        }
        
        let studLabel = createLabel(text: "Study")
        cell.addSubview(studLabel)
        studLabel.snp.makeConstraints { make in
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(clotchesTextField!.snp.bottom).inset(-15)
        }
        
        transportTextField = createTextField()
        cell.addSubview(transportTextField!)
        transportTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.equalToSuperview()
            make.right.equalTo(cell.snp.centerX).offset(-7.5)
            make.top.equalTo(studLabel.snp.bottom).inset(-5)
        })
        
        studyTextField = createTextField()
        cell.addSubview(studyTextField!)
        studyTextField!.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.right.equalToSuperview()
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(studLabel.snp.bottom).inset(-5)
        }
        
        let loansLabel = createLabel(text: "Loans")
        cell.addSubview(loansLabel)
        loansLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(studyTextField!.snp.bottom).inset(-15)
        }
        
        let otherLabel = createLabel(text: "Other")
        cell.addSubview(otherLabel)
        otherLabel.snp.makeConstraints { make in
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(studyTextField!.snp.bottom).inset(-15)
        }
        
        loansTextFild = createTextField()
        cell.addSubview(loansTextFild!)
        loansTextFild?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.equalToSuperview()
            make.right.equalTo(cell.snp.centerX).offset(-7.5)
            make.top.equalTo(otherLabel.snp.bottom).inset(-5)
        })
        
        otherTextField = createTextField()
        cell.addSubview(otherTextField!)
        otherTextField!.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.right.equalToSuperview()
            make.left.equalTo(cell.snp.centerX).offset(7.5)
            make.top.equalTo(otherLabel.snp.bottom).inset(-5)
        }
        
        let delButton = UIButton(type: .system)
        delButton.setTitle("Delete", for: .normal)
        delButton.backgroundColor = .clear
        delButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        delButton.setTitleColor(UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1), for: .normal)
        delButton.layer.borderWidth = 1
        delButton.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
        delButton.layer.cornerRadius = 16
        cell.addSubview(delButton)
        delButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.left.equalToSuperview()
            make.right.equalTo(cell.snp.centerX).offset(-7.5)
            make.top.equalTo(loansTextFild!.snp.bottom).inset(-30)
        }
        delButton.addTarget(self, action: #selector(clearAllTextFields), for: .touchUpInside)
        
        calcButton = UIButton(type: .system)
        calcButton?.setTitle("Calculate", for: .normal)
        calcButton?.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        calcButton?.setTitleColor(.white, for: .normal)
        calcButton?.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
        calcButton?.layer.cornerRadius = 16
        calcButton?.isEnabled = false
        calcButton?.alpha = 0.5
        cell.addSubview(calcButton!)
        calcButton?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.right.equalToSuperview()
            make.top.equalTo(loansTextFild!.snp.bottom).inset(-30)
            make.left.equalTo(cell.snp.centerX).offset(7.5)
        })
        calcButton?.addTarget(self, action: #selector(openBalance), for: .touchUpInside)
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 700)
    }
    
}


extension CalcViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkFill()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFill()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkFill()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkFill()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        checkFill()
        return true
    }
}
