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
   static private func buildFrom(_ scene: UIWindowScene?) -> DependencyResolver {
        let app = DependencyResolver(scene: scene)
        return app
    }
    
	static func CreateMainModule(_ scene: UIWindowScene?) -> UIViewController? {
        let resolver = buildFrom(scene)

        let view = resolver.view as? MainViewController
        let presenter = resolver.presenter
        let interactor = resolver.interactor
        let wireframe = resolver.wireframe
        
        view?.presenter = presenter
		presenter.view = view
		presenter.interactor = interactor
		presenter.wireframe = wireframe
		interactor.presenter = presenter
		
        return view ?? nil
	}
}
