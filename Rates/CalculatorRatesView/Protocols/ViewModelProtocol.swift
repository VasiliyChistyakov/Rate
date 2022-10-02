//
//  ViewModelProtocol.swift
//  Valuta
//
//  Created by Василий  on 01.01.2022.
//

import Foundation
import UIKit

protocol MainWireframeProtocol: AnyObject {
	static func CreateMainModule() -> UIViewController
}

protocol MainPresenterProtocol: AnyObject {
	var view: MainViewProtocol? { get set }
	var interactor: MainInteractorInputProtocol? { get set }
	var wireframe: MainWireframeProtocol? { get set }
	
	// Уведомление от View к Presenter
	var listsOfcurrencies: [String] { get set }
	func viewDidLoad()
    func inputData(input: String?, picked: String?, model: RatesModel?)
    func outputData(output: String?, picked: String?, model: RatesModel?)
}

protocol MainViewProtocol: AnyObject {
    
	// Запрос от Presenter к View
	func showCurrency(_ showList: RatesModel?)
	func showUsername(_ username: String)
    func showInput(_ text: String)
    func showOutput(_ text: String)
}

protocol MainInteractorInputProtocol: AnyObject {
	var presenter: MainInteractorOutputProtocol? { get set }
	
	// Запрос от Presenter к Interactor
	func fetchData()
    func fetchiInput(input: String, picked: String, model: RatesModel)
    func fetchiOutput(output: String, picked: String, model: RatesModel)
//	func fetchFirebaseUserData()
}

protocol MainInteractorOutputProtocol: AnyObject {
	
	// Ответ от Interactor к Presenter
	func onCurrencyReceive(_ list: RatesModel)
	func onUserDataReceive(_ firebaseData: NSDictionary?)
    func onInputReceive(_ text: String)
    func onOutputReceive(_ text: String)
}
