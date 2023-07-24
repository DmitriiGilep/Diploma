//
//  PostViewController.swift
//  Navigation
//
//  Created by DmitriiG on 15.02.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    let coordinator: FeedCoordinatorProtocol
    let postViewModel: PostViewModel
    
    init(coordinator: FeedCoordinatorProtocol, model: PostViewModel) {
        self.coordinator = coordinator
        self.postViewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //сделал связь с feedViewController и поставил имя PostViewController как имя структуры Post в feedViewController
        let feedViewController = ViewControllerFactory()
        self.title = feedViewController.createFeedViewController().titleForPost
        view.backgroundColor = .brown
        
        //создал кнопку в bar и поставил ее в свойство, далее назначил ей переход на infoViewController
        let tabBar = UIBarButtonItem(title: "info".localizable, style: .plain, target: self, action: #selector(buttonGoToInfoViewControllerTapped))
        navigationItem.rightBarButtonItem = tabBar
        
        bindViewModel()
    }
    
    @objc func buttonGoToInfoViewControllerTapped() {
        postViewModel.changeState(interfaceEvent: .buttonGoToInfoViewControllerPressed, controller: self)
    }
    
    private func bindViewModel() {
        postViewModel.processInterfaceEvents = {
            [weak self] state in
            switch state {
            case .goToInfoViewController:
                // передал self, чтобы вызвать present именно у этого экземпляра PostViewController
   //             self?.coordinator.infoViewController(postViewController: self!)
                self?.coordinator.infoViewController(completion: { infoViewController in
                    self?.present(infoViewController, animated: true)
                })
                
            }
        }
    }
}


