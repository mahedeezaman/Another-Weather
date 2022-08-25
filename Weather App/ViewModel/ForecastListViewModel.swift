//
//  ForecastListViewModel.swift
//  Weather App
//
//  Created by Mahedee Zaman on 12/5/22.
//

import Foundation
import CoreLocation
import SwiftUI

struct AppError: Identifiable {
    var id = UUID().uuidString
    let errorString: String
}

class ForecastListViewModel: ObservableObject {
    var appError : AppError? = nil
    @Published var isLoading = false
    @Published var forecasts: [ForecastViewModel] = []
    @Published var location = ""
    @AppStorage("location") var storageLocation : String = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init() {
        location = storageLocation
        parseJSON()
    }
    
    func parseJSON() {
        storageLocation = location
        isLoading = true
        
        UIApplication.shared.endEditing()
        if location.isEmpty {
            forecasts = []
            isLoading = false
            return
        }
        
        let weatherData = FetchWeatherData.sharedInstance
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error as? CLError {
                switch error.code {
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    self.appError = AppError(errorString: "Unable to determine location from this text")
                case .network:
                    self.appError = AppError(errorString: "You do not appear to have a network connection")
                default:
                    self.appError = AppError(errorString: error.localizedDescription)
                }
                
                self.isLoading = false
                print(error.localizedDescription)
            }
            
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=8acfcee088c2f9f14843dec37c363599"
                weatherData.getJSON(urlString: url, dateDecodingStrategy: .secondsSince1970) { (result: Result<ForecastDataModel, FetchWeatherData.APIError>) in
                    
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.forecasts = forecast.daily.map {
                                ForecastViewModel(forecastDaily: $0, system: self.system)}
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString) :
                            self.isLoading = false
                            self.appError = AppError(errorString: errorString)
                            print(errorString)
                        }
                    }
                }
            }
        }
    }
}
