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
		NetworkingManager.shared.fetchRates(urlJson: urlJson) { result in
            switch result {
            case .success(let success):
                self.presenter?.onCurrencyReceive(success)
            case .failure(let failure):
                return
            }
		}
	}
    
    func setCalculation(_ date: MainCalculation) {
        guard
            let valute = date.valute,
            let nominal = date.nominal,
            let value = date.value
        else { return }
        
        switch date.dataSource {
        case .input:
            let valueRates = valute * value
            let сalculatingNominal = valueRates / Double(nominal)
            self.setCalculatingDate(сalculatingNominal, source: date.dataSource)
        case .output:
            let valueRates = valute / value
            let сalculatingNominal = valueRates * Double(nominal)
            self.setCalculatingDate(сalculatingNominal, source: date.dataSource)
        }
    }
    
    private func setCalculatingDate(_ сalculatingNominal: Double, source: MainCalculationSource) {
        let result = "\(String(format:"%.2f",сalculatingNominal))"
        self.presenter?.onRecevie(MainCalculationRecive(sum: result, source: source))
    }
}
