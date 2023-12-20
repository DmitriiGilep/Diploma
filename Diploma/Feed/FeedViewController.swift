//
//  FeedViewController.swift
//  Navigation
//
//  Created by DmitriiG on 14.02.2022.
//


import UIKit
import CoreData

protocol FeedControllerDelegate: AnyObject {
    func feedHeaderCollectionTableViewCellReload()
}

final class FeedViewController: UIViewController {
    
    //MARK: - let and var
    
    var coordinator: FeedCoordinator? = nil
    weak var delegate: FeedControllerDelegate?
    var fetchResultsController: NSFetchedResultsController<PostFeed>!
    
    let feedTableView: UITableView = {
        let feedTable = UITableView()
        feedTable.dragInteractionEnabled = true
        feedTable.isScrollEnabled = true
        feedTable.translatesAutoresizingMaskIntoConstraints = false
        return feedTable
    }()
    
    
    //MARK: - init
    //    init() {
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    //MARK: - func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "post".localizable, style: .done, target: self, action: #selector(post))
        self.view.addSubview(feedTableView)
        setTable()
        initFetchResultsController()
        feedTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initFetchResultsController()
    }
    
    private func initFetchResultsController() {
        let request = PostFeed.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: false)]
        
        let fetchResultsControllerToDeliver = NSFetchedResultsController(fetchRequest: request, managedObjectContext: FavoritesCoreData.shared.contextBackground, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchResultsControllerToDeliver.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        fetchResultsController = fetchResultsControllerToDeliver
        fetchResultsController.delegate = self
    }
    
    private func setTable() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.dragDelegate = self
        feedTableView.dropDelegate = self
        feedTableView.refreshControl = UIRefreshControl()
        feedTableView.refreshControl?.addTarget(self, action: #selector(loadNewPosts), for: .valueChanged)
        
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
    
    @objc private func post() {
        if FavoritesCoreData.shared.user.isEmpty || !FavoritesCoreData.shared.status[0].status {
            let alert = CustomAlert.shared.createAlertNoCompletion(title: "authFailed".localizable, message: nil, titleAction: "ok")
            present(alert, animated: true)
        } else {
            coordinator?.postViewController(controller: self)
            
        }
        
    }
    
    @objc func loadNewPosts() {
        
        _ = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
            self.feedTableView.refreshControl?.endRefreshing()
            timer.invalidate()
        }
        
        var tuple: (author: String?, avatarImage: String?, descriptionOfPost: String?, image: String?, likes: Int16?, views: Int16?) {
            didSet {
                if tuple.author != nil, tuple.avatarImage != nil, tuple.descriptionOfPost != nil, tuple.image != nil {
                    let postToAdd = Post(author: tuple.author!, avatarImage: tuple.avatarImage!, descriptionOfPost: tuple.descriptionOfPost!, image: tuple.image!, likes: tuple.likes ?? 0, views: tuple.views ?? 0)
                    FavoritesCoreData.shared.addPostFeed(post: postToAdd)
                    feedTableView.refreshControl?.endRefreshing()
                }
            }
        }
        
        NetworkService.request { message in
            DispatchQueue.main.async {
                tuple.image = message.message
            }
        } completionForData: { profile in
            DispatchQueue.main.async {
                tuple.author = profile.results[0].name.title + " " + profile.results[0].name.first + " " + profile.results[0].name.last
                tuple.avatarImage = profile.results[0].picture.large
            }
        } completionForDesctription: { description in
            DispatchQueue.main.async {
                tuple.descriptionOfPost = description.setup + " " + description.punchline
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (fetchResultsController.sections?.count) ?? 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FeedHeaderCollectionView()
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Int
        numberOfRows = fetchResultsController.sections?[section].numberOfObjects ?? 0
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PostTableViewCell.self),
            for: indexPath) as? PostTableViewCell
        else {
            return UITableViewCell()
        }
        
        let data = fetchResultsController.object(at: indexPath)
        
        let dataPost = Post(author: data.author!, avatarImage: data.avatarImage, descriptionOfPost: data.descriptionOfPost!, image: data.image, likes: data.likes, views: data.views)
        
        DispatchQueue.global().async {
            NetworkService.loadImage(linkAvatar: dataPost.avatarImage, linkImage: dataPost.image) { avatar, image in
                if let avatar = avatar, let image = image {
                    DispatchQueue.main.async {
                        cell.post = dataPost
                        cell.avatarImage.image = avatar
                        cell.postImage.image = image
                    }
                }
            }
        }
        
        cell.tapAddToFavorites = { [weak self] cell in
            
            guard let post = cell.post else { return }
            
            var searchFlag = false
            for postSaved in FavoritesCoreData.shared.posts {
                if postSaved.author == post.author, postSaved.descriptionOfPost == post.descriptionOfPost, postSaved.image == post.image {
                    searchFlag = true
                }
            }
            
            if !FavoritesCoreData.shared.status.isEmpty && FavoritesCoreData.shared.status[0].status {
                if searchFlag {
                    let alert = CustomAlert.shared.createAlertNoCompletion(title: "post_not_added".localizable, message: "post_already_contained".localizable, titleAction: "Ок")
                    self!.present(alert, animated: true)
                } else {
                    FavoritesCoreData.shared.addPost(post: post)
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { actionDelete, swipeButtonView, completion in
            let post = self.fetchResultsController.object(at: indexPath)
            FavoritesCoreData.shared.deletePost(post: post)
            completion(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [actionDelete])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}

extension FeedViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                self.feedTableView.insertRows(at: [newIndexPath], with: .automatic)
            case .delete:
                guard let indexPath = indexPath else { return }
                self.feedTableView.deleteRows(at: [indexPath], with: .automatic)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
                self.feedTableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { return }
                self.feedTableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                print("Fatal error")
            }
        }
    }
}

extension FeedViewController: FeedHeaderCollectionViewDelegate {
    func FeedHeaderCollectionViewImageTapped(tappedImage: UIImage) {
        print("well done 🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶 \(String(describing: tappedImage))")
    }
}

extension FeedViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard indexPath.row != 0 else { return []}
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else {return []}
        let imageToManipulate = cell.avatarImage.image
        let textToManipulate = cell.descriprionLabel.text
        
        let dragItemProviderImage = NSItemProvider(object: imageToManipulate ?? UIImage(named: "No_image_available")!)
        let dragItemImage = UIDragItem(itemProvider: dragItemProviderImage)
        dragItemImage.localObject = imageToManipulate // ?? why, I don't know
        
        let dragItemProviderName = NSItemProvider(object: (textToManipulate ?? "No descriprion")! as NSItemProviderWriting)
        let dragItemName = UIDragItem(itemProvider: dragItemProviderName)
        dragItemName.localObject = textToManipulate
        
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
        }
        
        group.notify(queue: .main) {
            if coordinator.proposal.operation == .move {
                
            }
            let newPost = Post(author: "Drag&Drop", avatarImage: nil, descriptionOfPost: postDescription, image: nil, likes: 0, views: 0)
            FavoritesCoreData.shared.addPostFeed(post: newPost)
            tableView.reloadData()
        }
    }
    
}
