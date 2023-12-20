//
//  LogInViewController.swift
//  Navigation
//
//  Created by DmitriiG on 17.04.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


protocol CheckerServiceProtocol: AnyObject {
    func checkCredentials(login: String, password: String, completion: @escaping (Bool, String?) -> Void)
}

protocol LoginViewControllerDelegate: AnyObject {
    func checkCredentials(login: String, password: String, completion: @escaping (Bool, String?) -> Void)
}

final class LogInViewController: UIViewController, CheckerServiceControllerProtocol {
    
    let coordinator: ProfileCoordinatorProtocol
    let localAuthorizationService = LocalAuthorizationService()
    private var authorizationType: LocalAuthorizationService.BiometricType?
    
    var delegate: LoginViewControllerDelegate? // класс, ответственный за авторизацию, соответствует протоколу LoginViewControllerDelegate, то есть имеет 2 функции (проверка и подписка)
    
    var logInScrollView: UIScrollView = {
        var logInScroll = UIScrollView()
        logInScroll.backgroundColor = CustomColors.customViewColor
        logInScroll.isScrollEnabled = true
        logInScroll.showsVerticalScrollIndicator = true
        logInScroll.translatesAutoresizingMaskIntoConstraints = false
        return logInScroll
    }()
    
    var logInContentView: UIView = {
        let logInView = UIView()
        logInView.backgroundColor = CustomColors.customViewColor
        logInView.contentMode = .top
        logInView.translatesAutoresizingMaskIntoConstraints = false
        return logInView
    }()
    
    let vkImageView: UIImageView = {
        let vk = UIImageView()
        let vkImage = UIImage(named: "logo")
        vk.image = vkImage
        vk.contentMode = .scaleAspectFit
        vk.translatesAutoresizingMaskIntoConstraints = false
        return vk
    }()
    
    let loginField: UIView = {
        let loginField = UIView()
        loginField.backgroundColor = CustomColors.customGray
        loginField.layer.borderWidth = 0.5
        loginField.layer.borderColor = CustomColors.customButtonBlue.cgColor
        loginField.layer.cornerRadius = 10
        loginField.translatesAutoresizingMaskIntoConstraints = false
        return loginField
    }()
    
    let nameTextField: UITextField = {
        let nameText = UITextField()
        nameText.backgroundColor = CustomColors.customGray
        nameText.layer.borderWidth = 0.5
        nameText.layer.borderColor = CustomColors.customButtonBlue.cgColor
        nameText.clipsToBounds = true
        nameText.layer.cornerRadius = 10
        nameText.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nameText.textColor = CustomColors.customTextColor
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        nameText.leftViewMode = .always
        nameText.leftView = spacerView
        nameText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameText.tintColor = UIColor(named: "AccentColor")
        nameText.autocapitalizationType = .none
        nameText.placeholder = "E-mail"
        nameText.translatesAutoresizingMaskIntoConstraints = false
        return nameText
    }()
    
    let passwordTextField: UITextField = {
        let passwordText = UITextField()
        passwordText.backgroundColor = CustomColors.customGray
        passwordText.textColor = CustomColors.customTextColor
        passwordText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordText.tintColor = UIColor(named: "AccentColor")
        passwordText.autocapitalizationType = .none
        passwordText.placeholder = "password".localizable
        passwordText.isSecureTextEntry = true
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        return passwordText
    }()
    
    private func loadPosts() {
        
        FirebaseSingleton.shared.retrievePost { profPosts in
           FavoritesCoreData.shared.addAllpostProf(postProf: profPosts)
        } completionFav: { favPosts in
            FavoritesCoreData.shared.addAllpostFav(postFav: favPosts)
        }
    }
    
    private lazy var logInButton = CustomButton(
        title: (name: "log_in".localizable, state: nil),
        titleColor: (color: nil, state: nil),
        titleLabelColor: CustomColors.customLabelTextColor,
        titleFont: nil,
        cornerRadius: 10,
        backgroundColor: CustomColors.customButtonColor,
        backgroundImage: (image: UIImage(named: "blue_pixel"), state: nil),
        clipsToBounds: true, action: {
            [weak self] in
            self!.disableSignInButton()
            self!.addActivityIndicator()
            self!.activityIndicatior.startAnimating()
            self!.delegate?.checkCredentials(login: self!.nameTextField.text!, password: self!.passwordTextField.text!) { result, error in

                if result {
                    FavoritesCoreData.shared.emptyUserList()
                    FavoritesCoreData.shared.deleteAll(type: .favorites)
                    FavoritesCoreData.shared.deleteAll(type: .profile)
                    FavoritesCoreData.shared.changeStatusToTrue()
                    let user = Auth.auth().currentUser
                    if let user = user {
                        FirebaseSingleton.shared.retrieveStatus { status in
                            let mail = user.email
                            let name = user.displayName
                            let avatar = user.photoURL
                            let userToSave = DUser(mail: mail!, name: name!, avatar: avatar, status: status)
                            FavoritesCoreData.shared.saveCurrentUser(user: userToSave)
                            self!.loadPosts()
                            self!.activityIndicatior.stopAnimating()
                            self!.callAlertViewSignInSuccess()
                           
                        }
                    }
                } else {
                    self!.activityIndicatior.stopAnimating()
                    self!.enableSignInButton()
                    self!.callAlertViewCredentialFailure(error: error ?? "password_login_incorrect".localizable)
                }
            }
            
        })
    
    private lazy var IDButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.buttonSize = .large
        configuration.cornerStyle = .medium
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .center
        configuration.imagePadding = 8.0
        
        let action = UIAction { action in
            self.authorizeIfPossible { success in
                if success {
                    FavoritesCoreData.shared.changeStatusToTrue()
                    self.goToProfilePage()
                }
            }
        }
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configurationUpdateHandler = {
            button in
            var configuration = button.configuration
            configuration?.image = self.authorizationType == .faceID ? UIImage(systemName: "faceid"): UIImage(systemName: "touchid")
            configuration?.title = self.authorizationType == .faceID ? "FaceID": "TouchID"
            button.configuration = configuration
        }
        return button
    }()
    
    private lazy var goToSignUpButton = CustomButton(title: ("signUp".localizable, nil), titleColor: (CustomColors.customButtonBlue, nil), titleLabelColor: nil, titleFont: nil, cornerRadius: nil, backgroundColor: nil, backgroundImage: (nil, nil), clipsToBounds: nil, image: nil) {
        self.coordinator.signUpViewController(coordinator: self.coordinator)
    }
    
    private let activityIndicatior: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = CustomColors.customLabelColor
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    //MARK: - init
    init(coordinator: ProfileCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = CustomColors.customViewColor
        launchCanEvaluate()
        addAllViews()
        setAllConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCentre.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCentre = NotificationCenter.default
        notificationCentre.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCentre.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func disableSignInButton() {
        logInButton.isEnabled = false
    }
    
    private func enableSignInButton() {
        logInButton.isEnabled = true
    }
    
    private func addActivityIndicator() {
        logInContentView.addSubview(activityIndicatior)
        NSLayoutConstraint.activate(
            [
                activityIndicatior.leadingAnchor.constraint(equalTo: self.logInContentView.leadingAnchor, constant: 16),
                activityIndicatior.trailingAnchor.constraint(equalTo: self.logInContentView.trailingAnchor, constant: -16),
                activityIndicatior.topAnchor.constraint(equalTo: self.vkImageView.bottomAnchor, constant: 120),
                activityIndicatior.heightAnchor.constraint(equalToConstant: 100),
            ])
        
    }
    
    private func addAllViews() {
        view.addSubview(logInScrollView)
        logInScrollView.addSubview(logInContentView)
        logInContentView.addSubview(vkImageView)
        logInContentView.addSubview(goToSignUpButton)
        if FavoritesCoreData.shared.isIDToUse {
            logInContentView.addSubview(IDButton)
        } else {
            logInContentView.addSubview(loginField)
            logInContentView.addSubview(logInButton)
            loginField.addSubview(nameTextField)
            loginField.addSubview(passwordTextField)
        }
        
    }
    
    private func setAllConstraints() {
        NSLayoutConstraint.activate(
            [
                logInScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
                logInScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                logInScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                logInScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                logInContentView.topAnchor.constraint(equalTo: self.logInScrollView.topAnchor),
                logInContentView.bottomAnchor.constraint(equalTo: self.logInScrollView.bottomAnchor),
                logInContentView.leadingAnchor.constraint(equalTo: self.logInScrollView.leadingAnchor),
                logInContentView.trailingAnchor.constraint(equalTo: self.logInScrollView.trailingAnchor),
                logInContentView.widthAnchor.constraint(equalTo: self.logInScrollView.widthAnchor),
                
                vkImageView.centerXAnchor.constraint(equalTo: self.logInContentView.centerXAnchor),
                vkImageView.topAnchor.constraint(equalTo: self.logInContentView.topAnchor, constant: 120),
                vkImageView.widthAnchor.constraint(equalToConstant: 100),
                vkImageView.heightAnchor.constraint(equalToConstant: 100),
            ]
        )
        if FavoritesCoreData.shared.isIDToUse {
            NSLayoutConstraint.activate(
                [
                    //                    IDButton.leadingAnchor.constraint(equalTo: self.logInContentView.leadingAnchor, constant: 16),
                    //                    IDButton.trailingAnchor.constraint(equalTo: self.logInContentView.trailingAnchor, constant: -16),
                    IDButton.topAnchor.constraint(equalTo: self.vkImageView.bottomAnchor, constant: 120),
                    IDButton.centerXAnchor.constraint(equalTo: self.logInContentView.centerXAnchor),
                    
                    IDButton.heightAnchor.constraint(equalToConstant: 100),
                    
                    goToSignUpButton.topAnchor.constraint(equalTo: IDButton.bottomAnchor, constant: 10),
                    goToSignUpButton.trailingAnchor.constraint(equalTo: logInContentView.trailingAnchor, constant: -16),
                    goToSignUpButton.heightAnchor.constraint(equalToConstant: 50),
                    goToSignUpButton.bottomAnchor.constraint(equalTo: logInContentView.bottomAnchor, constant: -16),
                    
                ])
            
        } else {
            NSLayoutConstraint.activate(
                [
                    loginField.leadingAnchor.constraint(equalTo: self.logInContentView.leadingAnchor, constant: 16),
                    loginField.trailingAnchor.constraint(equalTo: self.logInContentView.trailingAnchor, constant: -16),
                    loginField.topAnchor.constraint(equalTo: self.vkImageView.bottomAnchor, constant: 120),
                    loginField.heightAnchor.constraint(equalToConstant: 100),
                    
                    nameTextField.leadingAnchor.constraint(equalTo: self.loginField.leadingAnchor),
                    nameTextField.trailingAnchor.constraint(equalTo: self.loginField.trailingAnchor),
                    nameTextField.topAnchor.constraint(equalTo: self.loginField.topAnchor),
                    nameTextField.heightAnchor.constraint(equalToConstant: 50),
                    
                    passwordTextField.leadingAnchor.constraint(equalTo: self.loginField.leadingAnchor, constant: 10),
                    passwordTextField.trailingAnchor.constraint(equalTo: self.loginField.trailingAnchor),
                    passwordTextField.bottomAnchor.constraint(equalTo: self.loginField.bottomAnchor),
                    passwordTextField.heightAnchor.constraint(equalToConstant: 50),
                    
                    logInButton.leadingAnchor.constraint(equalTo: self.logInContentView.leadingAnchor, constant: 16),
                    logInButton.trailingAnchor.constraint(equalTo: self.logInContentView.trailingAnchor, constant: -16),
                    logInButton.topAnchor.constraint(equalTo: self.loginField.bottomAnchor, constant: 16),
                    logInButton.heightAnchor.constraint(equalToConstant: 50),
                    
                    goToSignUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 10),
                    goToSignUpButton.trailingAnchor.constraint(equalTo: logInContentView.trailingAnchor, constant: -16),
                    goToSignUpButton.heightAnchor.constraint(equalToConstant: 50),
                    goToSignUpButton.bottomAnchor.constraint(equalTo: logInContentView.bottomAnchor, constant: -16),
                ])
        }
    }
    
    
    
    func goToProfilePage() {
        coordinator.profileViewController(coordinator: coordinator, navControllerFromFactory: nil)
    }
    
    
    func callAlertViewSignInSuccess() {
        
        let alert = CustomAlert.shared.createAlertWithTwoCompletion(title: "successful_signIn".localizable, message: "useFaceID".localizable, placeholder: nil, titleAction1: "yes".localizable, action1: {
            FavoritesCoreData.shared.changeAuthMethod()
            self.goToProfilePage()
        }, titleAction2: "no".localizable) {
            self.goToProfilePage()
        }
        present(alert, animated: true)
    }
    
    func callAlertViewCredentialFailure(error: String) {
        self.createAlertView(viewTitle: "error".localizable, message: error, actionTitle: "Ок", action: nil)
    }
    
    private func createAlertView(viewTitle: String, message: String, actionTitle: String, action: (() -> Void)?) {
        let alertView = UIAlertController(title: viewTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { UIAlertAction in
            guard let actionUnwrapped = action else {return}
            actionUnwrapped()
        }
        alertView.addAction(action)
        present(alertView, animated: true)
    }
    
    @objc private func handleKeyboardShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.logInScrollView.contentInset.bottom = keyboardFrame.height
            self.logInScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0,bottom: keyboardFrame.height, right: 0)
        }
    }
    
    @objc private func handleKeyboardHide(notification: NSNotification) {
        self.logInScrollView.contentInset.bottom = .zero
        self.logInScrollView.verticalScrollIndicatorInsets = .zero
    }
    
    private func launchCanEvaluate() {
        localAuthorizationService.canEvaluate { canEvaluate, type, canEvaluateError in
            authorizationType = type
        }
    }
    
    private func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        localAuthorizationService.canEvaluate { canEvaluate, type, canEvaluateError in
            guard canEvaluate else {
                self.createAlertView(viewTitle: "error".localizable, message: canEvaluateError?.errorDescriprion ?? "FaceIDTouchIDnotConfigured".localizable, actionTitle: "ok", action: nil)
                return
            }
            localAuthorizationService.evaluate { [weak self] (success, error) in
                guard success else {
                    if error == .userFallback {
                        FavoritesCoreData.shared.changeAuthMethod()
                        self!.view.layoutIfNeeded()
                    }
                    return
                }
                authorizationFinished(true)
            }
        }
    }
}
