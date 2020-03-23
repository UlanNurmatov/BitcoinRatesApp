//
//  ConverterViewController.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/24/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    @IBOutlet weak var btcSwitch: UISwitch!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var flag: UIImageView!


    var priceData: BitcoinCurrentPrice?
    var selectedCurrency: Currency = .USD
    var switchIsOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Converter"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        flag.image = UIImage(named: "USA")
    }
    
    func getCurrentPrice() {
        ServerManager.shared.getcurrentPrice(currency: selectedCurrency.rawValue, header: [:], completion: successCurrentPrice, error: error, networkError: networkError)
    }
    
    
    @IBAction func currencySelected(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCurrency = .USD
        case 1:
            selectedCurrency = .EUR
        case 2:
            selectedCurrency = .KZT
        default:
            break
        }
    }
    
    @IBAction func convertButtonTapped() {
        guard Double(textField.text!) != nil else { return }
        currencyControl.isEnabled = false
        convertButton.isEnabled = false
        getCurrentPrice()
    }
    
    @IBAction func toggled(_ sender: UISwitch) {
        switchIsOn = sender.isOn
    }
    
    func successCurrentPrice(price: BitcoinCurrentPrice) {
        
           var converted = Double()
           switch selectedCurrency {
           case .USD:
            if let value = Double(textField.text!) {
                if btcSwitch.isOn {
                    converted = value * price.bpi.USD.rate_float
                    priceLabel.text = String(format:"%.0f", converted) + " \(selectedCurrency.rawValue)"
                } else {
                    converted = value / price.bpi.USD.rate_float
                    priceLabel.text = String(format:"%.4f", converted) + " BTC"
                }
                flag.image = UIImage(named: "USA")
            }
           case .EUR:
            if let value = Double(textField.text!), let euro = price.bpi.EUR {
                if btcSwitch.isOn {
                    converted = value * euro.rate_float
                    priceLabel.text = String(format:"%.0f", converted) + " \(selectedCurrency.rawValue)"
                } else {
                    converted = value / euro.rate_float
                    priceLabel.text = String(format:"%.4f", converted) + " BTC"

                }
                flag.image = UIImage(named: "EURO")
            }
           case .KZT:
               if let value = Double(textField.text!), let kzt = price.bpi.KZT {
                  if btcSwitch.isOn {
                       converted = value * kzt.rate_float
                       priceLabel.text = String(format:"%.0f", converted) + " \(selectedCurrency.rawValue)"
                   } else {
                       converted = value / kzt.rate_float
                       priceLabel.text = String(format:"%.4f", converted) + " BTC"

                   }
                  flag.image = UIImage(named: "KZT")
               }
            }
        currencyControl.isEnabled = true
        convertButton.isEnabled = true
       }
    
    func error(error: ErrorResponse) {
        print(error.message ?? "ERROR")
    }
    
    func networkError(message: String) {
        print(message)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
}
