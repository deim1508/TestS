//
//  EventCell.swift
//  events
//
//  Created by halcyon on 1/7/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit
import PINRemoteImage

class EventCell: UITableViewCell {
    static let cellId = "eventCell"
    var viewModel: EventCellViewModel! {
        didSet {
            viewModel.viewDelegate = self
            bindViewModel()
        }
    }
    private let eventImageView: UIImageView = {
        let view = UIImageView()
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = Color.blackShadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = Radius.small
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.alpha = 0.4
        return blur
    }()

    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    private let eventTypeImageView: GeneralImageView = {
        let view = GeneralImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Color.white

        eventImageView.isUserInteractionEnabled = true
        contentView.addSubview(eventImageView)
        eventImageView.addSubview(blurEffectView)

        datasView.addSubview(titleLabel)
        datasView.addSubview(dateLabel)

        eventImageView.addSubview(datasView)

        favouriteButton.addTarget(self, action: #selector(didTappFavourite), for: .touchUpInside)
        eventImageView.addSubview(favouriteButton)
        eventImageView.addSubview(eventTypeImageView)

        setupConstraints()
    }

    private func setEventTypeImage(name: String) {
        switch name {
        case "Conference":
            let im = ConferenceDecorator(imageView: eventTypeImageView)
            im.setImage()
        case "Private":
            let im = PrivateDecorator(imageView: eventTypeImageView)
            im.setImage()
        case "Party":
            let im = PartyDecorator(imageView: eventTypeImageView)
            im.setImage()
        default:
            let im = EmptyDecorator(imageView: eventTypeImageView)
            im.setImage()
        }
    }

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            eventImageView.topAnchor.constraint(equalTo: topAnchor, constant: Paddings.verySmall),
            eventImageView.leftAnchor.constraint(equalTo: leftAnchor),
            eventImageView.rightAnchor.constraint(equalTo: rightAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            blurEffectView.topAnchor.constraint(equalTo: topAnchor, constant: Paddings.verySmall),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Paddings.medium),
            favouriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Paddings.medium),

            datasView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            datasView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Paddings.bigg),
            datasView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Paddings.bigg),
            datasView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Paddings.big),
            datasView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Paddings.small),

            titleLabel.leadingAnchor.constraint(equalTo: datasView.leadingAnchor, constant: Paddings.small),
            titleLabel.topAnchor.constraint(equalTo: datasView.topAnchor, constant: Paddings.verySmall),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: datasView.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Paddings.verySmall),
            dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: datasView.bottomAnchor, constant: -Paddings.verySmall),

            eventTypeImageView.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -Paddings.medium),
            eventTypeImageView.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -Paddings.medium),
            eventTypeImageView.topAnchor.constraint(greaterThanOrEqualTo: favouriteButton.bottomAnchor)

        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func bindViewModel() {
        if viewModel.screenType == .myEvents {
            favouriteButton.removeFromSuperview()
        }
        eventImageView.pin_setImage(from: viewModel.eventImageUrl, placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
        favouriteButton.setImage(viewModel.isFavourite ? #imageLiteral(resourceName: "icon_heart_active") : #imageLiteral(resourceName: "icons8-heart-outline-40"), for: .normal)
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        setEventTypeImage(name: viewModel.eventTypeName)
    }

    @objc private func didTappFavourite() {
        viewModel.didTappFavourite()
    }
}

extension EventCell: EventCellViewCellDelegate {
    func shouldChangeFavouriteIconColor() {
        UIView.animate(withDuration: 0.4) {
            self.favouriteButton.setImage(self.viewModel.isFavourite ? #imageLiteral(resourceName: "icon_heart_active") : #imageLiteral(resourceName: "icons8-heart-outline-40"), for: .normal)
        }
    }
}
