//
//  Urls.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 18.01.2024.
//

import Foundation

class Urls{
    static let BASE_URL = "http://api.ozinshe.com/core/V1/"
    static let SIGN_IN_URL = "http://api.ozinshe.com/auth/V1/signin"
    static let FAVORITE_URL = BASE_URL + "favorite/"
    static let SIGN_UP_URL = "http://api.ozinshe.com/auth/V1/signup"
    static let CHANGE_PASSWORD_URL = BASE_URL + "user/profile/changePassword"
    static let PROFILE_UPDATE_URL = BASE_URL + "user/profile/"
    static let PROFILE_GET_URL = BASE_URL + "user/profile"
}
