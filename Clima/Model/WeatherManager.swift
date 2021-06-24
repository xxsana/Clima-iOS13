//
//  WeatherManager.swift
//  Clima
//
//  Created by Haru on 2021/03/11.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    // city name 부분 변경가능하게 하기 : &q=cityName부분 전체 떼기
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=18a8b6952c0a12293ab5c0b4ccfcfbe3&units=metric"
    
    
    // text field에서 city name 얻어서 주소만 완성하는 메소드
    func fetchWeather(cityName: String) {
        // 형식 잘 보기
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // current latitude, longitude로 업데이트하는 메소드
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    
    // 4steps 하는 메소드
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather: WeatherModel = self.parseJSON(safeData) {
                        //view controller로 보내야 함 (delegate pattern 사용)
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData: WeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            //WeatherData 의 Object(==인스턴스)를 반환함
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}


