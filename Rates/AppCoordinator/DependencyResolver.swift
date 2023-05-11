//
//  DependencyResolver.swift
//  Rates
//
//  Created by Vasiliy Chistyakov on 08.05.2023.
//

import Foundation
import UIKit

protocol DependencyResolverProtocol {
    var view: MainViewProtocol { get }
    var presenter: MainPresenterProtocol & MainInteractorOutputProtocol { get }
    var interactor: MainInteractorInputProtocol { get }
    var wireframe: MainWireframeProtocol { get }
}

final class DependencyResolver {
    let scene: UIWindowScene?
    init(scene: UIWindowScene?) {
        self.scene = scene
    }
}

extension DependencyResolver: DependencyResolverProtocol {
    var view: MainViewProtocol {
        ServicesAssembler.inject()
    }
    
    var presenter: MainInteractorOutputProtocol & MainPresenterProtocol {
        ServicesAssembler.inject()
    }
    
    var interactor: MainInteractorInputProtocol {
        ServicesAssembler.inject()
    }
    
    var wireframe: MainWireframeProtocol {
        ServicesAssembler.inject()
    }
}
