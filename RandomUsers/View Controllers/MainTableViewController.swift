//
//  MainTableViewController.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import UIKit
import Foundation

class MainTableViewController: UIViewController {
    
    //
    // MARK: - Properties
    //
    
    var users = [RandomUser]()
    var numberOfUsersToFetch = 5
    
    //
    // MARK: - Outlets
    //
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    //
    // MARK: - Actions
    //
    
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    
    //
    // MARK: - View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
        showEmptyStateView()
        RandomUserController.shared.fetchRandomUsers(numberOfUsers: numberOfUsersToFetch) { (users) in
            DispatchQueue.main.async {
                self.users = RandomUserController.shared.randomUsers
                self.tableView.reloadData()
                self.showTableView()
            }
        }
    }
    
    //
    // MARK: - Refresh Control
    //
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        RandomUserController.shared.fetchRandomUsers(numberOfUsers: numberOfUsersToFetch) { (users) in
            DispatchQueue.main.async {
                self.users = RandomUserController.shared.randomUsers
                self.tableView.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    //
    // MARK: - Alert
    //
    
    func presentAlert() {
        
        let alert = UIAlertController(title: "How Many Users Do You Want To Get?", message: "Enter any integer value from 1 - 5,000", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter Number"
            textfield.textAlignment = .center
            textfield.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let numberString = alert.textFields?.first?.text else { return }
            guard let number = Int(numberString) else { return }
            
            if 1...5000 ~= number {
                self.numberOfUsersToFetch = number
            } else {
                return
            }
            
            self.showEmptyStateView()
           
            RandomUserController.shared.fetchRandomUsers(numberOfUsers: self.numberOfUsersToFetch) { (users) in
                DispatchQueue.main.async {
                    self.users = RandomUserController.shared.randomUsers
                    self.tableView.reloadData()
                    self.showTableView()
                }
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //
    // MARK: - Methods
    //
    
    func showEmptyStateView() {
        self.tableView.isHidden = true
        self.emptyStateView.isHidden = false
        self.activitySpinner.isHidden = false
        self.activitySpinner.startAnimating()
    }
    
    func showTableView() {
        self.tableView.isHidden = false
        self.activitySpinner.isHidden = true
        self.emptyStateView.isHidden = true
        self.activitySpinner.stopAnimating()
    }

}

//
// MARK: - TableView
//

extension MainTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.userCell, for: indexPath) as? MainTableViewCell ?? MainTableViewCell()
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}













