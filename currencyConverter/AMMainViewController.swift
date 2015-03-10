//
//  ViewController.swift
//  currencyConverter
//
//  Created by Austin Murtha on 3/9/15.
//  Copyright (c) 2015 AustinMurtha. All rights reserved.
//

import UIKit

class AMMainViewController: UIViewController {
    
    let conversionInput = UITextField()
    let convertFromRates = UISegmentedControl(items: CurrencyTypes.allValues())
    let convertToRates = UISegmentedControl(items: CurrencyTypes.allValues())
    let convertedInput = UILabel()
    let currencyAPI = NSURL(string: "http://www.freecurrencyconverterapi.com/api/v3/convert?q=USD_PHP,PHP_USD")!

    enum CurrencyTypes: String {
        case
        USDollar = "USD",
        EuropeanEuro = "EUR",
        BritishPound = "GPB",
        JapaneseYen = "YEN"
        
        static func allValues() -> [String] {
            return [USDollar.rawValue,
                EuropeanEuro.rawValue,
                BritishPound.rawValue,
                JapaneseYen.rawValue]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        addConversionInputField()
        addCurrencyOptions()
        
        //add more options
        convertFromRates.frame = CGRectZero
        convertFromRates.selectedSegmentIndex = 0
        convertFromRates.tintColor = UIColor.blackColor()
        convertFromRates.addTarget(self, action: "baseCurrencyChange:", forControlEvents: .ValueChanged)
        
    }
    
    func addConversionInputField(){
        conversionInput.frame = CGRectZero
        conversionInput.layer.borderWidth = 1.0
        conversionInput.layer.borderColor = UIColor.blackColor().CGColor
        conversionInput.text = "Hello"
        conversionInput.textAlignment = .Right
        conversionInput.layer.cornerRadius = 5.0
        conversionInput.sizeToFit()
        conversionInput.layer.sublayerTransform = CATransform3DMakeTranslation(-10, 0, 0)
        
        view.addSubview(conversionInput)
        
    }
    
    func addCurrencyOptions(){
        //convertFromRates.frame = CGRectZero
        
        convertedInput.text = "input"
        
        view.addSubview(convertFromRates)
        view.addSubview(convertToRates)
        view.addSubview(convertedInput)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        var minFrame = min(view.frame.width, view.frame.height)
        //var conversionInputFrame = conversionInput(view.frame.width, view.frame.height)
        
        conversionInput.frame = CGRectMake(0, 0, minFrame * 0.60, minFrame * 0.10)
        conversionInput.center.x = view.center.x
        conversionInput.center.y = minFrame * 0.15
        conversionInput.frame.maxY
        
        convertFromRates.frame = CGRectMake(25, 25, minFrame * 0.60, minFrame * 0.10)
        convertFromRates.center.x = view.center.x
        convertFromRates.center.y = minFrame * 0.50
    
        convertToRates.frame = CGRectMake(25, 25, minFrame * 0.60, minFrame * 0.10)
        convertToRates.center.x = view.center.x
        convertToRates.center.y = minFrame * 0.60
        
        convertedInput.frame = CGRectMake(65, 65, minFrame * 0.60, minFrame * 0.10)
        convertedInput.center.x = view.center.x
        convertedInput.center.y = minFrame * 0.70
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        conversionInput.resignFirstResponder()
    }

}

