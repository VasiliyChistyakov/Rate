//
//  MainViewController.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 15.08.2021.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    private enum Const {
        static let mainTrailing: CGFloat = -16
        static let mainLeading: CGFloat = 16
        
        static let topText = "Выберите валюту 🤑"
        static let inputText = " AMD "
        static let outputText = " RUB "
    }
    
    // MARK: - Public Properties
	var presenter: MainPresenterProtocol?
    var pickedValute: String!
    
    var inputObserver: AnyCancellable?
    var outputObserver: AnyCancellable?
    
    // MARK: - Private Properties
	private var ratesModel: MainExchangeRates? {
		didSet {
			DispatchQueue.main.async {
				self.pickerView.reloadAllComponents()
				
				self.activityIndicator.isHidden = true
				self.activityIndicator.stopAnimating()
				
				self.pickerView.isHidden = false
				self.topTextLabel.isHidden = false
				self.inputTextField.isHidden = false
				self.outputTextField.isHidden = false
			}
		}
	}
 
	// MARK: - UI element
    private let topTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Const.topText
		label.isHidden = true
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        return picker
    }()
	
	private let activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.isHidden = true
		return indicator
	}()
  
    private let stackField: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        return stackView
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
		textField.isHidden = true
		textField.layer.borderWidth = 0.1
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .asciiCapableNumberPad
		textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.placeholder = Const.inputText
		
		textField.rightViewMode = .always
		textField.leftViewMode = .always
        return textField
    }()
    
    private let outputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
		textField.isHidden = true
		textField.layer.borderWidth = 0.1
        textField.font = .systemFont(ofSize: 16)
		textField.keyboardType = .asciiCapableNumberPad
		textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.placeholder = Const.outputText
		
		textField.rightViewMode = .always
		textField.leftViewMode = .always
        return textField
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
		presenter?.viewDidLoad()
    }
    
    // MARK: - Private Methods
	private func setupUI() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		
		stackField.addSubviews([inputTextField, outputTextField])
		view.addSubviews([topTextLabel, pickerView, stackField, activityIndicator])
		
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			topTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            topTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Const.mainTrailing),
            topTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.mainLeading),
			
			pickerView.topAnchor.constraint(equalTo: topTextLabel.bottomAnchor, constant: 30),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Const.mainTrailing),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.mainLeading),
			
			stackField.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 35),
            stackField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Const.mainTrailing),
            stackField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.mainLeading),
			
			outputTextField.topAnchor.constraint(equalTo: stackField.topAnchor, constant: 5),
			outputTextField.leadingAnchor.constraint(equalTo: stackField.leadingAnchor, constant: 50),
			outputTextField.bottomAnchor.constraint(equalTo: stackField.bottomAnchor, constant: -5),
			
			inputTextField.topAnchor.constraint(equalTo: stackField.topAnchor, constant: 5),
			inputTextField.trailingAnchor.constraint(equalTo: stackField.trailingAnchor, constant: -50),
			inputTextField.bottomAnchor.constraint(equalTo: stackField.bottomAnchor, constant: -5)
		])
	}
    
    private func bind() {
        observerCalculation()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
	
	private func observerCalculation() {
		inputObserver = NotificationCenter.default
			.publisher(for: UITextField.textDidChangeNotification, object: inputTextField)
			.map {$0.object as? UITextField}
			.compactMap { $0?.text }
			.map { str -> Bool in
				if let number = Double(str) {
					return number > 0
				} else {
					return false
				}
			}
			.sink(receiveValue: { value in
                self.presenter?.configure(MainCalculationSource.input, text: self.inputTextField.text, picked: self.pickedValute, model: self.ratesModel)
			})
		
		outputObserver = NotificationCenter.default
			.publisher(for: UITextField.textDidChangeNotification, object: outputTextField)
			.map {$0.object as? UITextField}
			.compactMap { $0?.text }
			.map { str -> Bool in
				if let number = Double(str) {
					return number > 0
				} else {
					return false
				}
			}
			.sink(receiveValue: { value in
                self.presenter?.configure(MainCalculationSource.output, text: self.outputTextField.text, picked: self.pickedValute, model: self.ratesModel)
			})
	}
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
	func showCurrency(_ showList: MainExchangeRates?) {
		guard let list = showList else { return }
		self.ratesModel = list
	}
	
    func showView(_ value: MainCalculationRecive) {
        switch value.source {
        case .output:
            inputTextField.text = value.sum
        case .input:
            outputTextField.text = value.sum
        }
    }
}
// MARK: -  UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let currencies = presenter?.listsOfcurrencies else { return 0 }
		return currencies.count
		
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.listsOfcurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.pickedValute = presenter?.listsOfcurrencies[row]
		self.topTextLabel.text = self.ratesModel?.valute[self.pickedValute]?.name
		self.inputTextField.placeholder = presenter?.listsOfcurrencies[row]
        
        self.presenter?.configure(MainCalculationSource.output, text: self.outputTextField.text, picked: self.pickedValute, model: ratesModel)
        self.presenter?.configure(MainCalculationSource.input, text: self.inputTextField.text, picked: self.pickedValute, model: ratesModel)
    }
}
