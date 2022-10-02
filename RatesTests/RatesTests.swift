//
//  RatesTests.swift
//  RatesTests
//
//  Created by Василий  on 18.09.2022.
//

import XCTest
@testable import Rates

// MARK: - MockView
class MockView: MainViewProtocol {
    var modelTest: RatesModel?
    var nameTest: String?
    var inputTest: String?
    var outputTest: String?
    
    func showCurrency(_ showList: RatesModel?) {
        self.modelTest = showList
    }
    
    func showUsername(_ username: String) {
        self.nameTest = username
    }
    
    func showInput(_ text: String) {
        self.inputTest = text
    }
    
    func showOutput(_ text: String) {
        self.outputTest = text
    }
}

// MARK: - MockNetworkService
class MockNetworkService: APIService {
    var model: RatesModel!
    
    convenience init(model: RatesModel) {
        self.init()
        self.model = model
    }
        
    func fetchRates(urlJson: String, complitionHandler: @escaping (RatesModel) -> Void) {
        if let model = model {
            complitionHandler(model)
        } else {
//            let error = NSError(domain: "", code: 0, userInfo: nil)
//            complitionHandler(error)
        }
    }
}

class RatesTests: XCTestCase {
    var view: MockView!
    var netowkService: APIService!
    var model: RatesModel!

    override func setUp() {
        
    }
    
    override func tearDown() {
        view = nil
        netowkService = nil
    }
    
    func testModulesNotNill() {
        view = MockView()
        XCTAssertNotNil(view, "view is not nil")
    }
    
    func testGetRates() {
        let urlJson = "https://www.cbr-xml-daily.ru/daily_json.js"
        
        let valute = ["Foo": Valute(
            id: "Foo",
            numCode: "Bar",
            charCode: "Baz",
            nominal: 1,
            name: "quux",
            value: 2,
            previous: 3)]
        let _model = RatesModel(
            date: "Foo",
            previousDate: "Bar",
            previousURL: "Baz",
            timestamp: "quux",
            valute: valute)
        
        model = _model
        view = MockView()
        netowkService = MockNetworkService(model: _model)
        
        var catchModel: RatesModel!
        
        netowkService.fetchRates(urlJson: urlJson) { result in
            catchModel = result
        }
        
        XCTAssertNotEqual(catchModel.valute.keys.count, 0)
        XCTAssertEqual(catchModel.valute.keys.count, valute.count)
    }
}


