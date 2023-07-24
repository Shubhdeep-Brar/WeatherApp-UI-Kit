//
//  ViewController.swift
//  WeatherApp
//
//  Created by Shubhdeep on 2023-07-10.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet var table: UITableView!
    
    var currentWeather : CurrentWeather?
    var currentWeatherCondition: String = ""
    var weatherResponse : WeatherData?
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var models = [DailyWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register two cells
        
        table.register(HourlyViewCell.nib(), forCellReuseIdentifier: HourlyViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        view.backgroundColor = UIColor(red: 45/255.0, green: 144/255.0, blue: 228/255.0, alpha: 1.0)
        table.backgroundColor = UIColor(red: 45/255.0, green: 144/255.0, blue: 228/255.0, alpha: 1.0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    
    // Mark: Location
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("setup location called")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=60.99&lon=30.9&appid=fad9d3e197d3fcc8262be9c4b7b8e81a&units=metric"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data,  response, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong no data")
                return
            }
            
            var jSon: WeatherData?
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                jSon = try decoder.decode(WeatherData.self, from: data)
            }
            catch {
                print("Error: \(error)")
            }
            
            guard let weatherResponse = jSon else {
                return
            }
            
            guard let entries = weatherResponse.daily else {
                print("Nil Value for daily weather entries")
                return
            }
            
            self.models.append(contentsOf: entries)
            guard let currentWeatherCondition = weatherResponse.current?.weather.first?.main else { return }
            self.currentWeatherCondition = currentWeatherCondition
            let current = weatherResponse.current
            self.currentWeather = current
            
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
        
        print("\(long) || \(lat)")
        
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.backgroundColor = UIColor(red: 45/255.0, green: 144/255.0, blue: 228/255.0, alpha: 1.0)
        
   
        
        let locationLabel = UILabel( frame: CGRect(x: 10, y: 60, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 70+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 70+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        
        tempLabel.text = "\(self.currentWeather?.temp ?? 000)°C"
        tempLabel.font = UIFont(name: "Helvetica-bold", size: 32)
        
        summaryLabel.text = "\(self.currentWeatherCondition)"
        locationLabel.text = "Current Location"
        
        return headerView
    }
    
    // Mark: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.backgroundColor = UIColor(red: 45/255.0, green: 144/255.0, blue: 228/255.0, alpha: 1.0)
        if indexPath.row < models.count {
            cell.configure(with: models[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct WeatherData: Codable {
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let timezone_offset: Int?
    let current: CurrentWeather?
    let minutely: [MinutelyWeather]?
    let hourly: [HourlyWeather]?
    let daily: [DailyWeather]?
}

struct CurrentWeather: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Double?
    let feels_like: Double?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Double?
    let wind_deg: Int?
    let wind_gust: Double?
    let weather: [Weather]
}

struct MinutelyWeather: Codable {
    let dt: Int?
    let precipitation: Int?
}

struct HourlyWeather: Codable {
    let dt: Int?
    let temp: Double?
    let feels_like: Double?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Double?
    let wind_deg: Int?
    let wind_gust: Double?
    let weather: [Weather]?
    let pop: Double?
}

struct DailyWeather: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let moonrise: Int?
    let moonset: Int?
    let moon_phase: Double?
    let temp: Temperature?
    let feels_like: Temperature?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let wind_speed: Double?
    let wind_deg: Int?
    let wind_gust: Double?
    let weather: [Weather]?
    let clouds: Int?
    let rain: Double?
    let uvi: Double?
}

struct Temperature: Codable {
    let day: Double?
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}
