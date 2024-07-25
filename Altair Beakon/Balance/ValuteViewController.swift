//
//  ValuteViewController.swift
//  Altair Beakon
//
//  Created by Владимир Кацап on 25.07.2024.
//

import UIKit

class ValuteViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    weak var delegate: BalanceViewControllerDelegate?
    var index = 0
    var collection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
    }
    
    func createInterface() {
        let titleLabel = UILabel()
        titleLabel.text = "Currency"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .black
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(.arrowBack.resize(targetSize: CGSize(width: 17, height: 22)), for: .normal)
        backButton.tintColor = .black
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(22)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "main")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).inset(-50)
        })
        
        let cancelButton: UIButton = {
            let burron = UIButton(type: .system)
            burron.setTitle("Cancel", for: .normal)
            burron.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            burron.backgroundColor = .clear
            burron.layer.borderColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1).cgColor
            burron.layer.borderWidth = 1
            burron.setTitleColor(UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1), for: .normal)
            burron.layer.cornerRadius = 16
            return burron
        }()
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        cancelButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.backgroundColor = UIColor(red: 148/255, green: 98/255, blue: 255/255, alpha: 1)
            button.layer.cornerRadius = 16
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(.white, for: .normal)
            return button
        }()
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.left.equalTo(view.snp.centerX).offset(7.5)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
    }
    
    @objc func save() {
        UserDefaults.standard.setValue(index, forKey: "valute")
        delegate?.reloadData(index: index)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}


extension ValuteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return valueArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFit
        if indexPath.row == index {
            imageView.image = UIImage.selectedCollection
        } else {
            imageView.image = UIImage.unselectedCollection
        }
        
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        let flagImageView = UIImageView()
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = 12
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.image = valueArr[indexPath.row].0
        cell.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.left.equalTo(imageView.snp.right).inset(-15)
            make.centerY.equalToSuperview()
        }
        
        let nameLabel = UILabel()
        nameLabel.text = valueArr[indexPath.row].1
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .black
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).inset(-10)
            make.bottom.equalTo(cell.snp.centerY).offset(3)
        }
        
        let detailLabel = UILabel()
        detailLabel.text = valueArr[indexPath.row].2
        detailLabel.font = .systemFont(ofSize: 12, weight: .regular)
        detailLabel.textColor = UIColor(red: 183/255, green: 182/255, blue: 186/255, alpha: 1)
        cell.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).inset(-10)
            make.top.equalTo(cell.snp.centerY).offset(3)
        }
        
        let valueLabel = UILabel()
        valueLabel.text = valueArr[indexPath.row].3
        valueLabel.font = .systemFont(ofSize: 12, weight: .regular)
        valueLabel.textColor = .black
        cell.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        collectionView.reloadData()
    }
    
}
