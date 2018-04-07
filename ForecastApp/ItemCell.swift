//
//  ItemCell.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 05/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkText
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none
        contentView.addSubviewsForAutolayout(name, separator)
        setupConstraints()
    }

    private func setupConstraints() {
        let views: [String: Any] = ["name": name,
                                    "separator": separator]
        contentView.addConstraints(
            NSLayoutConstraint.constraints("H:|-20-[name]-20-|", views: views),
            NSLayoutConstraint.constraints("H:|-20-[separator]-20-|", views: views),
            NSLayoutConstraint.constraints("V:|[name][separator(0.5)]|", views: views))
    }

    func configure(with item: CityForecastDataModel) {
        name.text = item.name
    }
}

