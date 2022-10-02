//
//  MainInteractor.swift
//  Valuta
//
//  Created by sot on 12.09.2022.
//

import UIKit

final class MainInteractor: MainInteractorInputProtocol {
  
	// MARK: - Public Properties
	weak var presenter: MainInteractorOutputProtocol?
	
	// MARK: - Public Methods
	func fetchData() {
		NetworkingManager.shared.fetchRates(urlJson: urlJson) { models in
			self.presenter?.onCurrencyReceive(models)
		}
	}
    
    func fetchiInput(input: String, picked: String, model: RatesModel) {
        guard let inputValute = Int(input) else { return }
        
        let valueRates = (Double(inputValute) * Double((model.valute[picked]!.value ?? 0)))
        
        guard let valuteNominal =  model.valute[picked]?.nominal else { return }
        
        let сalculatingNominal = valueRates / Double(valuteNominal)
        let result = "\(String(format:"%.2f",сalculatingNominal))"
        
        self.presenter?.onInputReceive(result)
    }
    
    func fetchiOutput(output: String, picked: String, model: RatesModel) {
        guard let outputValute = Int(output) else { return }
        
        let valueRates = (Double(outputValute)) / (Double((model.valute[picked]!.value ?? 0)))
        
        guard let valuteNominal =  model.valute[picked]?.nominal else { return }
        let сalculatingNominal = valueRates * Double(valuteNominal)
        let result = "\(String(format:"%.2f",сalculatingNominal))"
        
        self.presenter?.onOutputReceive(result)
    }
}
