//
//  RoundedCorner.swift
//  CountryInfo
//
//  Created by Joseph Mennemeier on 1/2/17.
//  Copyright © 2017 Joseph Mennemeier. All rights reserved.
//

import UIKit

class RoundedCorner: UILabel {

    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
    }
}
