//
//  ViewModelProtocol.swift
//  Valuta
//
//  Created by Василий  on 01.01.2022.
//

import Foundation
import UIKit

protocol MainWireframeProtocol: AnyObject {
	static func CreateMainModule(_ scene: UIWindowScene?) -> UIViewController?
}

protocol MainPresenterProtocol: AnyObject {
	var view: MainViewProtocol? { get set }
	var interactor: MainInteractorInputProtocol? { get set }
	var wireframe: MainWireframeProtocol? { get set }
	
	// Уведомление от View к Presenter
	var listsOfcurrencies: [String] { get set }
    
	func viewDidLoad()
    func configure(_ source: MainCalculationSource, text: String?, picked: String?, model: MainExchangeRates?)
}

protocol MainViewProtocol: AnyObject {
	// Запрос от Presenter к View
	func showCurrency(_ showList: MainExchangeRates?)
    func showView(_ value: MainCalculationRecive)
}

protocol MainInteractorInputProtocol: AnyObject {
	var presenter: MainInteractorOutputProtocol? { get set }
	
	// Запрос от Presenter к Interactor
	func fetchData()
    func setCalculation(_ data: MainCalculation)
//	func fetchFirebaseUserData()
}

protocol MainInteractorOutputProtocol: AnyObject {
	// Ответ от Interactor к Presenter
	func onCurrencyReceive(_ list: MainExchangeRates)
    func onRecevie(_ data: MainCalculationRecive)
}
