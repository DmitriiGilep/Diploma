//
//  LocalAuthorizationService.swift
//  Industrial
//
//  Created by DmitriiG on 22.03.2023.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {
    
    enum BiometricType {
        case none
        case touchID
        case faceID
        case unknown
    }
    
    enum BiometricError {
        case authenticationFailed
        case userCancel
        case userFallback
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case unknown
        
        var errorDescriprion: String? {
            switch self {
            case .authenticationFailed:
                return "authFailed".localizable
            case .biometryNotAvailable:
                return "authUnavailable".localizable
            case .biometryNotEnrolled:
                return "authIsNotSetUp".localizable
            case .userCancel:
                return "authCancellded".localizable
            case .userFallback:
                return "goingToPassword".localizable
            case .biometryLockout:
                return "authIsLocked".localizable
            case .unknown:
                return "authCannotConfigured".localizable
            }
        }
    }
    
    private let context = LAContext()
    
    private let policy: LAPolicy
    private let localisedReason: String
    private var error: NSError?
    
    init(
        policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
        localisedReason: String = "verifyIdentity".localizable,
        localisedFallbackTitle: String = "enterPassword".localizable
    ) {
        self.policy = policy
        self.localisedReason = localisedReason
        context.localizedFallbackTitle = localisedFallbackTitle
//        context.localizedCancelTitle = "touchMeNot".localizable
    }
    
    func canEvaluate(
        completion: (Bool, BiometricType, BiometricError?) -> Void
    ) {
        guard context.canEvaluatePolicy(policy, error: &error) else {
            let type = biometricType(for: context.biometryType)
            guard let error = error else {
                return completion(false, type, nil)
            }
            return completion(false, type, biometricError(from: error))
        }
        return completion(true, biometricType(for: context.biometryType), nil)
    }
    
    func evaluate(
        completion: @escaping(Bool, BiometricError?) -> Void
    ) {
        context.evaluatePolicy(policy, localizedReason: localisedReason) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    guard let error = error else {
                        return completion(false, nil)
                    }
                    completion(false, self?.biometricError(from: error as NSError))
                }
            }
        }
    }
    
    private func biometricType(for laType: LABiometryType) -> BiometricType {
        let type: BiometricType
        switch laType {
        case LABiometryType.none:
            type = .none
        case LABiometryType.touchID:
            type = .touchID
        case LABiometryType.faceID:
            type = .faceID
        default:
            type = .faceID
        }
        return type
    }
    
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        return error
    }
    
}
