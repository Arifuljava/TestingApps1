//
//  UserModel.swift
//  TestingApps
//
//  Created by sang on 13/5/24.
//

import Foundation
import Foundation

class UserModel {
    private var _element: String?
    private var _name: String?
    private var _email: String?
    private var _password: String?
    private var _number: String?
    private var _uuid: UUID?
    private var _time: Date?

    var element: String? {
        get {
            return _element
        }
        set {
            _element = newValue
        }
    }

    var name: String? {
        get {
            return _name
        }
        set {
            if let newName = newValue, !newName.isEmpty {
                _name = newName
            } else {
                _name = nil
            }
        }
    }

    var email: String? {
        get {
            return _email
        }
        set {
            if let newEmail = newValue, isValidEmail(newEmail) {
                _email = newEmail
            } else {
                _email = nil
            }
        }
    }

    var password: String? {
        get {
            return _password
        }
        set {
            if let newPassword = newValue, newPassword.count >= 8 {
                _password = newPassword
            } else {
                _password = nil
            }
        }
    }

    var number: String? {
        get {
            return _number
        }
        set {
            _number = newValue
        }
    }

    var uuid: UUID? {
        get {
            return _uuid
        }
        set {
            _uuid = newValue
        }
    }

    var time: Date? {
        get {
            return _time
        }
        set {
            _time = newValue
        }
    }

    init(element: String? = nil, name: String? = nil, email: String? = nil, password: String? = nil, number: String? = nil, uuid: UUID? = nil, time: Date? = nil) {
        self._element = element
        self._name = name
        self._email = email
        self._password = password
        self._number = number
        self._uuid = uuid
        self._time = time
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
