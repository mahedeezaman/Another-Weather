//
//  WeatherDataModel.swift
//  Weather App
//
//  Created by Mahedee Zaman on 12/5/22.
//

import Foundation

struct ForecastDataModel: Codable {
    struct Daily: Codable {
        let dt: Date
        
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        let temp: Temp
        
        let humidity: Int
        
        struct Weather: Codable {
            let description: String
            let icon: String
        }
        let weather: [Weather]
        
        let clouds: Int
        let pop: Double
    }
    let daily: [Daily]
    let timezone: String
}
