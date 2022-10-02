//
//  ShapeHedearCell.swift
//  Valuta
//
//  Created by Василий  on 12.03.2022.
//

import Foundation
import UIKit

final class ShapeCell: UITableViewCell {
	// MARK: - Static Properties
		static let cellId = "ShapeCell"
	
	// MARK: - Public Properties
	var nameValutaLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.numberOfLines = 0
		label.font = UIFont.boldSystemFont(ofSize: 18)
		return label
	}()
	
	var charCodeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 18, weight: .light)
		return label
	}()
	
	var previousLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.textColor = .green
		label.font = UIFont.systemFont(ofSize: 18)
		return label
	}()
	
	var valueLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 18)
		return label
	}()
	
	
	// MARK: - Lifecycle
		override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
			super.init(style: style, reuseIdentifier: reuseIdentifier)
			setupUI()
		}
	
		required init?(coder: NSCoder) {
			super.init(coder: coder)
			setupUI()
		}
	
	// MARK: - Private Methods
	private func setupUI() {
		addSubviews([nameValutaLabel, charCodeLabel, previousLabel, valueLabel])
		let widthSize = UIScreen.main.bounds.width
		print("widthSize: \(widthSize)")
	
		NSLayoutConstraint.activate([
			nameValutaLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
			nameValutaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			nameValutaLabel.widthAnchor.constraint(equalToConstant: widthSize - 50),
			
			charCodeLabel.topAnchor.constraint(equalTo: nameValutaLabel.bottomAnchor, constant: 15),
			charCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			charCodeLabel.widthAnchor.constraint(equalToConstant:  widthSize - 50),
			
			previousLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
			previousLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
			
			valueLabel.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 15),
			valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
		])
	}
	
}

