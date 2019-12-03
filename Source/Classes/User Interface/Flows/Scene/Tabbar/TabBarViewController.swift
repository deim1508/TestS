//
//  TabBarViewController.swift
//  events
//
//  Created by halcyon on 1/7/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

protocol TabBarViewControllerDelegate: class {
    func addButtonTapped(on viewController: TabBarViewController)
}

class TabBarViewController: UITabBarController {
    weak var flowDelegate: TabBarViewControllerDelegate?
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_add_filled"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.bringSubview(toFront: addButton)
    }

    private func setupView() {
        addButton.backgroundColor = view.backgroundColor
        addButton.addTarget(self, action: #selector(didTappAddEvent), for: .touchUpInside)
        tabBar.addSubview(addButton)
        setupConstraints()
    }

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            addButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -Paddings.mediumBig)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func didTappAddEvent() {
        flowDelegate?.addButtonTapped(on: self)
    }
}
