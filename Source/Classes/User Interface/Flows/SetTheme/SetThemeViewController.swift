//
//  SetThemeViewController.swift
//  events
//
//  Created by halcyon on 12/21/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

class SetThemeViewController: UIViewController {
    var viewModel: SetThemeViewModel!
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
        button.addTarget(self, action: #selector(didTappClose), for: .touchUpInside)
        return button
    }()
    private let themeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.theme
        label.textColor = Color.darkGray
        return label
    }()
    private let segmentControlView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.white
        return view
    }()
    private let themeSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [Strings.general, Strings.dark, Strings.magic])
        segmentControl.selectedSegmentIndex = Theme.current.rawValue
        segmentControl.addTarget(self, action: #selector(didTappApply), for: .valueChanged)
        return segmentControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = Color.pampas

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        themeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeTitleLabel)

        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControlView)

        themeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControlView.addSubview(themeSegmentControl)

        setupConstraints()
    }

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Paddings.veryBig),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.smallMedium),

            themeTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.veryBig),
            themeTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 2 * Paddings.extraBig),

            segmentControlView.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: Paddings.verySmall),
            segmentControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            themeSegmentControl.topAnchor.constraint(equalTo: segmentControlView.topAnchor, constant: Paddings.smallMedium),
            themeSegmentControl.leadingAnchor.constraint(equalTo: segmentControlView.leadingAnchor, constant: Paddings.veryBig),
            themeSegmentControl.trailingAnchor.constraint(equalTo: segmentControlView.trailingAnchor, constant: -Paddings.veryBig),
            themeSegmentControl.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor, constant: -Paddings.smallMedium)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func didTappClose() {
        viewModel.dismissScreen()
    }

    @objc private func didTappApply() {
        viewModel.applyTheme(at: themeSegmentControl.selectedSegmentIndex)
    }
}
