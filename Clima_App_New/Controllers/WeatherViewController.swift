//
//  ViewController.swift
//  Clima_App_New
//
//  Created by Anand Nimje on 03/02/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import ANLoader

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let LocationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
    }

    
    //    Mark:- Networking
    func getWeatherData(url: String, parameters: [String : String]) {
        
        ANLoader.showLoading("Loading..", disableUI: false)
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
           ANLoader.hide()
            
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issue"
            }
        }
    }

    //Mark:- JSON Parsing
    func updateWeatherData(json: JSON) {
        let tempResult = json["main"]["temp"].doubleValue
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(codition: weatherDataModel.condition)
        
        updateUIWithWeatherData()
    }
    
    //Mark:- UI Updates
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //Mark:- Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy>0 {
            self.LocationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            DispatchQueue.main.async { [weak self] in
                self?.getWeatherData(url: (self?.WEATHER_URL)!, parameters: params)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
        cityLabel.text = "Location Unavailable"
    }
    
    //Mark:- Change City Delegate Methode
    func userEnteredANewCityName(City city: String) {
        let params : [String : String] = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self as? ChangeCityDelegate
        }
    }
}


















