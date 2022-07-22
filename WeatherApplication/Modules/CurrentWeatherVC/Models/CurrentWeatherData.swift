//
//  CurrentWeatherData.swift
//  WeatherApplication
//
//  Created by Abai Kush on 22/7/22.
//

import UIKit

struct CurrentWeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
}
struct Weather: Decodable {
    let id: Int
}
