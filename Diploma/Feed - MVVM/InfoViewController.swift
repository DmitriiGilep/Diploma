//
//  InfoViewController.swift
//  Navigation
//
//  Created by DmitriiG on 19.02.2022.
//

import UIKit

final class InfoViewController: UIViewController {
    
    private let coordinator: FeedCoordinatorProtocol
    private let infoViewModel: InfoViewModel
    
    let cellForNames = "cellForNames"
    
    let infoTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //создал кнопку, назначил ей вывод AlertView
    // переинициализировал кнопку при помощи CustomButton
    private lazy var button = CustomButton(
        title: (name: "alert_title".localizable, state: .normal),
        titleColor: (color: nil, state: nil),
        backgroundColor: .magenta,
        backgroundImage: (image: nil, state: nil),
        action:  {
            self.infoViewModel.changeState(interFaceEvent: .buttonPresentAlertViewTapped, controller: self)
        })
    
    init(coordinator: FeedCoordinatorProtocol, model: InfoViewModel) {
        self.coordinator = coordinator
        self.infoViewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // поменял фон и имя
        title = "info".localizable
        view.backgroundColor = .cyan
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellForNames)

        setUP()
        bindViewModel()
        infoViewModel.changeState(interFaceEvent: .urlRequest, controller: self)
        infoViewModel.changeState(interFaceEvent: .urlRequest2, controller: self)
        infoViewModel.changeState(interFaceEvent: .urlRequest3, controller: self)


    }
    
    private func setUP() {
        view.addSubview(button)
        view.addSubview(titleLabel)
        view.addSubview(titleLabel2)
        view.addSubview(infoTableView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 130),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            titleLabel2.widthAnchor.constraint(equalToConstant: 200),
            titleLabel2.heightAnchor.constraint(equalToConstant: 50),
            
            infoTableView.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor, constant: 10),
            infoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            infoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    
    private func bindViewModel() {
        infoViewModel.processInterfaceEvents = {
            [weak self] state in
            switch state {
            case .goToAlertView:
                self?.coordinator.alertView(infoViewController: self!)
            case .processUrlRequest:
                self?.titleLabel.text = self?.infoViewModel.title
            case .processUrlRequest2:
                self?.titleLabel2.text = self?.infoViewModel.orbitalPeriod
            case .processUrlRequest3:
                self?.infoTableView.reloadData()
            }
        }
    }
    
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrayCount = infoViewModel.residentsName.count
        if arrayCount == 0 {
            return 1
        } else {
            return arrayCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellForNames, for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        if infoViewModel.residentsName.isEmpty {
            cellContent.text = "data_loading_process".localizable
        }
            else {
                cellContent.text = infoViewModel.residentsName[indexPath.row]
        }
        cell.contentConfiguration = cellContent
        return cell
    }
    
}

