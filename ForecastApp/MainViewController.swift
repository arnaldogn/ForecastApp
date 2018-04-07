//
//  ViewController.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 05/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import UIKit
import MapKit
import EasyRealm
import RealmSwift
import ACProgressHUD_Swift

class MainViewController: UIViewController {
    private var itemList = [CityForecast]()
    private let fetchService: FetchForecastServiceProtocol
    private let realm = try! Realm()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.placeholder = "Search city"
        searchBar.becomeFirstResponder()
        return searchBar
    }()
    private var locationMap: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 4
        map.layer.borderColor = UIColor.black.cgColor
        map.layer.borderWidth = 0.5
        return map
    }()
    private lazy var resultsView: ResultsView = {
        let resultsView = ResultsView()
        resultsView.delegate = self
        return resultsView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    private var selectedForecast: CityForecast?
    let locationManager = CLLocationManager()

    init(fetchService: FetchForecastServiceProtocol) {
        self.fetchService = fetchService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather App"
        navigationController?.navigationBar.isTranslucent = false
        setupViews()
        loadRecentForecasts()
        loadLastCityForecast()
    }

    func setupViews() {
        view.addSubviewsForAutolayout(searchBar, locationMap, resultsView, tableView)
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    private func setupLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    private func setupConstraints() {
        let views = ["searchBar": searchBar,
                     "map": locationMap,
                     "resultsView": resultsView,
                     "tableView": tableView]
        view.addConstraints(
            NSLayoutConstraint.constraints("H:|[searchBar]|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[map]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|[resultsView]|", views: views),
            NSLayoutConstraint.constraints("H:|[tableView]|", views: views),
            NSLayoutConstraint.constraints("V:|[searchBar][map][resultsView(180)][tableView]|", views: views))
        locationMap.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        locationMap.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func loadRecentForecasts() {
        guard let savedList = try? CityForecastObject.er.all().sorted(byKeyPath: "date", ascending: false) else { return }
        itemList.removeAll()
        savedList.forEach { self.itemList.append(CityForecast(managedObject: $0)) }
        tableView.reloadData()
    }

    private func loadLastCityForecast() {
        let lastSearch = itemList.first
        guard let name = lastSearch?.name else { return }
        fetchForecast(for: name)
    }

    private func deleteForecast(for cityId: Int) {
        guard let forecastToDelete = loadForecast(for: cityId) else { return }
        try? realm.write {
            try? CityForecastObject.er.all().realm?.delete(forecastToDelete)
        }
    }

    private func loadForecast(for cityId: Int) -> CityForecastObject? {
        return try? CityForecastObject.er.fromRealm(with: cityId)
    }

    private func saveForecast(_ forecast: CityForecast) {
        try? forecast.managedObject().er.save(update: true)
        if itemList.count >= 5, let lastCity = itemList.last, let id = lastCity.id {
            deleteForecast(for: id)
        }
    }

    private func fetchForecast(for cityName: String) {
        ACProgressHUD.shared.showHUD()
        fetchService.fetchForecast(for: cityName) { (response, error) in
            guard let forecast = response, forecast.name != nil else {
                self.showNotFound()
                return }
            self.saveForecast(forecast)
            self.selectedForecast = forecast
            self.resultsView.configure(with: CityForecastDataModel(forecast))
            self.configureMap(forecast.coordinates.coordinate)
            self.loadRecentForecasts()
            ACProgressHUD.shared.hideHUD()
        }
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }

    private func configureMap(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        let span: MKCoordinateSpan = MKCoordinateSpanMake(2, 2)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        annotation.coordinate = coordinate
        self.locationMap.setRegion(region, animated: true)
        self.locationMap.addAnnotation(annotation)
        self.locationMap.isZoomEnabled = true
        self.locationMap.showsScale = true
    }

    private func showNotFound() {
        showAlert(title: "Error", message: "City not found", actionTitle: "Ok")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell
        if cell == nil {
            cell = ItemCell(style: .default, reuseIdentifier: "ItemCell")
        }
        cell?.configure(with: CityForecastDataModel(itemList[indexPath.row]))

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = itemList[indexPath.row]
        guard let name = selectedCity.name else { return }
        fetchForecast(for: name)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedItem = itemList[indexPath.row]
            guard let id = deletedItem.id else { return }
            deleteForecast(for: id)
            itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else { return }
        fetchForecast(for: city)
        searchBar.resignFirstResponder()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard itemList.count == 0 else { return }
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let city = placemarks?[0].locality else { return }
            self.fetchForecast(for: city)
        })
    }
}

extension MainViewController: ResultsViewDelegate {
    func didPressRefresh() {
        guard let selectedForecast = self.selectedForecast, let cityName = selectedForecast.name else { return }
        fetchForecast(for: cityName)
    }
}
