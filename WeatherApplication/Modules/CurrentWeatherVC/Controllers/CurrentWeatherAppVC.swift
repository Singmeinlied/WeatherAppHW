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
    
    @IBOutlet weak var futureWeatherOutlet: UIButton!
    var locationManager = CLLocationManager()
    
    var cityName: String?
    
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
        locationManager.requestLocation()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
//        mainTextField.becomeFirstResponder()
        fetchCityWeather()
    }
    
    @IBAction func futureWeatherButtonTapped(_ sender: UIButton) {
        guard let cityName = cityName else {
            return
        }

//        let vc = FutureWeatherVC(cityName: cityName)
//        present(vc, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FutureWeatherVC") as! FutureWeatherVC
        
        vc.cityName = cityName
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func fetchCityWeather(){
        if let text = mainTextField.text{
            if text.isEmpty{
                mainTextField.placeholder = "Type a City"
            }else{
                currentWeatherManager.fetchWeather(cityName: text)
            }
        }else{
            mainTextField.placeholder = "Type a City"
        }
    }
    
}
extension CurrentWeatherAppVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text{
            if text.isEmpty{
                textField.placeholder = "Type a City"
            }else{
                currentWeatherManager.fetchWeather(cityName: text)
            }
        }else{
            textField.placeholder = "Type a City"
        }
        
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
            self.cityName = weather.cityName
            self.mainLabel.text = weather.temperatureString + "°c"
            self.mainImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func errorFetchingWeather(error: Error) {
        print(error.localizedDescription)
    }
}
