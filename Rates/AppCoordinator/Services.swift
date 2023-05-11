//
//  Services.swift
//  Rates
//
//  Created by Vasiliy Chistyakov on 07.05.2023.
//

import Foundation

protocol ServicesAssemblerProtocol {
    func register<Service>(singletonInstance: Service)
    func register<Service>(factory: @escaping () -> Service)
    func lazyRegister<Service>(
        id: ObjectIdentifier,
        factory: @escaping () -> Service
    )
    func inject<Service>() -> Service
}

 protocol ServiceLocatorProtocol {
    func registerServices(serviceLocator ass: ServicesAssemblerProtocol)
}

final class ServicesAssembler: ServicesAssemblerProtocol {
    static var sharedServices: ServicesAssembler = {
        let shared = ServicesAssembler()
        return shared
    }()

    init() {}

    // MARK: Registration

    #if false
    // somehow templated method doesn't work here, so need to copy methods
    // for every parameter needed
    public func register<Service, T>(factory: @escaping (T) -> Service) {
        let serviceId = ObjectIdentifier(Service.self)
        registry[serviceId] = factory
    }
    #endif

    public func register<Service>(factory: @escaping () -> Service) {
        let serviceId = ObjectIdentifier(Service.self)
        registry[serviceId] = factory
    }

    public func lazyRegister<Service>(
        id: ObjectIdentifier,
        factory: @escaping () -> Service
    ) {
        lazyIDs.insert(id)
        registry[id] = factory
    }

    public func register<Service>(singletonInstance: Service) {
        let serviceId = ObjectIdentifier(Service.self)
        registry[serviceId] = singletonInstance
    }

    public static func lazyRegister<Service>(factory: @escaping () -> Service) {
        let serviceId = ObjectIdentifier(Service.self)
        sharedServices.lazyRegister(id: serviceId, factory: factory)
    }

    public static func register<Service>(factory: @escaping () -> Service) {
        sharedServices.register(factory: factory)
    }

    public static func register<Service>(singletonInstance: Service) {
        sharedServices.register(singletonInstance: singletonInstance)
    }

    public func registerModules(modules: [ServiceLocatorProtocol]) {
        modules.forEach { $0.registerServices(serviceLocator: self) }
    }

    public static func registerModules(modules: [ServiceLocatorProtocol]) {
        sharedServices.registerModules(modules: modules)
    }

    // MARK: Injection

    public static func inject<Service>() -> Service {
        return sharedServices.inject()
    }

    public func inject<Service>() -> Service {
        let serviceId = ObjectIdentifier(Service.self)
        if let factory = registry[serviceId] as? () -> Service {
            let instance = factory()
            if lazyIDs.contains(serviceId) {
                lazyIDs.remove(serviceId)
                registry[serviceId] = instance
            }
            return instance
        } else if let singletonInstance = registry[serviceId] as? Service {
            return singletonInstance
        } else {
            fatalError("No registered entry for \(Service.self)")
        }
    }

    // MARK: private

    private var lazyIDs = Set<ObjectIdentifier>()
    private var registry = [ObjectIdentifier: Any]()
}

