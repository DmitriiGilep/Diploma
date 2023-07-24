//
//  ProfileViewController-2.swift
//  Navigation
//
//  Created by DmitriiG on 02.03.2022.
//

import UIKit

import StorageService

final class ProfileViewController: UIViewController {
    
    //MARK: - let and var
    let favoritesCell =  FavoritesCell()
    let coordinator: ProfileCoordinatorProtocol
    let controller: LogInViewController
    var userService: UserService
    var userName: String
    private var postDataArray = postData.postDataArray
    private var postPhotoName = ["1", "2", "3", "4"]
    
    lazy var profileHeaderView: ProfileHeaderView = {
        let profileHeader = ProfileHeaderView(controller: controller, currentController: self)
        profileHeader.translatesAutoresizingMaskIntoConstraints = false
        return profileHeader
    }()
    
    let avatarImageView: UIImageView = {
        let avatar = UIImageView()
        let avatarImage = UIImage(named: "Avatar.jpeg")
        avatar.image = avatarImage
        avatar.layer.borderColor = CustomColors.customGray.cgColor
        avatar.layer.borderWidth = 3
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.isUserInteractionEnabled = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    lazy var tapOnAvatar: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 1
        recognizer.addTarget(self, action: #selector(avatarChanging))
        return recognizer
    }()
    
    let transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var xButton = CustomButton(
        title: (name: "x", state: .normal),
        titleColor: (color: .black, state: .normal),
        titleFont: UIFont.boldSystemFont(ofSize: 20),
        backgroundImage: (image: nil, state: nil),
        action: {
            [weak self] in
            self?.xButtonAnimate()
        })
    
    // добавил условия для запуска дла дебаг схемы и для рилиз схемы
    
    let profileTableView: UITableView = {
        let profileTable = UITableView()
        
#if DEBUG
        profileTable.backgroundColor = .red
#else
        profileTable.backgroundColor = .green
#endif
        profileTable.dragInteractionEnabled = true
        profileTable.translatesAutoresizingMaskIntoConstraints = false
        return profileTable
    }()
    
    private var avatarImageViewTop: NSLayoutConstraint?
    private var avatarImageViewLeading: NSLayoutConstraint?
    private var avatarImageViewWidth: NSLayoutConstraint?
    private var avatarImageViewHeight: NSLayoutConstraint?
    private var avatarImageViewCenterX: NSLayoutConstraint?
    private var avatarImageViewCenterY: NSLayoutConstraint?
    private var transparentViewTop: NSLayoutConstraint?
    private var transparentViewBottom: NSLayoutConstraint?
    private var transparentViewLeading: NSLayoutConstraint?
    private var transparentViewTrailing: NSLayoutConstraint?
    private var xButtonTop: NSLayoutConstraint?
    private var xButtonTrailing: NSLayoutConstraint?
    private var xButtonWidth: NSLayoutConstraint?
    private var xButtonHeight: NSLayoutConstraint?
    
    let avatarAnimation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: nil)
    let xButtonAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: nil)
    
    //MARK: - init
    init(userService: UserService, userName: String, coordinator: ProfileCoordinatorProtocol, controller: LogInViewController) {
        self.userService = userService
        self.userName = userName
        self.coordinator = coordinator
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - func
    @objc private func avatarChanging () {
        
        //MARK: - Анимация при помощи KeyFrames
        //        UIView.animateKeyframes(withDuration: 5, delay: 0, options: []) {
        //
        //            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 3.0) {
        //                self.setAvatarImageViewAndTransparentViewToView()
        //                self.avatarImageView.layer.cornerRadius = 0
        //                self.view.layoutIfNeeded()
        //            }
        //
        //            UIView.addKeyframe(withRelativeStartTime: 3.0, relativeDuration: 2.0) {
        //                self.setXButtonToView()
        //                self.view.layoutIfNeeded()
        //            }
        //        } completion: {_ in
        //        }
        
        //MARK: - Анимация при помощи UIView.animate
        // UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
        //            self.setAvatarImageViewAndTransparentViewToView()
        //            self.avatarImageView.layer.cornerRadius = 0
        //            self.view.layoutIfNeeded()
        //
        //        } completion: { _ in
        //
        //        }
        //
        //        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveLinear) {
        //            self.setXButtonToView()
        //            self.view.layoutIfNeeded()
        //        } completion: { _ in
        //
        //        }
        
        //MARK: Анимация при помощи UIViewPropertyAnimator
        
        avatarAnimation.addAnimations {
            self.setAvatarImageViewAndTransparentViewToView()
            self.avatarImageView.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        }
        
        xButtonAnimation.addAnimations {
            self.setXButtonToView()
            self.view.layoutIfNeeded()
        }
        
        avatarAnimation.startAnimation()
        xButtonAnimation.startAnimation(afterDelay: 0.5)
        
    }
    
    private func setAvatarImageViewToProfileView() {
        
        profileHeaderView.addSubview(avatarImageView)
        avatarImageView.addGestureRecognizer(tapOnAvatar)
        avatarImageViewTop = avatarImageView.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 16)
        avatarImageViewLeading = avatarImageView.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: 16)
        avatarImageViewWidth = avatarImageView.widthAnchor.constraint(equalToConstant: 110)
        avatarImageViewHeight = avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        
        // принимаю результат функции userInfo за UserService и присваиваю аватар, имя и статус пользователя avatarImageView и profileHeaderView
        let loginedUser = userService.userInfo(name: userName)
        avatarImageView.image = loginedUser?.avatar
        profileHeaderView.fullNameLabel.text = loginedUser?.name
        profileHeaderView.statusLabel.text = loginedUser?.status
        
        
        NSLayoutConstraint.activate([
            avatarImageViewTop,avatarImageViewLeading, avatarImageViewWidth, avatarImageViewHeight
            //развернуть опцинальные значения
        ].compactMap{ $0 })
        
    }
    
    private func setRadius() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
    }
    
    private func setAvatarImageViewAndTransparentViewToView() {
        
        avatarImageViewCenterX = avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        avatarImageViewCenterY = avatarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        avatarImageViewWidth = avatarImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        avatarImageViewHeight = avatarImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        
        transparentViewTop = transparentView.topAnchor.constraint(equalTo: view.topAnchor)
        transparentViewBottom = transparentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        transparentViewLeading = transparentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        transparentViewTrailing = transparentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        self.view.addSubview(self.transparentView)
        self.view.addSubview(self.avatarImageView)
        NSLayoutConstraint.activate([
            self.avatarImageViewCenterX,self.avatarImageViewCenterY, self.avatarImageViewWidth,
            self.transparentViewTop,self.transparentViewBottom, self.transparentViewLeading, self.transparentViewTrailing
        ].compactMap{ $0 })
        
    }
    
    private func setXButtonToView() {
        
        xButtonTop = xButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        xButtonTrailing = xButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        xButtonWidth = xButton.widthAnchor.constraint(equalToConstant: 50)
        xButtonHeight = xButton.heightAnchor.constraint(equalToConstant: 50)
        
        // добавил новое кастомное свойство у xButton
        xButton.setTitle("X", for: .highlighted)
        
        self.view.addSubview(self.xButton)
        NSLayoutConstraint.activate([
            self.xButtonTop, self.xButtonTrailing, self.xButtonWidth, self.xButtonHeight
        ].compactMap{ $0 })
        
    }
    
    private func setTable() {
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        profileTableView.dragDelegate = self
        profileTableView.dropDelegate = self
        self.profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: ProfileHeaderView.self))
        self.profileTableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
        self.profileTableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: FavoritesCell.self))
   //     profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.estimatedRowHeight = 310
        
        NSLayoutConstraint.activate([
            profileTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            profileTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    func xButtonAnimate() {
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.removeFromSuperview()
            self.transparentView.removeFromSuperview()
            self.xButton.removeFromSuperview()
            self.setAvatarImageViewToProfileView()
            self.view.layoutIfNeeded()
            self.setRadius()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(profileTableView)
        setTable()
        setAvatarImageViewToProfileView()
//         this method maybe create bounds which are consequently used in viewWillAppear by setRadius
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRadius()
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // rows quantity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumber = section
        if sectionNumber == 0 || sectionNumber == 1 || sectionNumber == 3 {
            return 1
        } else if sectionNumber == 2 {
            return (postDataArray.count)
        }
        return sectionNumber
    }
    
    // cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderView.self), for: indexPath)
            
            //надо добавлять не на cell, а на cell.contentView, иначе contentView при первом показе перекрывает view и она неактивна
            cell.contentView.addSubview(profileHeaderView)
            NSLayoutConstraint.activate([
                profileHeaderView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                profileHeaderView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                profileHeaderView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                profileHeaderView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
          //      profileHeaderView.heightAnchor.constraint(equalToConstant: 220)
            ])
           
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PhotosTableViewCell.self),
                for: indexPath) as? PhotosTableViewCell
            else {
                return UITableViewCell()
            }
            if cell.imagesStack.arrangedSubviews.isEmpty == true {
                cell.setImages(imagesNames: postPhotoName)
            }
            return cell
            
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoritesCell.self), for: indexPath)
            
            cell.contentView.addSubview(favoritesCell)
            NSLayoutConstraint.activate([
                favoritesCell.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                favoritesCell.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                favoritesCell.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                favoritesCell.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            ])
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PostTableViewCell.self),
                for: indexPath) as? PostTableViewCell
            else {
                return UITableViewCell()
            }
            
            let data = postDataArray[indexPath.row]
            cell.post = data
            
            cell.tapAddToFavorites = { [weak self] cell in
                
                guard let post = cell.post else { return }
                
                var searchFlag = false
                for postSaved in FavoritesCoreData.shared.posts {
                    if postSaved.author == post.author, postSaved.descriptionOfPost == post.descriptionOfPost, postSaved.image == post.image?.jpegData(compressionQuality: 1.0) {
                        searchFlag = true
                    }
                }
                
                if searchFlag {
                    let alert = CustomAlert.shared.createAlertNoCompletion(title: "post_not_added".localizable, message: "post_already_contained".localizable, titleAction: "Ок")
                    self!.present(alert, animated: true)
                } else {
                    FavoritesCoreData.shared.addPost(post: post)
                }

            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            coordinator.photosViewController(profileViewController: self)
        } else if indexPath.section == 3 {
  
            coordinator.favoritesTableViewController()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.section == 0 {
            height = 220
        } else {
            height = UITableView.automaticDimension
        }
        return height
    }
    
}

extension ProfileViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
//        guard indexPath.section == 2 else {
//            return[]
//        }
        
        guard indexPath.row != 0 else { return []} // why
        
        let post = postDataArray[indexPath.row]
        
        let dragItemProviderImage = NSItemProvider(object: post.image ?? UIImage(named: "No_image_available")!)
        let dragItemImage = UIDragItem(itemProvider: dragItemProviderImage)
        dragItemImage.localObject = post.image // ?? why, I don't know

        let dragItemProviderName = NSItemProvider(object: (post.descriptionOfPost ?? "No descriprion")! as NSItemProviderWriting)
        let dragItemName = UIDragItem(itemProvider: dragItemProviderName)
        dragItemName.localObject = post.descriptionOfPost // ?? why
        
        return [dragItemImage, dragItemName]
            
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        var dropProposal = UITableViewDropProposal(operation: .cancel)
        guard session.items.count == 2 else { return dropProposal } // here a quantity of dragged items totally
        
        guard destinationIndexPath?.section == 2 else { return dropProposal }
        
        if tableView.hasActiveDrag {
 //               if tableView.isEditing {
                    dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  //              }
            } else {
                dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }

            return dropProposal
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
   //         let section = 2
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        let rowInd = destinationIndexPath.row
        
//        let post = Post(author: "Drag&Drop", likes: 0, views: 0)
//        self.postDataArray.insert(post, at: destinationIndexPath.row)

        
        let group = DispatchGroup()
        
        var postDescription = String()
        group.enter()
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            let descriptions = items as! [String]
            for description in descriptions {
                postDescription = description
                break
            }
            group.leave()
//            self.postDataArray[destinationIndexPath.row].descriptionOfPost = descriptions.first
//            tableView.reloadData()
        }
        
        var postImage = UIImage()
        group.enter()
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            let images = items as! [UIImage]
            for image in images {
                postImage = image
                break
            }
            group.leave()
//            self.postDataArray[destinationIndexPath.row].image = images.first
//            tableView.reloadData()
        }
        
        group.notify(queue: .main) {
            if coordinator.proposal.operation == .move {
                self.postDataArray.remove(at: rowInd)
            }
            let newPost = Post(author: "Drag&Drop", descriptionOfPost: postDescription, image: postImage, likes: 0, views: 0)
            self.postDataArray.insert(newPost, at: rowInd)
            tableView.reloadData()
        }
    }
    
    
    
}
