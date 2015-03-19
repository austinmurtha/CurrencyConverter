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
    
    let convertedOutput = UILabel()
    
    var selectedCurrentCurrencyType = CurrencyTypes.USDollar
    var selectedConversionCurrencyType = CurrencyTypes.EuropeanEuro
    var id: String?
    var from: String?
    var to: String?
    var val: Int?
    var exchangeRate: Double!

    
    
    
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
        convertToRates.addTarget(self, action: "baseCurrencyChange:", forControlEvents: .ValueChanged)
        convertFromRates.addTarget(self, action: "convertedCurrency:", forControlEvents: .ValueChanged)
        addConversionInputField()
        addCurrentRate()
        addReturnrate()
        returnOutput()
        getCurrencyData()
        println(self.exchangeRate)
        
        //add more options
    }
    
    func getCurrencyData() {
        //http://www.freecurrencyconverterapi.com/api/v3/convert?q=USD_PHP
        let convertToRates = "convert?q=USD_EUR"
        let baseURL = NSURL(string: "http://www.freecurrencyconverterapi.com/api/v3/")
        let currencyURL = NSURL(string: "\(convertToRates)", relativeToURL: baseURL)
        let sharedSession = NSURLSession.sharedSession()
        println(sharedSession)
        println(currencyURL)
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(currencyURL!, completionHandler: { ( location: NSURL!, response:NSURLResponse!, error: NSError!) -> Void in
        let dataObject = NSData(contentsOfURL: location!)
            println(dataObject)
        let currencyDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
            if let results = currencyDictionary["results"] as? NSDictionary {
            println(results)
                if let results2 = results["USD_EUR"] as? NSDictionary {
                    println(results2)
                    if let multiplierRate = results2["val"] as? Double{
                         dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.exchangeRate = multiplierRate
                            println(self.exchangeRate)
                        })
                    }
                }
                
            }
            
        })
        downloadTask.resume()
    }
    
    
//    func getAsynchData() -> NSData {
//        var dataOutput : NSData
//        let url:NSURL = NSURL(string:"some url")
//        let request:NSURLRequest = NSURLRequest(URL:url)
//        let queue:NSOperationQueue = NSOperationQueue()
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            /* this next line gives the below error */
//            dataOutput = data
//        })
//        return dataOutput
//    }
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
    
    func addReturnrate(){
        
        
        view.addSubview(convertToRates)
    }
    
    func returnOutput(){
        
        convertedOutput.text = "Output"
        view.addSubview(convertedOutput)
    }
    
    func addCurrentRate(){
        //convertFromRates.frame = CGRectZero
        
        convertFromRates.frame = CGRectZero
        convertFromRates.selectedSegmentIndex = 0
        convertFromRates.tintColor = UIColor.blackColor()
        view.addSubview(convertFromRates)
        
    }
    
    
    func baseCurrencyChange(sender: UISegmentedControl){
        //Determine which currency was selected.
        switch sender.selectedSegmentIndex {
         case 0:
            selectedCurrentCurrencyType = CurrencyTypes.USDollar
            
        case 1:
            selectedCurrentCurrencyType = CurrencyTypes.EuropeanEuro
            
        case 2:
            selectedCurrentCurrencyType = CurrencyTypes.BritishPound
            
        case 3:
            selectedCurrentCurrencyType = CurrencyTypes.JapaneseYen
            
        default:
            //Add popup message on screen that no value was selected
            println("Please try again")
        }
        
        //now that we have stored the selected f/x currency, we can printout the value that is loaded, irrespective of the switch statement.
        //the switch should just work.
        //enums are structs (mini class). They are not String but they have a rawValue which can be of Type String. Our enum has String RawValues.
        //We need to get to the rawValue before we print to console.
        println(selectedCurrentCurrencyType.rawValue)
        
    }
    
    func convertedCurrency(sender: UISegmentedControl){
        //Determine which currency was selected.
        switch sender.selectedSegmentIndex {
        case 0:
            selectedConversionCurrencyType = CurrencyTypes.USDollar
            
        case 1:
            selectedConversionCurrencyType = CurrencyTypes.EuropeanEuro
            //convertedOutput.text = conversionInput * multipierRate
            
        case 2:
            selectedConversionCurrencyType = CurrencyTypes.BritishPound
            
        case 3:
            selectedConversionCurrencyType = CurrencyTypes.JapaneseYen
        default:
            //Add popup message on screen that no value was selected
            println("Please try again")
        }
        
        //now that we have stored the selected f/x currency, we can printout the value that is loaded, irrespective of the switch statement.
        //the switch should just work.
        //enums are structs (mini class). They are not String but they have a rawValue which can be of Type String. Our enum has String RawValues.
        //We need to get to the rawValue before we print to console.
        println(selectedConversionCurrencyType.rawValue)
        
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
        convertFromRates.center.y =  conversionInput.center.y + minFrame * 0.20
    
        convertToRates.frame = CGRectMake(25, 25, minFrame * 0.60, minFrame * 0.10)
        convertToRates.center.x = view.center.x
        convertToRates.center.y = minFrame * 0.60
        
        convertedOutput.frame = CGRectMake(65, 65, minFrame * 0.60, minFrame * 0.10)
        convertedOutput.center.x = view.center.x
        convertedOutput.center.y = minFrame * 0.70
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        conversionInput.resignFirstResponder()
    }

}

