//
//  CheckerServiceTests.swift
//  CheckerServiceTests
//
//  Created by DmitriiG on 13.03.2023.
//

import Foundation
import XCTest
@testable import Industrial


final class CheckerServiceTests: XCTestCase {

    let controller = LoginViewControllerStub()
    let realmModel = RealmModelStub()
    let checkerServiceTest = CheckerService()
    let loginExist = "gilep"
    let passwordExist = "123456"
    let loginFake = "ggggg"
    let passwordFake = "111111"
    
    override func setUpWithError() throws {
        checkerServiceTest.controller = controller
        checkerServiceTest.realmModel = realmModel
    }

    func testSignUPEmptyLogin() {
        let loginEmpty = ""
        let password = passwordFake
        checkerServiceTest.signUp(login: loginEmpty, password: password)
        XCTAssertEqual(controller.callAlertViewSignUpFailureCalled, true)
        XCTAssertEqual(controller.callAlertViewSignUpSuccessCalled, false)
        XCTAssertEqual(controller.callAlertViewCredentialFailureCalled, false)
        XCTAssertEqual(controller.goToProfilePageCalled, false)
    }
    
    func testSignUPEmptyPassword() {
        let login = loginFake
        let passwordEmpty = ""
        checkerServiceTest.signUp(login: login, password: passwordEmpty)
        XCTAssertEqual(controller.callAlertViewSignUpFailureCalled, true)
        XCTAssertEqual(controller.callAlertViewSignUpSuccessCalled, false)
        XCTAssertEqual(controller.goToProfilePageCalled, false)
    }
    
    func testSignUpLoginNotUnique() {
        checkerServiceTest.signUp(login: loginExist, password: passwordExist)
        XCTAssertEqual(controller.callAlertViewSignUpFailureCalled, true)
        XCTAssertEqual(controller.callAlertViewSignUpSuccessCalled, false)
        XCTAssertEqual(realmModel.checkLoginForUniqueCalled, true)
    }
    
    func testSignUpLoginUnique() {
        checkerServiceTest.signUp(login: loginFake, password: passwordFake)
        XCTAssertEqual(controller.callAlertViewSignUpFailureCalled, false)
        XCTAssertEqual(controller.callAlertViewSignUpSuccessCalled, true)
        XCTAssertEqual(realmModel.checkLoginForUniqueCalled, true)
        XCTAssertEqual(realmModel.addProfileToRealmCalled, true)
        XCTAssertEqual(realmModel.toogleStatusToLogInCalled, true)
    }
    
    func testCredentialsEmptyLogin() {
        let loginEmpty = ""
        let password = passwordFake
        checkerServiceTest.checkCredentials(login: loginEmpty, password: password)
        XCTAssertEqual(controller.callAlertViewCredentialFailureCalled, true)
        XCTAssertEqual(controller.goToProfilePageCalled, false)
    }
    
    func testCredentialsEmptyPassword() {
        let login = loginFake
        let passwordEmpty = ""
        checkerServiceTest.checkCredentials(login: login, password: passwordEmpty)
        XCTAssertEqual(controller.callAlertViewCredentialFailureCalled, true)
        XCTAssertEqual(controller.goToProfilePageCalled, false)
    }
    
    func testCredentialsAuthorizationSuccess() {
        checkerServiceTest.checkCredentials(login: loginExist, password: passwordExist)
        XCTAssertEqual(controller.goToProfilePageCalled, true)
        XCTAssertEqual(realmModel.toogleStatusToLogInCalled, true)
    }
    
    func testCredentialsAuthorizationfailure() {
        checkerServiceTest.checkCredentials(login: loginFake, password: passwordFake)
        XCTAssertEqual(controller.callAlertViewCredentialFailureCalled, true)
        XCTAssertEqual(controller.goToProfilePageCalled, false)
    }
    
}

final class LoginViewControllerStub: CheckerServiceControllerProtocol {


    var callAlertViewSignUpFailureCalled = false
    var callAlertViewSignUpSuccessCalled = false
    var callAlertViewCredentialFailureCalled = false
    var goToProfilePageCalled = false
    
    func callAlertViewSignUpFailure() {
        callAlertViewSignUpFailureCalled = true
    }
    
    func callAlertViewSignUpSuccess() {
        callAlertViewSignUpSuccessCalled = true
    }
    func callAlertViewCredentialFailure() {
        callAlertViewCredentialFailureCalled = true
    }
    func goToProfilePage() {
        goToProfilePageCalled = true
    }
    
}

final class RealmModelStub: CheckerServiceRealmModelProtocol {

    var checkLoginForUniqueCalled = false
    var addProfileToRealmCalled = false
    
    var checkAuthorizationWithRealmCalled = false
    var toogleStatusToLogInCalled = false
    
    func checkLoginForUnique(login: String) -> Bool {
        checkLoginForUniqueCalled = true
        var isUnique = true
        if login == "gilep" {
            isUnique = false
        }
        return isUnique
    }
    
    func addProfileToRealm(login: String, password: String) {
        addProfileToRealmCalled = true
    }
    
    func checkAuthorizationWithRealm(login: String, password: String) -> Bool {
        checkAuthorizationWithRealmCalled = true
        var isPassed = false
        if login == "gilep", password == "123456" {
            isPassed = true
        }
        return isPassed
    }
    
    func toogleStatusToLogIn(login: String) {
        toogleStatusToLogInCalled = true
    }
}
