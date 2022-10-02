//
//  MainWireframe.swift
//  Valuta
//
//  Created by sot on 12.09.2022.
//

import Foundation
import UIKit

final class MainWireframe: MainWireframeProtocol {
	// MARK: - Static Methods
	static func CreateMainModule() -> UIViewController {
		let view = MainViewController()
		let presenter: MainPresenterProtocol & MainInteractorOutputProtocol = MainPresenter()
		let interactor: MainInteractorInputProtocol = MainInteractor()
		let wireframe: MainWireframeProtocol = MainWireframe()
		
		view.presenter = presenter
		presenter.view = view
		presenter.interactor = interactor
		presenter.wireframe = wireframe
		interactor.presenter = presenter
		
		return view
	}
}
