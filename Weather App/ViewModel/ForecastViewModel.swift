//
//  ForecastViewModel.swift
//  Weather App
//
//  Created by Mahedee Zaman on 12/5/22.
//

import Foundation

struct ForecastViewModel {
    let forecastDaily : ForecastDataModel.Daily
    var system: Int
    
    static var dateFormatter: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    static var percentFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    var day: String{
        return Self.dateFormatter.string(from: forecastDaily.dt)
    }
    
    var overview: String {
        forecastDaily.weather[0].description.capitalized
    }
    var high: String {
        return "High: \(Self.numberFormatter.string(for: convert(forecastDaily.temp.max)) ?? "0")°"
    }
    
    var low: String {
        return "Low: \(Self.numberFormatter.string(for: convert(forecastDaily.temp.min)) ?? "0")°"
    }
    
    var pop: String{
        return "💧: \(Self.percentFormatter.string(for: forecastDaily.pop) ?? "0")"
    }
    
    var clouds: String {
        return "☁️ \(forecastDaily.clouds)%"
    }
    
    var humidity: String {
        return "Humidity: \(forecastDaily.humidity)"
    }
    
    var weatherIconURL : URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecastDaily.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
    func convert(_ temp: Double) -> Double {
        let celsius = temp - 273.5
        
        if system == 0 {
            return celsius
        } else {
            return celsius * 9 / 5 + 32
        }
    }
}
