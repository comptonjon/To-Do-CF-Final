//
//  TaskCell.swift
//  To-Do-CF-Final
//
//  Created by Jonathan Compton on 5/29/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    var on = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func cellBtnTapped(_ sender: Any) {
  
            cellButton.titleLabel?.text = "Off"




    }
}
