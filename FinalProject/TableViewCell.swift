//
//  TableViewCell.swift
//  FinalProject
//
//  Created by Yang Gao on 10/16/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var subtitle: UILabel!

    static let reuseIdentifier = "LandmarkCell"

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
