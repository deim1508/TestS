//
//  TextFields.swift
//  learningproject
//
//  Created by halcyon on 12/11/18.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import UIKit

private struct Layout {
    ///1
    static let underLineHeight: CGFloat = 1.0
    ///0.3
    static let minimumFontSize: CGFloat = 0.3
}

enum TextFieldType {
    case email
    case password

    var title: String {
        switch  self {
        case .email:
            return Strings.emailTitle
        case .password:
            return Strings.passwordTitle
        }
    }

    var image: UIImage {
        switch self {
        case .email:
            return Icons.email
        case .password:
            return Icons.password
        }
    }
}

class GeneralTextField: UITextField {
    var hasError: Bool = false {
        didSet {
            if hasError {
                actualizeViews(color: Color.errorRed)
            } else {
                actualizeViews(color: Color.dustyGray)
            }
        }
    }
    private var underlineView: UIView!
    private var imageView: UIImageView!
    private var image: UIImage!
    private var type: TextFieldType
    private let padding = UIEdgeInsets(top: 0, left: Paddings.veryBig, bottom: 0, right: Paddings.verySmall)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        setupLayout()
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = Color.pampas
        minimumFontSize = Layout.minimumFontSize
        placeholder = type.title
        layer.cornerRadius = Radius.verySmall
        setupUnderline()

        leftView = UIView(frame: CGRect(x: 0, y: 0, width: Paddings.veryBig, height: Paddings.veryBig))
        guard let leftView = leftView else { return }
        leftViewMode = .always

        let imageView = setupImageView(image: type.image)
        leftView.addSubview(imageView)
        imageView.center = leftView.center
    }

    private func setupImageView(image: UIImage) -> UIImageView {
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.dustyGray
        return imageView
    }

    private func setupUnderline() {
        underlineView = UIView()
        underlineView.backgroundColor = Color.dustyGray
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)

        let constraints: [NSLayoutConstraint] = [
            underlineView.topAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.smallMedium + Layout.underLineHeight),
            underlineView.heightAnchor.constraint(equalToConstant: Layout.underLineHeight),
            underlineView.leftAnchor.constraint(equalTo: leftAnchor, constant: Paddings.veryBig),
            underlineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Paddings.small)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func actualizeViews(color: UIColor) {
        underlineView.backgroundColor = color
        imageView.tintColor = color
    }
}

extension GeneralTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hasError = false
        actualizeViews(color: Color.casablanca)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty && !hasError {
            actualizeViews(color: Color.dustyGray)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

