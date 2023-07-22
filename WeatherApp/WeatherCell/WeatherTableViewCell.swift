//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Shubhdeep on 2023-07-10.
//
import Foundation
import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: DailyWeather){
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textAlignment = .center
        
        self.lowTempLabel.text = "\(Int((model.temp?.min)!))°C"
        self.highTempLabel.text = "\(Int((model.temp?.max)!))°C"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt!)))
        
        self.iconImageView.contentMode = .scaleAspectFit
        if let main = model.weather?.first?.main {
           
            switch main {
            case "Rain","Drizzle","Thunderstorm":
                self.iconImageView.image = UIImage(named: "Rain")
            case "Clouds":
                self.iconImageView.image = UIImage(named: "Cloud")
            case "Snow":
                self.iconImageView.image = UIImage(named: "Snow")
            default :
                self.iconImageView.image = UIImage(named: "Clear")
            }
        }
    }
    
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }

}
