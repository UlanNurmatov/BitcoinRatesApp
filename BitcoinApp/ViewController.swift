//
//  ViewController.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/14/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import UIKit

enum Period: Int {
    case week = 7
    case month = 31
    case year = 365
}

enum Currency: String {
    case USD = "USD"
    case EUR = "EUR"
    case KZT = "KZT"
}

class PricesViewController: UIViewController {
    
    @IBOutlet weak var currencyControl: UISegmentedControl!
    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var priceHistoryTableView: UITableView!
    @IBOutlet weak var priceHistoryControl: UISegmentedControl!
    @IBOutlet weak var flag: UIImageView!

    //MARK: Properties
    
    var historicalData: BitcoinPriceViewModel?
    var priceData: BitcoinCurrentPrice?
    
    var selectedCurrency: Currency = .USD
    var selectedPeriod: Period = .week
    
    var activity = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceHistoryTableView.dataSource = self
        priceHistoryTableView.delegate = self
        setUI()
        getCurrentPrice()
        flag.image = UIImage(named: "USA")
        getHistoricalPrices(period: .week)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.topItem?.title = "Bitcoin rates"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        priceHistoryTableView.tableFooterView = UIView()

        activity.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activity.color = .label
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        self.view.addSubview(activity)
        activity.center = self.view.center
    }
    
    //MARK: Action handlers

    @IBAction func currencySelected(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCurrency = .USD
            getCurrentPrice()
            flag.image = UIImage(named: "USA")
            getHistoricalPrices(period: selectedPeriod)
        case 1:
            selectedCurrency = .EUR
            getCurrentPrice()
            flag.image = UIImage(named: "EURO")
            getHistoricalPrices(period: selectedPeriod)
        case 2:
            selectedCurrency = .KZT
            getCurrentPrice()
            flag.image = UIImage(named: "KZT")
            getHistoricalPrices(period: selectedPeriod)
        default:
            break
        }
    }
    
    @IBAction func periodSelected(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedPeriod = .week
            getHistoricalPrices(period: selectedPeriod)
        case 1:
            selectedPeriod = .month
            getHistoricalPrices(period: selectedPeriod)
        case 2:
            selectedPeriod = .year
            getHistoricalPrices(period: selectedPeriod)
        default:
            break
        }
    }

    //MARK: Server requests

    func getCurrentPrice() {
        ServerManager.shared.getcurrentPrice(currency: selectedCurrency.rawValue, header: [:], completion: successCurrentPrice, error: error, networkError: networkError)
    }
    
    func getHistoricalPrices(period: Period) {
        activity.startAnimating()
        historicalData = nil
        priceHistoryTableView.reloadData()
        let dates = getStartandEndDates(period: period)
        ServerManager.shared.getBitcoinPrices(start: dates.first!, end: dates.last!, currency: selectedCurrency.rawValue, header: [:], completion: success, error: error, networkError: networkError)
    }
    
    //MARK: Server response handlers

    func successCurrentPrice(price: BitcoinCurrentPrice) {
        switch selectedCurrency {
        case .USD:
            bitcoinPrice.text = String(format:"%.0f", price.bpi.USD.rate_float) + " \(selectedCurrency.rawValue)"
        case .EUR:
            guard let euro = price.bpi.EUR else { break }
            bitcoinPrice.text = String(format:"%.0f", euro.rate_float) + " \(selectedCurrency.rawValue)"
        case .KZT:
            guard let kzt = price.bpi.KZT else { break }
            bitcoinPrice.text = String(format:"%.0f", kzt.rate_float) + " \(selectedCurrency.rawValue)"
        }
    }
    
    func success(data: BitcoinHistoricalPrice) {
        self.historicalData = BitcoinPriceViewModel(bitcoinPrice: data)
        //if selectedPeriod == .year {
            self.historicalData?.dates.reverse()
            self.historicalData?.prices.reverse()
        //}
        activity.stopAnimating()
        priceHistoryTableView.reloadData()
    }
    
    func error(error: ErrorResponse) {
        print(error.message ?? "ERROR")
    }
    
    func networkError(message: String) {
        print(message)
    }
}

//MARK: TableView

extension PricesViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historicalData?.dates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! PriceCell
        cell.date.text = historicalData?.dates[indexPath.row]
        let averagePrice = historicalData?.prices[indexPath.row]
        cell.price.text = String(format:"%.0f", averagePrice ?? 0.0) + " \(selectedCurrency.rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Rate history"
    }
}


