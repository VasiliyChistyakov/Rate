//
//  MainPresenter.swift
//  Valuta
//
//  Created by sot on 12.09.2022.
//

import UIKit

final class MainPresenter: MainPresenterProtocol {
	// MARK: - Public Properties
	weak var view: MainViewProtocol?
	var interactor: MainInteractorInputProtocol?
	var wireframe: MainWireframeProtocol?
	
	var listsOfcurrencies: [String] = []
	
	// MARK: - Public Methods
	func viewDidLoad() {
		interactor?.fetchData()
	}
    
    func inputData(input: String?, picked: String?, model: RatesModel?) {
        guard
            let input = input,
            let picked = picked,
            let model = model
        else { return }
        
        interactor?.fetchiInput(input: input, picked: picked, model: model)
    }
    
    func outputData(output: String?, picked: String?, model: RatesModel?) {
        guard
            let output = output,
            let picked = picked,
            let model = model
        else { return }
        
        interactor?.fetchiOutput(output: output, picked: picked, model: model)
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {
	func onCurrencyReceive(_ list: RatesModel) {
		view?.showCurrency(list)
		let keys = list.valute.keys.sorted()
		self.listsOfcurrencies = keys
	}
	
	func onUserDataReceive(_ firebaseData: NSDictionary?) {
		let username = firebaseData?["name"] as? String ?? ""
		view?.showUsername(username)
	}
    
    func onInputReceive(_ text: String) {
        view?.showInput(text)
    }
    
    func onOutputReceive(_ text: String) {
        view?.showOutput(text)
    }
}
