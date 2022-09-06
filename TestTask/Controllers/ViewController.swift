//
//  ViewController.swift
//  TestTask
//
//  Created by Константин Каменчуков on 05.09.2022.
//

import UIKit

class ViewController: UIViewController, MobileStorage {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imeiTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter imei"
        return textField
    }()
    
   private let modelTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter model"
        return textField
    }()
    
    private let saveButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let getAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Get all", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(getAllButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let findByImeiButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Find by Imei", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(findByImeiButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Delete", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let existButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Exist", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(existButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   private var key = "key"
    
    func getAll() -> Set<Mobile> {
        var allPhones:Set<Mobile> = []
        var mobileObject = UserDefaults.standard.object(forKey: key) as? [String: String] ?? [String: String]()
       
        for (key, model) in mobileObject {
            allPhones.insert(Mobile(imei: key, model: model))
            print(allPhones)
        }
        return allPhones
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        var mobileObject = UserDefaults.standard.object(forKey: key) as? [String: String] ?? [String: String]()
        
        if let model = mobileObject[imei] {
            print("Found it by imei")
            return Mobile(imei: imei, model: model)
        } else {
           print("Phone was not found by imei")
            return nil
        }
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        var mobileObject = UserDefaults.standard.object(forKey: key) as? [String: String] ?? [String: String]()
        
        if let _ = mobileObject[mobile.imei] { throw MobileStorageErrors.notUniqueImei }
        if mobile.imei == "" {throw MobileStorageErrors.noImei}
        if mobile.model == "" { throw MobileStorageErrors.noModel }
        mobileObject[mobile.imei] = mobile.model
        UserDefaults.standard.set(mobileObject, forKey: key)
        
        return Mobile(imei: mobile.imei, model: mobile.model)
    }
    
    func delete(_ product: Mobile) throws {
        var mobileObject = UserDefaults.standard.object(forKey: key) as? [String: String] ?? [String: String]()
        
        if exists(product) {
            mobileObject[product.imei] = nil
            print("Phone was deleted")
        } else {
            throw MobileStorageErrors.notInMemory
        }
        UserDefaults.standard.set(mobileObject, forKey: key)
    }
    
    func exists(_ product: Mobile) -> Bool {
        var mobileObject = UserDefaults.standard.object(forKey: key) as? [String: String] ?? [String: String]()
        
        if mobileObject[product.imei] == product.model {
            print("Found it")
            return true
        } else {
            print("Product was not found")
            return false
        }
    }
    
    private var textFieldStackView = UIStackView()
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setUpDelegate()
    }
  
    @objc func saveButtonTapped() {
        let imeiTrimmingText = imeiTextField.text ?? ""
        let modelTrimmingText = modelTextField.text ?? ""
        let phoneObject = Mobile(imei: imeiTrimmingText, model: modelTrimmingText)
        print("phoneObject", phoneObject)
        do {
            try? save(phoneObject) } catch {
                print("imei should be unique")
            }
        }
    
    @objc func getAllButtonTapped() {
        getAll()
    }
    @objc func findByImeiButtonTapped() {
        let imeiTrimmingText = imeiTextField.text ?? ""
        findByImei(imeiTrimmingText)
    }
    @objc func deleteButtonTapped() {
        let imeiTrimmingText = imeiTextField.text ?? ""
        let modelTrimmingText = modelTextField.text ?? ""
        let phoneObject = Mobile(imei: imeiTrimmingText, model: modelTrimmingText)
        do {
            try? delete(phoneObject)
        } catch {
              print("Nothing to delete")
            }
    }
    @objc func existButtonTapped() {
        let imeiTrimmingText = imeiTextField.text ?? ""
        let modelTrimmingText = modelTextField.text ?? ""
        let phoneObject = Mobile(imei: imeiTrimmingText, model: modelTrimmingText)
        exists(phoneObject)
    }
}

extension ViewController {
    func setViews() {
        title = "Mobile Storage"
        view.backgroundColor = .white
        
        textFieldStackView = UIStackView(
            arrangedSubviews: [imeiTextField, modelTextField],
            axis: .vertical,
            spacing: 10,
            distribution: .fillProportionally
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textFieldStackView)
        backgroundView.addSubview(saveButton)
        backgroundView.addSubview(findByImeiButton)
        backgroundView.addSubview(deleteButton)
        backgroundView.addSubview(getAllButton)
        backgroundView.addSubview(existButton)
    }
    
    private func setUpDelegate() {
        imeiTextField.delegate = self
        modelTextField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        imeiTextField.resignFirstResponder()
        modelTextField.resignFirstResponder()
        return true
    }
}

extension ViewController {
    private func registerKeyBoardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keybordWillShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keybordWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keybordWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
    }
    
    @objc private func keybordWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}
//MARK: - Constrains
extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textFieldStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            textFieldStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            findByImeiButton.heightAnchor.constraint(equalToConstant: 40),
            findByImeiButton.widthAnchor.constraint(equalToConstant: 200),
            findByImeiButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            findByImeiButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            getAllButton.heightAnchor.constraint(equalToConstant: 40),
            getAllButton.widthAnchor.constraint(equalToConstant: 200),
            getAllButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            getAllButton.topAnchor.constraint(equalTo: findByImeiButton.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: getAllButton.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            existButton.heightAnchor.constraint(equalToConstant: 40),
            existButton.widthAnchor.constraint(equalToConstant: 200),
            existButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            existButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 20)
        ])
    }
}
