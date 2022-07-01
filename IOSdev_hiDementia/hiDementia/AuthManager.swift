//
//  AuthManager.swift
//  hiDementia
//
//  Created by xcode on 27.11.2021.
//

import FirebaseAuth
import Foundation

protocol AuthProtocol: AnyObject {
    var verificationId: String? { get }
    func verifyPhone(_ phoneNumber: String, completion: @escaping (Bool) -> Void)
    func verifyCode(_ smsCode: String, completion: @escaping (Bool) -> Void)
}

final class AuthManager: AuthProtocol {
    
    static let shared: AuthProtocol = AuthManager()
    
    var verificationId: String?
    
    func verifyPhone(_ phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(
            phoneNumber,
            uiDelegate: nil
        ) { [weak self] verificationId, error in
            // DEBUG
            completion(true)
//            guard let verificationId = verificationId,
//                  error == nil
//            else {
//                completion(false)
//                print("false")
//                return
//            }
//            self?.verificationId = verificationId
//            completion(true)
//            print("true")
        }
    }
    
    func verifyCode(_ smsCode: String, completion: @escaping (Bool) -> Void) {
        // DEBUG
        completion(true)
//        guard let verificationId = self.verificationId else {
//            completion(false)
//            return
//        }
//
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationId,
//            verificationCode: smsCode
//        )
//
//        Auth.auth().signIn(with: credential) { result, error in
//            guard result != nil,
//                  error == nil
//            else {
//                return
//            }
//            completion(true)
//        }
    }
}
