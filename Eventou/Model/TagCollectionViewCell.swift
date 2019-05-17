//
//  TagCollectionViewCell.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 03/02/19.
//  Copyright © 2019 Bruno Rocca. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 16
    }
}
