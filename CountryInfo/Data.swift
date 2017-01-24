//
//  Data.swift
//  CountryInfo
//
//  Created by Joseph Mennemeier on 12/13/16.
//  Copyright © 2016 Joseph Mennemeier. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

// Struct data for the View Countroller and TableView
struct Country  {
    var name: String = ""
    var capital: String = ""
    var subregion: String = ""
    var callingCode: String = ""
    var timeZone: String = ""
    var currency: String = ""
}

// Variables for UserDefaults and 3D Touch
var savedName = ""
var savedCallingCode = ""
var savedCurrency = ""


