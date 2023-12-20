//
//  SignUpViewController.swift
//  Diploma
//
//  Created by DmitriiG on 03.10.2023.
//

import UIKit
import FirebaseAuth

protocol SignUpServiceProtocol: AnyObject {
    func signUp(login: String, password: String, completion: @escaping (Bool, String?) -> Void)
}

protocol SignUpViewControllerDelegate: AnyObject {
    func signUp(login: String, password: String, completion: @escaping (Bool, String?) -> Void)
}

final class SignUpViewController: UIViewController {
    
    let coordinator: ProfileCoordinatorProtocol
    var delegate: SignUpViewControllerDelegate?
    
    var signUpScrollView: UIScrollView = {
        var signUpScroll = UIScrollView()
        signUpScroll.backgroundColor = CustomColors.customViewColor
        signUpScroll.isScrollEnabled = true
        signUpScroll.showsVerticalScrollIndicator = true
        signUpScroll.translatesAutoresizingMaskIntoConstraints = false
        return signUpScroll
    }()
    
    var signUpContentView: UIView = {
        let signUpView = UIView()
        signUpView.backgroundColor = CustomColors.customViewColor
        signUpView.contentMode = .top
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        return signUpView
    }()
    
    let vkImageView: UIImageView = {
        let vk = UIImageView()
        let vkImage = UIImage(named: "logo")
        vk.image = vkImage
        vk.contentMode = .scaleAspectFit
        vk.translatesAutoresizingMaskIntoConstraints = false
        return vk
    }()
    
    let signUpField: UIView = {
        let field = UIView()
        field.backgroundColor = CustomColors.customGray
        field.layer.borderWidth = 0.5
        field.layer.borderColor = CustomColors.customButtonBlue.cgColor
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
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
    
    let nickTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = CustomColors.customGray
        text.textColor = CustomColors.customTextColor
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        text.leftViewMode = .always
        text.leftView = spacerView
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "AccentColor")
        text.autocapitalizationType = .none
        text.placeholder = "username".localizable
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let passwordTextField: UITextField = {
        let passwordText = UITextField()
        passwordText.backgroundColor = CustomColors.customGray
        passwordText.textColor = CustomColors.customTextColor
        passwordText.clipsToBounds = true
        passwordText.layer.cornerRadius = 10
        passwordText.layer.borderWidth = 0.5
        passwordText.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        passwordText.leftViewMode = .always
        passwordText.leftView = spacerView
        passwordText.layer.borderColor = CustomColors.customButtonBlue.cgColor
        passwordText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordText.tintColor = UIColor(named: "AccentColor")
        passwordText.autocapitalizationType = .none
        passwordText.placeholder = "password".localizable
        passwordText.isSecureTextEntry = true
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        return passwordText
    }()
    
    private lazy var signUpButton = CustomButton(
        title: (name: "sign_up".localizable, state: nil),
        titleColor: (color: nil, state: nil),
        titleLabelColor: CustomColors.customLabelTextColor,
        titleFont: nil,
        cornerRadius: 10,
        backgroundColor: UIColor(named: "Color"), // light and dark theme with Assets
        backgroundImage: (image: UIImage(named: "blue_pixel"), state: nil),
        clipsToBounds: true,
        action: { [weak self] in
            self!.disableSignUpButton()
            self!.addActivityIndicator()
            self!.activityIndicatior.startAnimating()
            
            self!.delegate?.signUp(login: self!.nameTextField.text!, password: self!.passwordTextField.text!) { result, error in
                
                if result {
                    FavoritesCoreData.shared.emptyUserList()
                    FavoritesCoreData.shared.deleteAll(type: .favorites)
                    FavoritesCoreData.shared.deleteAll(type: .profile)
                    
                    NetworkService.requestForAvatar { profile in
                        let avatarURL = URL(string: profile.results[0].picture.large)
                        DispatchQueue.main.async { [self] in
                            
                            let user = DUser(mail: self!.nameTextField.text!, name: self!.nickTextField.text!, avatar: avatarURL, status: nil)
                            
                            
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = user.name
                            changeRequest?.photoURL = user.avatar
                            changeRequest?.commitChanges { error in
                                print(error as Any)
                            }
                            
                            FavoritesCoreData.shared.saveCurrentUser(user: user)
                            FavoritesCoreData.shared.changeStatusToTrue()
                            self!.activityIndicatior.stopAnimating()
                            self!.callAlertViewSignUpSuccess()
                        }
                    }
                    
                } else {
                    self!.callAlertViewSignUpFailure(error: error ?? "user_existed_something_wrong".localizable)
                    self!.activityIndicatior.stopAnimating()
                    self!.enableSignUpButton()

                }
            }
            
        })
    
    private lazy var goToLogInButton = CustomButton(title: ("logIn".localizable, nil), titleColor: (CustomColors.customButtonBlue, nil), titleLabelColor: nil, titleFont: nil, cornerRadius: nil, backgroundColor: nil, backgroundImage: (nil, nil), clipsToBounds: nil, image: nil, action: { [weak self] in
        self!.coordinator.loginViewController(coordinator: self!.coordinator)
    })
    
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
    
    //MARK: - overridden functions
    
    override func viewDidLoad() {
        view.backgroundColor = CustomColors.customViewColor
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
    
    private func addActivityIndicator() {
        signUpContentView.addSubview(activityIndicatior)
        NSLayoutConstraint.activate(
            [
                activityIndicatior.leadingAnchor.constraint(equalTo: self.signUpContentView.leadingAnchor, constant: 16),
                activityIndicatior.trailingAnchor.constraint(equalTo: self.signUpContentView.trailingAnchor, constant: -16),
                activityIndicatior.topAnchor.constraint(equalTo: self.vkImageView.bottomAnchor, constant: 120),
                activityIndicatior.heightAnchor.constraint(equalToConstant: 100),
                ])
        
    }
    
    private func addAllViews() {
        view.addSubview(signUpScrollView)
        signUpScrollView.addSubview(signUpContentView)
        signUpContentView.addSubview(vkImageView)
        signUpContentView.addSubview(signUpField)
        signUpContentView.addSubview(signUpButton)
        signUpContentView.addSubview(goToLogInButton)
        signUpField.addSubview(nameTextField)
        signUpField.addSubview(nickTextField)
        signUpField.addSubview(passwordTextField)
        
    }
    
    private func setAllConstraints() {

        NSLayoutConstraint.activate(
            [
                signUpScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
                signUpScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                signUpScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                signUpScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

                signUpContentView.topAnchor.constraint(equalTo: self.signUpScrollView.topAnchor),
                signUpContentView.bottomAnchor.constraint(equalTo: self.signUpScrollView.bottomAnchor),
                signUpContentView.leadingAnchor.constraint(equalTo: self.signUpScrollView.leadingAnchor),
                signUpContentView.trailingAnchor.constraint(equalTo: self.signUpScrollView.trailingAnchor),
                signUpContentView.widthAnchor.constraint(equalTo: self.signUpScrollView.widthAnchor),

                vkImageView.centerXAnchor.constraint(equalTo: self.signUpContentView.centerXAnchor),
                vkImageView.topAnchor.constraint(equalTo: self.signUpContentView.topAnchor, constant: 120),
                vkImageView.widthAnchor.constraint(equalToConstant: 100),
                vkImageView.heightAnchor.constraint(equalToConstant: 100),
                
                signUpField.leadingAnchor.constraint(equalTo: self.signUpContentView.leadingAnchor, constant: 16),
                signUpField.trailingAnchor.constraint(equalTo: self.signUpContentView.trailingAnchor, constant: -16),
                signUpField.topAnchor.constraint(equalTo: self.vkImageView.bottomAnchor, constant: 120),
                signUpField.heightAnchor.constraint(equalToConstant: 150),
                
                nameTextField.leadingAnchor.constraint(equalTo: self.signUpField.leadingAnchor),
                nameTextField.trailingAnchor.constraint(equalTo: self.signUpField.trailingAnchor),
                nameTextField.topAnchor.constraint(equalTo: self.signUpField.topAnchor),
                nameTextField.heightAnchor.constraint(equalToConstant: 50),
                
                nickTextField.leadingAnchor.constraint(equalTo: self.signUpField.leadingAnchor),
                nickTextField.trailingAnchor.constraint(equalTo: self.signUpField.trailingAnchor),
                nickTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor),
                nickTextField.heightAnchor.constraint(equalToConstant: 50),
                
                passwordTextField.leadingAnchor.constraint(equalTo: self.signUpField.leadingAnchor),
                passwordTextField.trailingAnchor.constraint(equalTo: self.signUpField.trailingAnchor),
                passwordTextField.bottomAnchor.constraint(equalTo: self.signUpField.bottomAnchor),
                passwordTextField.heightAnchor.constraint(equalToConstant: 50),
                
                signUpButton.leadingAnchor.constraint(equalTo: self.signUpContentView.leadingAnchor, constant: 16),
                signUpButton.trailingAnchor.constraint(equalTo: self.signUpContentView.trailingAnchor, constant: -16),
                signUpButton.topAnchor.constraint(equalTo: self.signUpField.bottomAnchor, constant: 16),
                signUpButton.heightAnchor.constraint(equalToConstant: 50),
                
                goToLogInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
                goToLogInButton.trailingAnchor.constraint(equalTo: signUpContentView.trailingAnchor, constant: -16),
                goToLogInButton.heightAnchor.constraint(equalToConstant: 50),
                goToLogInButton.bottomAnchor.constraint(equalTo: signUpContentView.bottomAnchor, constant: -16),
                
            ]
        )
        
    }
    
    private func disableSignUpButton() {
        signUpButton.isEnabled = false
        nameTextField.isEnabled = false
        nickTextField.isEnabled = false
        passwordTextField.isEnabled = false
    }
    
    private func enableSignUpButton() {
        signUpButton.isEnabled = true
        nameTextField.isEnabled = true
        nickTextField.isEnabled = true
        passwordTextField.isEnabled = true
    }
    
    func goToProfilePage() {
        coordinator.profileViewController(coordinator: coordinator, navControllerFromFactory: nil)
    }
    
    func callAlertViewSignUpFailure(error: String) {
        self.createAlertView(viewTitle: "failure_registration".localizable, message: error, actionTitle: "ok", action: nil)
    }
    
    func callAlertViewSignUpSuccess() {
        
        let alert = CustomAlert.shared.createAlertWithTwoCompletion(title: "successful_registrarion".localizable, message: "useFaceID".localizable, placeholder: nil, titleAction1: "yes".localizable, action1: {
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
            self.signUpScrollView.contentInset.bottom = keyboardFrame.height
            self.signUpScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0,bottom: keyboardFrame.height, right: 0)
        }
    }
    
    @objc private func handleKeyboardHide(notification: NSNotification) {
        self.signUpScrollView.contentInset.bottom = .zero
        self.signUpScrollView.verticalScrollIndicatorInsets = .zero
    }
    
}


        
    
        
    
    
    

