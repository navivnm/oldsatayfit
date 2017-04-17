//
//  ViewControllerCell.swift
//  abcd
//
//  Created by Naveen Vijay on 12/04/17.
//  Copyright © 2017 Naveen Vijay. All rights reserved.
//

import UIKit

class ViewControllerCell: UITableViewCell {

    @IBOutlet weak var lblCellDate: UILabel!
    @IBOutlet weak var lblCellExercise: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
