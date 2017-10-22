//
//  TableViewCell.swift
//  FinalProject
//
//  Created by Yang Gao on 10/16/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var title: UITextField!
    
    @IBOutlet weak var subtitle: UITextView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    static let reuseIdentifier = "LandmarkCell"

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
