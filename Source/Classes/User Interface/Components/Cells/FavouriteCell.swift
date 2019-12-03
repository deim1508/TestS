//
//  FavouriteCell.swift
//  events
//
//  Created by halcyon on 1/11/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

class FavouriteCell: UICollectionViewCell {
    static let cellId = "eventCell"
    var viewModel: FavouriteCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_heart_active"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let eventImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = Radius.small
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = Color.blackShadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = Radius.small
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.pampas
        view.layer.opacity = 0.7
        view.layer.cornerRadius = Radius.small
        view.layer.shadowColor = Color.pampas.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = Radius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(size: .greaterThanMedium)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(size: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(size: .moreThanMedium)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let datasView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.pampas
        view.layer.opacity = 0.7
        view.layer.cornerRadius = Radius.small
        view.layer.shadowColor = Color.pampas.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = Radius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = Color.white
        layer.cornerRadius = Radius.small
        layer.shadowOffset = CGSize(width: 0, height: Paddings.verySmall)
        layer.shadowColor = Color.blackShadow.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = Radius.small
    }

    private func setupView() {
        favouriteButton.addTarget(self, action: #selector(didTappFavourite), for: .touchUpInside)
        eventImageView.addSubview(favouriteButton)
        addSubview(eventImageView)
        titleView.addSubview(titleLabel)
        eventImageView.addSubview(titleView)

        datasView.addSubview(dateLabel)
        datasView.addSubview(priceLabel)
        eventImageView.addSubview(datasView)

        setupConstraints()
    }

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            eventImageView.topAnchor.constraint(equalTo: topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            datasView.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: Paddings.verySmall),
            datasView.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -Paddings.verySmall),
            datasView.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -Paddings.small),

            dateLabel.leadingAnchor.constraint(equalTo: datasView.leadingAnchor, constant: Paddings.verySmall),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -Paddings.verySmall),
            dateLabel.bottomAnchor.constraint(equalTo: datasView.bottomAnchor, constant: -Paddings.small),
            dateLabel.topAnchor.constraint(equalTo: datasView.topAnchor, constant: Paddings.small),

            priceLabel.trailingAnchor.constraint(equalTo: datasView.trailingAnchor, constant: -Paddings.verySmall),
            priceLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),

            titleView.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: Paddings.small),
            titleView.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: Paddings.verySmall),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: -Paddings.verySmall),

            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: Paddings.verySmall),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -Paddings.verySmall),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: Paddings.verySmall),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -Paddings.verySmall),

            favouriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -Paddings.verySmall),
            favouriteButton.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: Paddings.verySmall)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func bindViewModel() {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        priceLabel.text = viewModel.price
        eventImageView.pin_setImage(from: viewModel.eventImageUrl, placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
    }

    @objc private func didTappFavourite() {
        viewModel.didTappFavourite()
    }
}
