//
//  CalculationText.swift
//  Rates
//
//  Created by Vasiliy Chistyakov on 07.05.2023.
//

import Foundation

enum MainCalculationSource {
    case input
    case output
}

struct MainCalculation {
    let text: String
    let picked: String
    var valute: Double?
    let value: Double?
    let nominal: Double?
    let rates: MainExchangeRates
    let dataSource: MainCalculationSource
    
    init(text: String, picked: String, rates: MainExchangeRates, source: MainCalculationSource) {
        self.text = text
        self.picked = picked
        self.rates = rates
        self.dataSource = source
        
        let currentRates = rates.valute[picked]
        self.value = currentRates?.value
        self.nominal = Double(currentRates?.nominal ?? 0)
        self.valute = Double(text)
    }
}

struct MainCalculationRecive {
    let sum: String
    let source: MainCalculationSource
}
