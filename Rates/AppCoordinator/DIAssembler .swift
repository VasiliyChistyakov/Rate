//
//  DIAssembler .swift
//  Rates
//
//  Created by Vasiliy Chistyakov on 08.05.2023.
//

import Foundation
import UIKit

final class DIAssembler { }

extension DIAssembler: AppDelegateProtocol {
    
    func description() -> String {
        return "DIAssembler"
    }
    
    private func register(_ interactor: MainInteractor) {
        ServicesAssembler.register(singletonInstance: interactor as MainInteractorInputProtocol)
    }
    
    private func register(_ presenter: MainPresenter) {
        ServicesAssembler.register(singletonInstance: presenter as MainInteractorOutputProtocol & MainPresenterProtocol)
    }
    
    private func register(_ wireframe: MainWireframe) {
        ServicesAssembler.register(singletonInstance: wireframe as MainWireframeProtocol)
    }
    
    private func register(_ view: MainViewController) {
        ServicesAssembler.register(singletonInstance: view as MainViewProtocol)
    }
    
    func initModule(application: UIApplication, options: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let view = MainViewController()
        let wireframe = MainWireframe()
        
        register(view)
        register(presenter)
        register(interactor)
        register(wireframe)
        
        return true
    }
}
