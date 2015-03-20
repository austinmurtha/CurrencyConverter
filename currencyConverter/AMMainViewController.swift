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
    let baseRate = UISegmentedControl(items: CurrencyTypes.allValues())
    let foreignRate = UISegmentedControl(items: CurrencyTypes.allValues())
    
    let convertedOutput = UITextField()
    
    var baseCurrencySelection = CurrencyTypes.USDollar
    var foreignCurrencySelection = CurrencyTypes.EuropeanEuro
    var id: String?
    var from: String?
    var to: String?
    var val: Int?
    var exchangeRate: Double!

    
    
    
enum CurrencyTypes: String {
        case
        USDollar = "USD",
        EuropeanEuro = "EUR",
        BritishPound = "GBP",
        JapaneseYen = "JPY"
        
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
        baseRate.addTarget(self, action: "baseCurrencyChange:", forControlEvents: .ValueChanged)
        foreignRate.addTarget(self, action: "convertedCurrency:", forControlEvents: .ValueChanged)
        addConversionInputField()
        addBaseRate()
        addForeignRate()
        returnOutput()
        performConversion()
        
        //add more options
    }
    
    func getCurrencyData(#baseCurrency: String, foreignCurrency: String, completion: ((result:Double?) -> Void)!)  {
        //http://www.freecurrencyconverterapi.com/api/v3/convert?q=USD_PHP
        
        let defaultURL = "http://www.freecurrencyconverterapi.com/api/v3/convert?q="
        let convertToRates = baseCurrency + "_" + foreignCurrency
        let completeURL = defaultURL + convertToRates
        
        if let URL = NSURL(string: completeURL) {
            NSURLSession.sharedSession().dataTaskWithURL(URL) { data, response, error in
                if ((data) != nil) {
                    let jsonDictionary:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    
                    if let results = jsonDictionary["results"] as? NSDictionary {
                        if let queryResults = results[convertToRates] as? NSDictionary{
                            if let exchangeRate = queryResults["val"] as? Double{
                                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        completion(result: exchangeRate)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    completion(result: nil)
                }
                
                if ((error) != nil){
                    completion(result: nil)
                }
                
                }.resume()
            }
    }
    
    
    func performConversion(){
        //1. Amount
        let inputAmount = conversionInput.text
        if baseRate.selectedSegmentIndex == foreignRate.selectedSegmentIndex {
            convertedOutput.text = conversionInput.text
            println("Same value selected")
        }
        else {
            getCurrencyData(baseCurrency: baseCurrencySelection.rawValue, foreignCurrency: foreignCurrencySelection.rawValue) { (result) -> Void in
                println(self.baseCurrencySelection.rawValue)
                println(self.foreignCurrencySelection.rawValue)
                println(self.conversionInput.text)
                if let exchangeRate = result {
                    let localAmount = (self.conversionInput.text as NSString).doubleValue
                    let finalAmount = localAmount * exchangeRate
                    self.convertedOutput.text = String(format:"%.3f", finalAmount)
                    println("In currenctData \(exchangeRate)")
                }
            }

        }
        //2. Rate: Parameters ( FROM AND TO)
    }
    
    func addConversionInputField(){
        conversionInput.frame = CGRectZero
        conversionInput.layer.borderWidth = 1.0
        conversionInput.layer.borderColor = UIColor.blackColor().CGColor
        conversionInput.text = String(format: "%0.2f", 1.0)
        conversionInput.textAlignment = .Right
        conversionInput.layer.cornerRadius = 5.0
        conversionInput.sizeToFit()
        conversionInput.layer.sublayerTransform = CATransform3DMakeTranslation(-10, 0, 0)
        
        view.addSubview(conversionInput)
        
    }
    
    func addBaseRate(){
        //convertFromRates.frame = CGRectZero
        
        baseRate.frame = CGRectZero
        baseRate.selectedSegmentIndex = 0
        baseRate.tintColor = UIColor.blackColor()
        view.addSubview(baseRate)
        
    }
    
    func addForeignRate(){
        
        foreignRate.selectedSegmentIndex = 1
        view.addSubview(foreignRate)
    }
    
    func returnOutput(){
        
        convertedOutput.text = "Output"
        view.addSubview(convertedOutput)
    }

    
    
    func baseCurrencyChange(sender: UISegmentedControl){
        //Determine which currency was selected.
        switch sender.selectedSegmentIndex {
         case 0:
            baseCurrencySelection = CurrencyTypes.USDollar
        case 1:
            baseCurrencySelection = CurrencyTypes.EuropeanEuro
            
        case 2:
            baseCurrencySelection = CurrencyTypes.BritishPound
            
        case 3:
            baseCurrencySelection = CurrencyTypes.JapaneseYen
            
        default:
            //Add popup message on screen that no value was selected
            println("Please try again")
        }
        
        //now that we have stored the selected f/x currency, we can printout the value that is loaded, irrespective of the switch statement.
        //the switch should just work.
        //enums are structs (mini class). They are not String but they have a rawValue which can be of Type String. Our enum has String RawValues.
        //We need to get to the rawValue before we print to console.
        println(baseCurrencySelection.rawValue)
        performConversion()
        println("base conversion performed")
        
    }
    
    func convertedCurrency(sender: UISegmentedControl){
        //Determine which currency was selected.
        switch sender.selectedSegmentIndex {
        case 0:
            foreignCurrencySelection = CurrencyTypes.USDollar
            
        case 1:
            foreignCurrencySelection = CurrencyTypes.EuropeanEuro
            //convertedOutput.text = conversionInput * multipierRate
            
        case 2:
            foreignCurrencySelection = CurrencyTypes.BritishPound
            
        case 3:
            foreignCurrencySelection = CurrencyTypes.JapaneseYen
        default:
            //Add popup message on screen that no value was selected
            println("Please try again")
        }
        
        //now that we have stored the selected f/x currency, we can printout the value that is loaded, irrespective of the switch statement.
        //the switch should just work.
        //enums are structs (mini class). They are not String but they have a rawValue which can be of Type String. Our enum has String RawValues.
        //We need to get to the rawValue before we print to console.
        println(foreignCurrencySelection.rawValue)
        performConversion()
        println("Foreign Conversion performed")
        
    }
    
    override func viewDidLayoutSubviews() {
        var minFrame = min(view.frame.width, view.frame.height)
        //var conversionInputFrame = conversionInput(view.frame.width, view.frame.height)
        
        conversionInput.frame = CGRectMake(0, 0, minFrame * 0.60, minFrame * 0.10)
        conversionInput.center.x = view.center.x
        conversionInput.center.y = minFrame * 0.15
        conversionInput.frame.maxY
        
        baseRate.frame = CGRectMake(25, 25, minFrame * 0.60, minFrame * 0.10)
        baseRate.center.x = view.center.x
        baseRate.center.y =  conversionInput.center.y + minFrame * 0.20
    
        foreignRate.frame = CGRectMake(25, 25, minFrame * 0.60, minFrame * 0.10)
        foreignRate.center.x = view.center.x
        foreignRate.center.y = minFrame * 0.60
        
        convertedOutput.frame = CGRectMake(65, 65, minFrame * 0.60, minFrame * 0.10)
        convertedOutput.center.x = view.center.x
        convertedOutput.center.y = minFrame * 0.70
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        conversionInput.resignFirstResponder()
    }

}

