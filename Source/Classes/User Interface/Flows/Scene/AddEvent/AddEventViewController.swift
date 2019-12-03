//
//  AddEventViewController.swift
//  events
//
//  Created by halcyon on 1/7/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

class AddEventViewController: BaseViewController {
    var viewModel: AddEventViewModel!
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
        return button
    }()
    private let createEventButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.create, for: .normal)
        return button
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.minimumDate = Date()
        picker.backgroundColor = Color.white
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date.getFormattedDate(from: Date())
        label.textColor = Theme.current.mainColor
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let startTitleLabel: GeneralLabel = {
        let label = GeneralLabel(type: .start)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let addressView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let locationTitleLabel: GeneralLabel = {
        let label = GeneralLabel(type: .location)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let locationTextField: UITextField = {
        let view = UITextField()
        view.placeholder = Strings.chooseLocation
        view.textColor = Theme.current.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var locationsDropDown: UIPickerView = {
        return UIPickerView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.viewControllerViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.textColor = Theme.current.mainColor
        locationTextField.textColor = Theme.current.mainColor
        createEventButton.setTitleColor(Theme.current.mainColor, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar(true)
    }

    private func setupNavBar(_ translucent: Bool) {
        closeButton.addTarget(self, action: #selector(didTappClose), for: .touchUpInside)
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: closeButton), animated: true)
        createEventButton.addTarget(self, action: #selector(didTappCreateEvent), for: .touchUpInside)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: createEventButton), animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func setupView() {
        view.backgroundColor = Color.pampas

        locationTextField.delegate = self
        locationTextField.inputView = locationsDropDown
        locationsDropDown.delegate = self
        locationsDropDown.dataSource = self

        addressView.addSubview(locationTextField)
        addressView.addSubview(locationTitleLabel)
        view.addSubview(addressView)

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.addSubview(dateLabel)
        datePicker.addSubview(startTitleLabel)
        view.addSubview(datePicker)

        setupConstraints()
    }

    override func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            startTitleLabel.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: Paddings.veryBig),
            startTitleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),

            dateLabel.topAnchor.constraint(equalTo: datePicker.topAnchor, constant: Paddings.small),
            dateLabel.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor, constant: -Paddings.smallMedium),

            addressView.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -Paddings.medium),
            addressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            addressView.rightAnchor.constraint(equalTo: view.rightAnchor),
            addressView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),

            locationTitleLabel.leadingAnchor.constraint(equalTo: addressView.leadingAnchor, constant: Paddings.veryBig),
            locationTitleLabel.centerYAnchor.constraint(equalTo: addressView.centerYAnchor),

            locationTextField.trailingAnchor.constraint(equalTo: addressView.trailingAnchor, constant: -Paddings.smallMedium),
            locationTextField.centerYAnchor.constraint(equalTo: addressView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func didTappClose() {
        viewModel.dismissScreen(on: self)
    }

    @objc private func didTappCreateEvent() {
        viewModel.createEvent()
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dateLabel.text = Date.getFormattedDate(from: sender.date)
        viewModel.selectDate(date: sender.date)
    }
}

extension AddEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.locations.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.locations[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationTextField.text = viewModel.locations[row]
        viewModel.selectLocation(at: row)
        locationsDropDown.isHidden = true
        locationTextField.endEditing(true)
    }
}

extension AddEventViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == locationTextField {
            self.locationsDropDown.isHidden = false
            textField.endEditing(true)
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

