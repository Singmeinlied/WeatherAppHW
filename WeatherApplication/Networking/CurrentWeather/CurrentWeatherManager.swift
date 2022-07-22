//
//  CurrentWeatherManager.swift
//  WeatherApplication
//
//  Created by Abai Kush on 22/7/22.
//

import Foundation
import CoreLocation

protocol CurrentWeatherDelegate{
    func fetchWeather(weather: CurrentWeatherModel)
    func errorFetchingWeather(error: Error)
}

class CurrentWeatherManager{
    
    static let shared = CurrentWeatherManager()
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dfbc08b946087e1deb4540f86524bcc1&units=metric"
    
    var currentWeatherDelegate: CurrentWeatherDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        
        createRequest(urlString: urlString)
    }
    func createRequest(urlString: String){
        let url = URL(string: urlString)
        
        if let url = url {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.currentWeatherDelegate?.errorFetchingWeather(error: error)
                }
                
                if let data = data {
                    if let decodedData = self.parseJSON(weatherData: data){
                        self.currentWeatherDelegate?.fetchWeather(weather: decodedData)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (weatherData: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try
            decoder.decode (CurrentWeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = CurrentWeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch {
            currentWeatherDelegate?.errorFetchingWeather(error: error)
            return nil
        }
    }
}
