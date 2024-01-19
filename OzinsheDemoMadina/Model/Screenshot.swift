//
//  Screenshot.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 18.01.2024.
//

import Foundation
import SwiftyJSON

class Screenshot{
    public var id: Int = 0
    public var link: String = ""
    
    init(json: JSON){
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["link"].string {
            self.link = temp
        }
    }
}
