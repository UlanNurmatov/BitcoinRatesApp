//
//  TransactionsViewController.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/23/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [Transaction]?
    
    var activity = UIActivityIndicatorView()
    
    lazy var refresher: UIRefreshControl = {
           let refreshControl = UIRefreshControl()
           refreshControl.tintColor = UIColor.lightGray
           refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
           return refreshControl
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setUI()
        getTransactions()

    }
    
    @objc func refresh() {
      getTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.topItem?.title = "Recent transactions"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        activity.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activity.color = .label
            activity.style = .large
        } else {
            activity.style = .gray
        }
        self.view.addSubview(activity)
        activity.center = self.view.center
        activity.startAnimating()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
    }
    //MARK: Server requests

    func getTransactions() {
        ServerManager.shared.getTransactions(header: [:], completion: success, error: error, networkError: networkError)
    }
    
    //MARK: Server response handlers

    func success(transaction: [Transaction]) {
        let first500 = transaction[0...499]
        self.data = Array(first500)
        activity.stopAnimating()
        refresher.endRefreshing()
        UIView.performWithoutAnimation {
            tableView.reloadData()
        }
    }
    
    func error(error: ErrorResponse) {
        print(error.message ?? "ERROR")
    }
    
    func networkError(message: String) {
        print(message)
    }
    
}

//MARK: TableView

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return data?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionsCell
           cell.transaction = data?[indexPath.row]
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard data != nil else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let transactionDetails = storyboard.instantiateViewController(withIdentifier: "transactionDetails") as! TransactionDetailsViewController
        transactionDetails.transaction = data![indexPath.row]
        show(transactionDetails, sender: self)
    }
    
}

