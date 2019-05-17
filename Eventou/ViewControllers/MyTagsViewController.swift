//
//  MyTagsViewController.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 29/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class MyTagsViewController: UITableViewController {
    
    //MARK: - Variables
    weak var delegate: SegueHandler?
    
    //MARK: - Necessary TableView Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.segueToNext(identifier: "showTags")
    }
}
