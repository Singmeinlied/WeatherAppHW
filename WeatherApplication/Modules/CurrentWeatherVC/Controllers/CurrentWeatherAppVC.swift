//
//  CurrentWeatherAppVC.swift
//  WeatherApplication
//
//  Created by Abai Kush on 22/7/22.
//

import UIKit
import CoreLocation

class CurrentWeatherAppVC: UIViewController{
    
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    var currentWeatherManager = CurrentWeatherManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        currentWeatherManager.currentWeatherDelegate = self
    }
    
    @IBAction func currentPositionTapped(_ sender: UIButton) {
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        mainTextField.becomeFirstResponder()
    }
    
}
extension CurrentWeatherAppVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CurrentWeatherAppVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longtitude = location.coordinate.longitude
            
            currentWeatherManager.fetchWeather(latitude: latitude, longtitude: longtitude)
            
            print("Coordinates \(latitude) and \(longtitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension CurrentWeatherAppVC: CurrentWeatherDelegate{
    func fetchWeather(weather: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.mainLabel.text = weather.temperatureString + "°c"
            self.mainImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func errorFetchingWeather(error: Error) {
        print(error.localizedDescription)
    }
    
    
}
