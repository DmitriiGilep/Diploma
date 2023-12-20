//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by DmitriiG on 02.03.2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

final class ProfileHeaderView: UIView {
    
    var delegate: ProfileViewControllerProtocol?
    
    private let activityIndicatior: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = CustomColors.customLabelColor
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    let fullNameLabel: UILabel = {
        let fullName = UILabel()
        if FavoritesCoreData.shared.user.isEmpty == false {
            fullName.text = FavoritesCoreData.shared.user[0].name ?? "There is not any name in FavoritesCoreData.shared.user[0].name"
        } else {
            fullName.text = "n/a"
        }
        fullName.textColor = UIColor.black
        fullName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullName.textAlignment = .center
        fullName.translatesAutoresizingMaskIntoConstraints = false
        return fullName
    }()
    
    let statusLabel: UILabel = {
        let status = UILabel()
        if FavoritesCoreData.shared.user.isEmpty == false {
            status.text = FavoritesCoreData.shared.user[0].status ?? ""
        } else {
            status.text = ""
        }
        status.textColor = UIColor.gray
        status.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        status.textAlignment = .center
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    let statusTextField: UITextField = {
        let statusText = UITextField()
        statusText.layer.borderWidth = 1
        statusText.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        statusText.layer.cornerRadius = 12
        statusText.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        statusText.placeholder = "set_your_status".localizable
        statusText.translatesAutoresizingMaskIntoConstraints = false
        return statusText
    }()
        
    private lazy var setStatusButton = CustomButton(
        title: (name: "set_status".localizable, state: .normal),
        titleColor: (color: nil, state: nil),
        cornerRadius: 4,
        backgroundColor: .blue,
        backgroundImage: (image: nil, state: nil),
        action: {
            [weak self] in
            self?.statusLabel.text = self?.statusTextField.text
            if FavoritesCoreData.shared.user.isEmpty == false {
                var user = FavoritesCoreData.shared.user[0]
                user.status = self?.statusTextField.text
                FavoritesCoreData.shared.updateUser(user: user)
            }
            
        })
    
    private lazy var logoutButton = CustomButton(title: ("exit".localizable, nil), titleColor: (.white, .normal), titleLabelColor: .white, titleFont: nil, cornerRadius: 4, backgroundColor: .black, backgroundImage: (nil, nil), clipsToBounds: nil, action: { [weak self] in
        
        if FavoritesCoreData.shared.user.isEmpty == false {

            self!.disableSignInButton()
            self!.addActivityIndicator()
            self!.activityIndicatior.startAnimating()
            FavoritesCoreData.shared.changeStatusToFalse()
            FavoritesCoreData.shared.emptyUserList()
            FavoritesCoreData.shared.deleteAll(type: .favorites)
            FavoritesCoreData.shared.deleteAll(type: .profile)
            FavoritesCoreData.shared.emptyIDMethod() {
                DispatchQueue.main.async {
                    self?.delegate?.logout()
                }
            }

        }
    })
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setUP()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func disableSignInButton() {
        logoutButton.isEnabled = false
    }
    
    private func addActivityIndicator() {
        self.addSubview(activityIndicatior)
        NSLayoutConstraint.activate(
            [
                activityIndicatior.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                activityIndicatior.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                activityIndicatior.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                activityIndicatior.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

                ])
        
    }
    
    private func setUP() {
        
        self.addSubview(fullNameLabel)
        self.addSubview(setStatusButton)
        self.addSubview(statusLabel)
        self.addSubview(statusTextField)
        self.addSubview(logoutButton)

                
                NSLayoutConstraint.activate([
        
                    fullNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 27),
                    fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 136),
                    fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                    fullNameLabel.heightAnchor.constraint(equalToConstant: 50),
        
                    setStatusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 172),
                    setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                    setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                    setStatusButton.heightAnchor.constraint(equalToConstant: 40),
        
                  statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 136),
                  statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                    statusLabel.heightAnchor.constraint(equalToConstant: 20),
                    statusLabel.bottomAnchor.constraint(equalTo: self.setStatusButton.topAnchor, constant: -74),
        
                    statusTextField.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 5),
                    statusTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 136),
                    statusTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                    statusTextField.heightAnchor.constraint(equalToConstant: 40),
                    
                    logoutButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
                    logoutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                    logoutButton.heightAnchor.constraint(equalToConstant: 20),
                    logoutButton.widthAnchor.constraint(equalToConstant: 100),
                    
                ])
    }
}

