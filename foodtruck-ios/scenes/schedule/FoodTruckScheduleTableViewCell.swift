//
//  FoodTruckScheduleTableViewCell.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import UIKit

class FoodTruckScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var businessHoursTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
