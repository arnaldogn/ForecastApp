//
//  Item.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 05/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import ObjectMapper
import CoreLocation
import RealmSwift

struct CityForecast {
    var id: Int?
    var name: String?
    var date: Date?
    var coordinates = CLLocation()
    var forecast: Forecast?
    private var coord: [String: Double]?
}

extension CityForecast: Mappable {
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        coord <- map["coord"]
        forecast <- map["main"]
        coordinates = coordinatesFromDict(coord)
    }

    private func coordinatesFromDict(_ coord: [String: Double]?) -> CLLocation {
        guard let coordinates = coord, let longitude = coordinates["lon"], let latitude = coordinates["lat"] else { return CLLocation() }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

final public class CityForecastObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var date = Date()

    override public static func primaryKey() -> String? {
        return "id"
    }
}

extension CityForecast: Persistable {
    public init(managedObject: CityForecastObject) {
        id = managedObject.id
        name = managedObject.name
        date = managedObject.date
    }

    public func managedObject() -> CityForecastObject {
        let cityForecastObject = CityForecastObject()
        cityForecastObject.id = id ?? 0
        cityForecastObject.name = name ?? ""
        cityForecastObject.date = date ?? Date()
        return cityForecastObject
    }
}

struct Forecast {
    var temperature: Double?
    var pressure: Double?
    var humidity: Double?
    var maxTemp: Double?
    var minTemp: Double?
}

extension Forecast: Mappable {
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        temperature <- map["temp"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
        maxTemp <- map["temp_max"]
        minTemp <- map["temp_min"]
    }
}
