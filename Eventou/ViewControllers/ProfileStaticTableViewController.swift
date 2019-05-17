//
//  ProfileStaticTableViewController.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 23/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import UIKit

class ProfileStaticTableViewController: UITableViewController {

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }

    //MARK: - Default Methods
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
}
