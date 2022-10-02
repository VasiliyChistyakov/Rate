//
//  MainViewController.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 15.08.2021.
//

import UIKit
import Combine

class MainViewController: UIViewController {
	// MARK: - NSLayoutConstraints
	private var portraitConstraints: [NSLayoutConstraint] = []
	private var landscapeConstraints: [NSLayoutConstraint] = []
	
    // MARK: - Public Properties
	var presenter: MainPresenterProtocol?
    var pickedValute: String!
    var inputObserver: AnyCancellable?
    var outputObserver: AnyCancellable?
    
    // MARK: - Private Properties
    private enum Layout {
        static let topInsetPortrait: CGFloat = 36
        static let topInsetLandscape: CGFloat = 20
        static let middleInsetFromBottom: CGFloat = 280
        static let headerHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.2
        static let shadowOffset = CGSize.zero
    }

	private var viewModel: RatesModel? {
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
	
	private var isFirstLayout = true
 
	// MARK: - UI element
    private let tableView = UITableView()
    
	private let headerView: ShapeHeaderView = {
		let heder = ShapeHeaderView()
		heder.translatesAutoresizingMaskIntoConstraints = false
		return heder
	}()
	
	private let usernameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 15)
		return label
	}()
    
    private let topTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выберите валюту 🤑"
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
		textField.placeholder = " AMD "
		
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
		textField.placeholder = " RUB "
		
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
		observerCalculation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            updateLayoutWithCurrentOrientation()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayoutWithCurrentOrientation()
		
        coordinator.animate(alongsideTransition: { [weak self] context in
        })
    }
    
    @available(iOS 11.0, *)
	
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
        tableView.scrollIndicatorInsets.bottom = view.safeAreaInsets.bottom
    }
    
    
    @IBAction func tapAction(_ sender: Any) {
        inputTextField.resignFirstResponder()
        outputTextField.resignFirstResponder()
    }
    
    // MARK: - Private Methods
	private func setupUI() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		
		tableView.backgroundColor = .white
		
		if #available(iOS 11.0, *) {
			tableView.contentInsetAdjustmentBehavior = .never
		}
		
		stackField.addSubviews([inputTextField, outputTextField])
		view.addSubviews([topTextLabel, pickerView, stackField, activityIndicator, usernameLabel])
		
		NSLayoutConstraint.activate([
			headerView.heightAnchor.constraint(equalToConstant: Layout.headerHeight),
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
			usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
			
			topTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
			topTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			topTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			
			pickerView.topAnchor.constraint(equalTo: topTextLabel.bottomAnchor, constant: 30),
			pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			
			stackField.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 35),
			stackField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			stackField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			
			outputTextField.topAnchor.constraint(equalTo: stackField.topAnchor, constant: 5),
			outputTextField.leadingAnchor.constraint(equalTo: stackField.leadingAnchor, constant: 50),
			outputTextField.bottomAnchor.constraint(equalTo: stackField.bottomAnchor, constant: -5),
			
			inputTextField.topAnchor.constraint(equalTo: stackField.topAnchor, constant: 5),
			inputTextField.trailingAnchor.constraint(equalTo: stackField.trailingAnchor, constant: -50),
			inputTextField.bottomAnchor.constraint(equalTo: stackField.bottomAnchor, constant: -5)
		])
		
		
		let landscapeLeftAnchor: NSLayoutXAxisAnchor
		if #available(iOS 11.0, *) {
			landscapeLeftAnchor = view.safeAreaLayoutGuide.leftAnchor
		} else {
			landscapeLeftAnchor = view.leftAnchor
		}
	}
    
    private func bind() {
        tableView.dataSource = self
        tableView.delegate = self
		tableView.register(ShapeCell.self, forCellReuseIdentifier: ShapeCell.cellId)

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
                self.presenter?.inputData(input: self.inputTextField.text, picked: self.pickedValute, model: self.viewModel)
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
                self.presenter?.outputData(output: self.outputTextField.text, picked: self.pickedValute, model: self.viewModel)
			})
	}
    
    private func updateLayoutWithCurrentOrientation() {
        let orientation = UIDevice.current.orientation
        
        if orientation.isLandscape {
            portraitConstraints.forEach { $0.isActive = false }
            landscapeConstraints.forEach { $0.isActive = true }
        } else if orientation.isPortrait {
            landscapeConstraints.forEach { $0.isActive = false }
            portraitConstraints.forEach { $0.isActive = true }
        }
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
	func showCurrency(_ showList: RatesModel?) {
		guard let list = showList else { return }
		self.viewModel = list
	}
	
	func showUsername(_ username: String) {
		if username != "" {
			DispatchQueue.main.async {
				self.usernameLabel.text = "Привет, \(username)!"
			}
		}
	}
    
    func showInput(_ text: String) {
        outputTextField.text = text
    }
    
    func showOutput(_ text: String) {
        inputTextField.text = text
    }
	
}
// MARK: -  UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return presenter?.listsOfcurrencies.count ?? 1
		
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.listsOfcurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.pickedValute = presenter?.listsOfcurrencies[row]
		self.topTextLabel.text = self.viewModel?.valute[self.pickedValute]?.name
		self.inputTextField.placeholder = presenter?.listsOfcurrencies[row]
        
        self.presenter?.inputData(input: self.inputTextField.text, picked: self.pickedValute, model: viewModel)
        self.presenter?.outputData(output: self.outputTextField.text, picked: self.pickedValute, model: viewModel)
    }
}

// MARK: -  UITableViewDelegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter?.listsOfcurrencies.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShapeCell.cellId, for: indexPath) as! ShapeCell
		let keys = presenter?.listsOfcurrencies[indexPath.row]
		
		let nominal = Double(self.viewModel?.valute[keys ?? ""]!.nominal ?? 1)
		let value = self.viewModel?.valute[keys ?? ""]!.value ?? 0
		let previous = self.viewModel?.valute[keys ?? ""]!.previous ?? 0
		
		let nominalValue = value / nominal
		let nominalPrevious = previous / nominal
		let difference = nominalValue - nominalPrevious
		
		if previous < value {
			cell.valueLabel.textColor = .red
			cell.previousLabel.textColor = .green
		} else {
			cell.valueLabel.textColor = .green
			cell.previousLabel.textColor = .red
		}
		
		cell.nameValutaLabel.text = self.viewModel?.valute[keys ?? ""]?.name
		cell.charCodeLabel.text = self.viewModel?.valute[keys ?? ""]?.charCode
		cell.valueLabel.text = "\(String(format: "%.1f" ,nominalValue)) ₽"
		cell.previousLabel.text = "\(String(format: "%.1f" ,nominalPrevious)) ₽"
		
		return cell
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 90
	}
}
