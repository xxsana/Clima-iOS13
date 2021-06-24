//
//  WeatherData.swift
//  Clima


//JSON -> Swift 하기 위한 파일
import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
