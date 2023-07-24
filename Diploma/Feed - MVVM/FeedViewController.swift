//
//  FeedViewController.swift
//  Navigation
//
//  Created by DmitriiG on 14.02.2022.
//

import UIKit

final class FeedViewController: UIViewController {
    
    //MARK: - let and var
    
    var coordinator: FeedCoordinatorProtocol? = nil
    var feedViewModel: FeedViewModel? = nil
 
    var userName: String
    private var postDataArray = postData.postDataArray
    private var postPhotoName = ["1", "2", "3", "4"]
    
    let feedHeaderView = FeedHeaderView()
    
    let feedTableView: UITableView = {
        let feedTable = UITableView()
        feedTable.dragInteractionEnabled = true
        feedTable.translatesAutoresizingMaskIntoConstraints = false
        return feedTable
    }()
    
    
    //MARK: - init
    init(coordinator: FeedCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - func
    
    private func setTable() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.dragDelegate = self
        feedTableView.dropDelegate = self
        
        feedTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: FeedHeaderView.self))
        feedTableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 310
        
        NSLayoutConstraint.activate([
            feedTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            feedTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(feedTableView)
        setTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Int
        if section == 0 {
            numberOfRows = 1
        } else {
            numberOfRows = 3
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedHeaderView.self), for: indexPath)
            
            cell.contentView.addSubview(feedHeaderView)
            NSLayoutConstraint.activate([
                feedHeaderView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                feedHeaderView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                feedHeaderView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                feedHeaderView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
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
    
    
}


extension FeedViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
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
