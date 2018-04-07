//
//  FetchItemsService.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 05/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

protocol FetchForecastServiceProtocol {
    func fetchForecast(for city: String, onCompletion: @escaping (CityForecast?, Error?) -> Void)
}

struct FetchForecastService: FetchForecastServiceProtocol {

    func fetchForecast(for city: String, onCompletion: @escaping (CityForecast?, Error?) -> Void) {

        guard let urlComponents = NSURLComponents(string: WeatherAPI.baseURL + WeatherAPI.currentForecast) else { return }
        let queryItems = [URLQueryItem(name: "q", value: city),
                          URLQueryItem(name: "APPID", value: WeatherAPI.key)]
        urlComponents.queryItems = queryItems
        guard let searchUrl = urlComponents.url else { return }

        Alamofire.request(searchUrl).responseObject { (response: DataResponse<CityForecast>) in
            if let weatherResponseItem = response.result.value {
                return onCompletion(weatherResponseItem, nil)
            }
            return onCompletion(nil, response.error)
        }
    }
}
