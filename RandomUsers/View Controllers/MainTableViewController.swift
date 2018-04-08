//
//  MainTableViewController.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import UIKit

class MainTableViewController: UIViewController {
    
    //
    // MARK: - Properties
    //
    
    var users = [RandomUser]()
    
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
        print("Button Tapped")
    }
    
    //
    // MARK: - View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
        RandomUserController.shared.fetchRandomUsers(numberOfUsers: 40) { (users) in
            DispatchQueue.main.async {
                self.users = RandomUserController.shared.randomUsers
                self.tableView.reloadData()
            }
        }
    }
    
    // Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        RandomUserController.shared.fetchRandomUsers(numberOfUsers: 40) { (users) in
            DispatchQueue.main.async {
                self.users = RandomUserController.shared.randomUsers
                self.tableView.reloadData()
            }
        }
        refreshControl.endRefreshing()
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











