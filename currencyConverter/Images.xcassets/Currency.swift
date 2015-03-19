//
//  Currency.swift
//  currencyConverter
//
//  Created by Austin Murtha on 3/14/15.
//  Copyright (c) 2015 AustinMurtha. All rights reserved.
//

import Foundation

struct Currency {
    var id: String?
    var from: String?
    var to: String?
    var val: Int?
    
    init(currencyDictionary: NSDictionary) {
        let convertedCurrency = currencyDictionary["results"] as NSDictionary
        
        
        
    }
}