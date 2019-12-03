//
//  EventListViewController.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

enum EventsType {
    case allEvent
    case myEvents
}

class EventListViewController: BaseViewController {
    var viewModel: EventListViewModel! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_settings"), for: .normal)
        return button
    }()
    private let favouriteEventButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_heart_active"), for: .normal)
        return button
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = Font.regular(size: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero)
        table.allowsSelection = false
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let screenType: EventsType

    init(type: EventsType) {
        screenType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        viewModel.viewControllerViewDidLoad(on: screenType)
    }

    private func setupNavigationBar() {
        if screenType == .allEvent {
            logoutButton.addTarget(self, action: #selector(didTappedLogOut), for: .touchUpInside)
            navigationItem.setRightBarButton(UIBarButtonItem(customView: logoutButton), animated: true)
            settingButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
            navigationItem.setLeftBarButton(UIBarButtonItem(customView: settingButton), animated: true)
        } else {
            editButton.setTitle(tableView.isEditing ? Strings.done : Strings.edit, for: .normal)
            editButton.setTitleColor(Theme.current.textColor, for: .normal)
            editButton.addTarget(self, action: #selector(didTappedEditEvents), for: .touchUpInside)
            navigationItem.setLeftBarButton(UIBarButtonItem(customView: editButton), animated: true)
            favouriteEventButton.addTarget(self, action: #selector(didTappFavouriteEvents), for: .touchUpInside)
            navigationItem.setRightBarButton(UIBarButtonItem(customView: favouriteEventButton), animated: true)
        }
    }

    override func setupView() {
        view.backgroundColor = Color.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.cellId)
        view.addSubview(tableView)
    }

    override func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func didTappedLogOut() {
       viewModel.didTappLogOut()
    }

    @objc private func didTapSettings() {
        viewModel.didTappSettings()
    }

    @objc private func didTappedEditEvents() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.setTitle(tableView.isEditing ? Strings.done : Strings.edit, for: .normal)
    }

    @objc private func didTappFavouriteEvents() {
        viewModel.seeAllFavouriteEvent()
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenType == .allEvent ? viewModel.events.count: viewModel.userEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.cellId, for: indexPath) as? EventCell else {
            assertionFailure(Strings.loadCellError)
            return UITableViewCell()
        }
        cell.viewModel = screenType == .allEvent ? viewModel.eventsCells[indexPath.row] : viewModel.userEventsCells[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.removeEvent(at: indexPath.row, screenType: screenType)
        default:
            return
        }
    }
}

extension EventListViewController: EventListViewDelegate {
    func shouldReloadData() {
        tableView.reloadData()
    }
}
