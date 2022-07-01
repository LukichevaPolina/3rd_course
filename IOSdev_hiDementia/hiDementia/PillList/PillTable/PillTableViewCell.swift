//
//  PillTableViewCell.swift
//  hiDementia
//
//  Created by Сапожников Андрей Михайлович on 23.12.2021.
//

import UIKit

class PillTableViewCell: UITableViewCell {

    @IBOutlet var pillLabel: UILabel!
    
    @IBOutlet var mealLabel: UILabel!
    
    @IBOutlet var numberLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var pillIImageView: UIImageView!
    
    func setTaken(_ status: Bool) -> Void {
        let alpha: Float = status ? 0.5 : 1.0
        let bgImage = status ? UIImage(named: "PillCellBgGray") : UIImage(named: "PillCellBg")
        let pillImage = status ? UIImage(named: "drugsGray") : UIImage(named: "drugs")
        // set
        backgroundImageView?.image = bgImage
        pillIImageView?.image = pillImage
        pillIImageView?.alpha = CGFloat(alpha)
        let textColor = status ? UIColor.systemGray : UIColor.systemOrange
        timeLabel?.textColor = textColor
    }
}
