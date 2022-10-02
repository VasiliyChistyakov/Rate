//
//  RatesModel.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 15.08.2021.
//

import Foundation

// MARK: - RatesModel
struct RatesModel: Codable {
	let date: String
	let previousDate: String
	let previousURL: String
	let timestamp: String
	let valute: [String: Valute]
	
	enum CodingKeys: String, CodingKey {
		case date = "Date"
		case previousDate = "PreviousDate"
		case previousURL = "PreviousURL"
		case timestamp = "Timestamp"
		case valute = "Valute"
	}
}

// MARK: - Valute
struct Valute: Codable {
	let id: String
	let numCode: String
	let charCode: String
	let nominal: Int
	let name: String
	let value: Double
	let previous: Double
	
	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case numCode = "NumCode"
		case charCode = "CharCode"
		case nominal = "Nominal"
		case name = "Name"
		case value = "Value"
		case previous = "Previous"
	}
}




