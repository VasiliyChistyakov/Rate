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
    
    func configure(_ source: MainCalculationSource, text: String?, picked: String?, model: MainExchangeRates?) {
        guard
            let text = text,
            let picked = picked,
            let rates = model
        else { return }
        
        let model = MainCalculation(text: text, picked: picked, rates: rates, source: source)
        interactor?.setCalculation(model)
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {
    func onRecevie(_ data: MainCalculationRecive) {
        view?.showView(data)
    }
    
	func onCurrencyReceive(_ list: MainExchangeRates) {
		view?.showCurrency(list)
		let keys = list.valute.keys.sorted()
		self.listsOfcurrencies = keys
	}
}
