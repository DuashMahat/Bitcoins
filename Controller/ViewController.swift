//
//  ViewController.swift
//  Bitcoins
//
//  Created by Duale on 7/2/19.
//  Copyright © 2019 Duale. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource  {
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR", "KES"]
     var finalUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CurrencyPicker.delegate = self
        CurrencyPicker.dataSource = self
        centerAlign()
    }

    // specify how  many components you have in the UIpicker view : COLUMNS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // specify the number of rows of the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    // setting up a title for each row as U CAN QUESSS titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print(currencyArray[row])
        return currencyArray[row]
    }
    
    // check for the pickerview selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(row)
//        print(currencyArray[row])
        
        finalUrl = baseURL + currencyArray[row]
        print(finalUrl)
        getCurrencyData(url: finalUrl)
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str : String = currencyArray[row]
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow])
    }
    
    // we are going to call an API provided by the bitcoinaverage.com
    @IBOutlet weak var CurrencyPicker: UIPickerView!
    @IBOutlet weak var PriceLable: UILabel!
    
    
    /* NETWORKING USING ALAMOFIRE */
    
    func getCurrencyData ( url: String) {
        Alamofire.request(url , method: .get ).responseJSON {
           response in
            if response.result.isSuccess {
                print("Got the data")
                let currencyJSON : JSON = JSON(response.result.value!)
                self.updateCurrencyData(json: currencyJSON)
            } else {
                print("Error in getting this")
                self.PriceLable.text = "Unable to retrieve price"
            }
        }
    }
    
    /* UPDATE THE DATA == JSON: PARSING */
    func updateCurrencyData (json: JSON) {
        //optional binding
        if let value = json["ask"].double {
          self.PriceLable.text = String(value) + "﹩"
        } else {
            self.PriceLable.text = "Price Unavailable"
        }
    }

    func centerAlign () {
        PriceLable.textAlignment = .center;
//        PriceLable.textColor = .
       
    }
    
}

