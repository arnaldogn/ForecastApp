//
//  ResultsView.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 06/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol ResultsViewDelegate: class {
    func didPressRefresh()
}

class ResultsView: UIView {
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Please select a city"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkText
        return view
    }()
    private let temperature: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let pressure: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let humidity: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let maxTemperature: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let minTemperature: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.fontAwesomeIcon(name: .refresh, textColor: .red, size: CGSize(width: 35, height: 35)), for: .normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshButtonTapped(sender:))))
        return button
    }()
    weak var delegate: ResultsViewDelegate?

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
    }

    @objc func refreshButtonTapped(sender: AnyObject) {
        delegate?.didPressRefresh()
    }

    private func setupViews() {
        addSubviewsForAutolayout(title, separator, temperature, pressure, humidity, maxTemperature, minTemperature, refreshButton)
        setupConstraints()
    }

    private func setupConstraints() {
        let views = ["title": title,
                     "separator": separator,
                     "temperature": temperature,
                     "pressure": pressure,
                     "humidity": humidity,
                     "maxTemperature": maxTemperature,
                     "minTemperature": minTemperature]

        addConstraints(
            NSLayoutConstraint.constraints("H:|-20-[title]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|-10-[separator]-10-|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[temperature]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[pressure]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[humidity]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[maxTemperature]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[minTemperature]-20-|", views: views),
            NSLayoutConstraint.constraints("V:|-10-[title]", views: views),
            NSLayoutConstraint.constraints("V:|-10-[title]-5-[separator(0.5)]-5-[temperature(25)][pressure(25)][humidity(25)][maxTemperature(25)][minTemperature(25)]", views: views))

        refreshButton.centerYAnchor.constraint(equalTo: humidity.centerYAnchor).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }

    func configure(with model: CityForecastDataModel) {
        title.text = model.name
        temperature.text = "Temperature: \(model.temperature) ºF"
        pressure.text = "Pressure: \(model.pressure) hPa"
        humidity.text = "Humidity: \(model.humidity) %"
        maxTemperature.text = "Max Temp: \(model.maxTemp) ºF"
        minTemperature.text = "Min Temp: \(model.minTemp) ºF"
        refreshButton.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
