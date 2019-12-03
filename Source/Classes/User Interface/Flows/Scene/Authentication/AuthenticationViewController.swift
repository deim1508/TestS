//
//  AuthenticationViewController.swift
//  events
//
//  Created by halcyon on 12/12/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

enum AuthenticationType {
    case logIn
    case signUp
}

class AuthenticationViewController: UIViewController {
    var viewModel: AuthenticationViewModel!
    private var logoImageView: UIImageView!
    private var authenticationView: UIView!
    private var welcomeLabel: UILabel!
    private var emailTextField: GeneralTextField!
    private var passwordTextField: GeneralTextField!
    private var authenticationButton: UIButton!
    private var signupMessageLabel: UILabel?
    private var signupButton: UIButton?
    private var stackView: UIStackView?
    private var authenticationViewCenterConstrant: NSLayoutConstraint!

    private var screenType: AuthenticationType!
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    init(type: AuthenticationType) {
        screenType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        setupView()
        setupView(type: screenType)
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        backgroundImageView.image = viewModel.getRandomImage()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        emailTextField.hasError = false
        passwordTextField.hasError = false
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = screenType == .logIn
    }

    private func setupView() {
        title = screenType == .logIn ? Strings.loginTitle : Strings.signupTitle
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        backgroundImageView.image = viewModel.getRandomImage()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        logoImageView = UIImageView(image: #imageLiteral(resourceName: "eventmobi-logo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(logoImageView)

        authenticationView = UIView()
        authenticationView.backgroundColor = Color.pampasTransp
        authenticationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(authenticationView)

        welcomeLabel = UILabel()
        welcomeLabel.text = screenType == .logIn ? Strings.welcomeBack : Strings.welcome
        welcomeLabel.font = Font.bold(size: .large)
        welcomeLabel.textColor = Color.orange
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.addSubview(welcomeLabel)

        emailTextField = GeneralTextField(type: TextFieldType.email)
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.addSubview(emailTextField)

        passwordTextField = GeneralTextField(type: TextFieldType.password)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.addSubview(passwordTextField)

        authenticationButton = UIButton()
        let buttonTitle = screenType == .logIn ? Strings.loginTitle : Strings.signupTitle
        authenticationButton.setTitle(buttonTitle, for: .normal)
        authenticationButton.titleLabel?.font = Font.regular(size: .greaterThanMedium)
        authenticationButton.backgroundColor = Color.casablanca
        authenticationButton.layer.cornerRadius = Radius.small
        authenticationButton.layer.shadowOpacity = 1
        authenticationButton.layer.shadowRadius = Radius.small
        authenticationButton.layer.shadowOffset = CGSize(width: 0, height: Paddings.verySmall)
        authenticationButton.layer.shadowColor = Color.orange.cgColor
        authenticationButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        authenticationButton.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.addSubview(authenticationButton)
    }

    private func setupView(type: AuthenticationType) {
        if screenType == .logIn {
            signupMessageLabel = UILabel()
            signupMessageLabel?.text = Strings.singupMessage
            signupMessageLabel?.textColor = Color.white
            signupMessageLabel?.textAlignment = .right
            signupMessageLabel?.adjustsFontSizeToFitWidth = true
            signupMessageLabel?.backgroundColor = Color.clear
            signupMessageLabel?.font = Font.bold(size: .medium)

            signupButton = UIButton()
            signupButton?.setTitle(Strings.signupTitle, for: .normal)
            signupButton?.titleLabel?.font = Font.bold(size: .greaterThanMedium)
            signupButton?.setTitleColor(Color.white, for: .normal)
            signupButton?.backgroundColor = Color.clear
            signupButton?.addTarget(self, action: #selector(didTappedSignUpButton), for: .touchUpInside)

            guard let signupLabel = signupMessageLabel, let signupButton = signupButton else { return }

            stackView = UIStackView()
            stackView?.axis = .horizontal
            stackView?.alignment = .fill
            stackView?.distribution = .fillProportionally
            stackView?.spacing = Paddings.verySmall

            stackView?.addArrangedSubview(signupLabel)
            stackView?.addArrangedSubview(signupButton)
            stackView?.translatesAutoresizingMaskIntoConstraints = false

            guard let stackView = stackView else { return }
            backgroundImageView.addSubview(stackView)
        }
        setupSignUpMessageConstraints()
    }

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            authenticationView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: Paddings.extraBig),
            authenticationView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -Paddings.extraBig),

            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: backgroundImageView.topAnchor, constant: Paddings.small),
            logoImageView.bottomAnchor.constraint(equalTo: authenticationView.topAnchor, constant: -Paddings.bigg),
            logoImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 0.13),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),

            welcomeLabel.leftAnchor.constraint(equalTo: authenticationView.leftAnchor, constant: Paddings.medium),
            welcomeLabel.topAnchor.constraint(equalTo: authenticationView.topAnchor, constant: Paddings.small),
            welcomeLabel.rightAnchor.constraint(lessThanOrEqualTo: authenticationView.rightAnchor, constant: -Paddings.medium),

            emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Paddings.smallMedium),
            emailTextField.leftAnchor.constraint(equalTo: authenticationView.leftAnchor, constant: Paddings.medium),
            emailTextField.rightAnchor.constraint(equalTo: authenticationView.rightAnchor, constant: -Paddings.medium),
            emailTextField.heightAnchor.constraint(equalToConstant: Paddings.bigg + 2),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Paddings.smallMedium),
            passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            authenticationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Paddings.big),
            authenticationButton.heightAnchor.constraint(equalToConstant: Paddings.bigg),
            authenticationButton.leftAnchor.constraint(equalTo: emailTextField.leftAnchor, constant: Paddings.medium),
            authenticationButton.rightAnchor.constraint(equalTo: emailTextField.rightAnchor, constant: -Paddings.medium),
            authenticationButton.bottomAnchor.constraint(equalTo: authenticationView.bottomAnchor, constant: -Paddings.big)
        ]
        NSLayoutConstraint.activate(constraints)

        authenticationViewCenterConstrant = authenticationView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -Paddings.medium)
        authenticationViewCenterConstrant.isActive = true
    }

    private func setupSignUpMessageConstraints() {
        guard let stackView = stackView else { return }
        let constraints: [NSLayoutConstraint] = [
            stackView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: Paddings.veryBig),
            stackView.leftAnchor.constraint(greaterThanOrEqualTo: authenticationView.leftAnchor, constant: Paddings.mediumBig),
            stackView.rightAnchor.constraint(lessThanOrEqualTo: authenticationView.rightAnchor, constant: -Paddings.medium),
            stackView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -Paddings.big)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func authButtonTapped() {
        emailTextField.hasError = isTextFieldEmpty(textField: emailTextField)
        passwordTextField.hasError = isTextFieldEmpty(textField: passwordTextField)
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        if !emailTextField.hasError && !passwordTextField.hasError {
            viewModel.email = emailText
            viewModel.password = passwordText
            authenticationButton.isEnabled = false
            viewModel.didTappedAuthenticationButton(completion: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.authenticationButton.isEnabled = true
            })
        }
    }

    private func isTextFieldEmpty(textField: GeneralTextField) -> Bool {
        if let text = textField.text {
            return text.isEmpty
        }
        return true
    }

    @objc private func didTappedSignUpButton() {
       viewModel.didTappedChangeLoginToSignup()
    }

    @objc private func handleTap() {
        view.endEditing(true)
    }

    @objc private func handleKeyboardNotification(notification: Notification) {
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
            self.authenticationViewCenterConstrant.constant = isKeyboardShowing ? -Paddings.veryBig : 0
        })
    }
}
