//
//  HourlyViewCell.swift
//  WeatherApp
//
//  Created by Shubhdeep on 2023-07-10.
//

import UIKit

class HourlyViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    static let identifier = "HourlyViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyViewCell", bundle: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
