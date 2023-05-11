//
//  APIService.swift
//  Valuta
//
//  Created by sot on 12.09.2022.
//

import Foundation

protocol APIService {
	// MARK: RatesInfo
	func fetchRates(urlJson: String, complitionHandler: @escaping (Result<MainExchangeRates,Error>) -> Void)
}
