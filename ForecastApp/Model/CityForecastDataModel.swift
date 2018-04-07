//
//  ItemViewModel.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 05/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import Foundation

class CityForecastDataModel: NSObject {
    let item: CityForecast

    init(_ item: CityForecast) {
        self.item = item
    }
    var name: String {
        return item.name ?? ""
    }
    var temperature: String {
        guard let temp = item.forecast?.temperature else { return "" }
        return String(format: "%.0f", temp)
    }
    var humidity: String {
        guard let hum = item.forecast?.humidity else { return "" }
        return String(format: "%.0f", hum)
    }
    var pressure: String {
        guard let pres = item.forecast?.pressure else { return "" }
        return String(format: "%.0f", pres)
    }
    var maxTemp: String {
        guard let maxTemp = item.forecast?.maxTemp else { return "" }
        return String(format: "%.0f", maxTemp)
    }
    var minTemp: String {
        guard let minTemp = item.forecast?.minTemp else { return "" }
        return String(format: "%.0f", minTemp)
    }
}
