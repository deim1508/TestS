//
//  SetEventDetailsViewController.swift
//  events
//
//  Created by halcyon on 1/9/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

class SetEventDetailViewController: BaseViewController {
    var viewModel: SetEventDetailViewModel! {
        didSet {
            viewModel.viewDelegate = self
            bindViewModel()
        }
    }
    private let finishEventButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.finish, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let coverImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "image_placeholder")
        view.layer.shadowColor = Color.blackShadow.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = Radius.small
        view.layer.shadowOpacity = 1
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let uploadImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.pampas
        button.layer.cornerRadius = Radius.verySmall
        button.layer.shadowRadius = Radius.small
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowColor = Color.blackShadow.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.setTitle(Strings.uploadImage, for: .normal)
        button.setTitleShadowColor(Color.blackShadow, for: .normal)
        button.titleLabel?.font = Font.regular(size: .moreThanMedium)
        button.setTitleColor(Color.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let titleLabel: GeneralLabel = {
        let label = GeneralLabel(type: .title)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.eventName
        textField.textColor = Theme.current.mainColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let addmissionFeeLabel: GeneralLabel = {
        let label = GeneralLabel(type: .addmission)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let addmissionFeeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.concrateAddmissionFee
        textField.textColor = Theme.current.mainColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let eventTypeLabel: GeneralLabel = {
        let label = GeneralLabel(type: .eventType)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = Color.pampas
        tableView.layer.cornerRadius = Radius.small
        tableView.layer.shadowColor = Color.blackShadow.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowRadius = Radius.small
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let eventTypeImageView: GeneralImageView = {
        let view = GeneralImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let descriptionLabel: GeneralLabel = {
        let label = GeneralLabel(type: .description)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = Radius.small
        view.font = Font.regular(size: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        finishEventButton.setTitleColor(Theme.current.mainColor, for: .normal)
        nameTextField.textColor = Theme.current.mainColor
    }

    override func setupView() {
        view.backgroundColor = Color.pampas

        uploadImageButton.addTarget(self, action: #selector(didUploadImage), for: .touchUpInside)
        coverImageView.addSubview(uploadImageButton)
        coverImageView.addSubview(eventTypeImageView)
        view.addSubview(coverImageView)

        finishEventButton.addTarget(self, action: #selector(didTappFinishSetting), for: .touchUpInside)
        view.addSubview(finishEventButton)

        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(addmissionFeeLabel)
        view.addSubview(addmissionFeeTextField)
        view.addSubview(eventTypeLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)


        setupConstraints()
    }

    override func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            finishEventButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Paddings.extraBig),
            finishEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.mediumBig),

            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            coverImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            coverImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            uploadImageButton.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            uploadImageButton.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor, constant: Paddings.extraBig + 6),

            eventTypeImageView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: Paddings.big),
            eventTypeImageView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -Paddings.smallMedium),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Paddings.smallMedium),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Paddings.mediumBig),

            nameTextField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Paddings.medium),

            addmissionFeeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Paddings.big),
            addmissionFeeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            addmissionFeeTextField.centerYAnchor.constraint(equalTo: addmissionFeeLabel.centerYAnchor),
            addmissionFeeTextField.leadingAnchor.constraint(equalTo: addmissionFeeLabel.trailingAnchor, constant: Paddings.smallMedium),

            eventTypeLabel.topAnchor.constraint(equalTo: addmissionFeeLabel.bottomAnchor, constant: Paddings.big),
            eventTypeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            tableView.topAnchor.constraint(equalTo: eventTypeLabel.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: eventTypeLabel.trailingAnchor, constant: Paddings.medium),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(Paddings.extraBig * 2)),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

            descriptionLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Paddings.medium),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: Paddings.smallMedium),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.mediumBig),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func bindViewModel() {

    }

    @objc private func didUploadImage() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }

    @objc private func didTappFinishSetting() {
        viewModel.didFinishSettings(on: self, name: nameTextField.text!, addmission: addmissionFeeTextField.text!, description: descriptionTextView.text!)
    }
}

extension SetEventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.eventTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = Color.white
        cell.selectionStyle = .none
        let eventType = viewModel.eventTypes[indexPath.row]
        cell.textLabel?.text =  eventType.name
        cell.textLabel?.font = Font.regular(size: .medium)
        cell.accessoryType = viewModel.selectedEventTypeIndex == indexPath.row ? .checkmark: .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = viewModel.selectedEventTypeIndex == indexPath.row ? -1: indexPath.row
        switch index {
        case 0:
            let im = ConferenceDecorator(imageView: eventTypeImageView)
            im.setImage()
        case 1:
            let im = PrivateDecorator(imageView: eventTypeImageView)
            im.setImage()
        case 2:
            let im = PartyDecorator(imageView: eventTypeImageView)
            im.setImage()
        default:
            let im = EmptyDecorator(imageView: eventTypeImageView)
            im.setImage()
        }
        viewModel.didSelectEventType(at: index)
    }
}

extension SetEventDetailViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        coverImageView.image = image_data
        uploadImageButton.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
        guard let image = coverImageView.image else { return }
        viewModel.uploadImage(image: image)
    }
}

extension SetEventDetailViewController: SetEventDetailViewDelegate {
    func shouldReloadData() {
        tableView.reloadData()
    }

    func addImageDecorator(image: UIImage) {
        eventTypeImageView.image = image
    }
}
