//
//  ContentView.swift
//  Weather App
//
//  Created by Mahedee Zaman on 12/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject var forecastListVM = ForecastListViewModel()
    
    var body: some View {
        ZStack {
            NavigationView{
                VStack{
                    Picker(selection: $forecastListVM.system, label: Text("System")) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 100)
                    .padding(.vertical)
                    
                    HStack {
                        TextField("Enter City", text: $forecastListVM.location, onCommit: {forecastListVM.parseJSON()})
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                Button(action: {
                                    forecastListVM.location = ""
                                    forecastListVM.parseJSON()
                            }, label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.gray)
                            }).padding(.horizontal), alignment : .trailing
                            )
                        Button {
                            forecastListVM.parseJSON()
                        } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title3)
                        }
                    }
                    List(forecastListVM.forecasts, id: \.day) { day in
                        VStack(alignment: .leading){
                            Text(day.day)
                                .fontWeight(.bold)
                            HStack(alignment: .center){
                                WebImage(url: day.weatherIconURL)
                                    .resizable()
                                    .placeholder {
                                        Image(systemName: "hourglass")
                                    }
                                    .scaledToFit()
                                    .frame(width: 75)
                                VStack(alignment: .leading){
                                    Text(day.overview)
                                        .font(.title2)
                                    HStack{
                                        Text(day.high)
                                        Text(day.low)
                                    }
                                    HStack{
                                        Text(day.clouds)
                                        Text(day.pop)
                                    }
                                    Text(day.humidity)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding()
                }
                .padding(.horizontal)
                .navigationTitle("Mobile Weather")
                .alert(item: $forecastListVM.appError) { appAlert in
                    Alert(title: Text("Error"), message: Text("""
    \(appAlert.errorString)
    Please Try Again Later
    """))
                }
            }
            if forecastListVM.isLoading {
                ZStack {
                    Color(.white)
                        .opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Fetching Weather")
                        .padding()
                        .background(
                            RoundedRectangle(
                                cornerRadius: 10).fill(
                                    Color(.systemBackground)
                                )
                        )
                        .shadow(radius: 10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
