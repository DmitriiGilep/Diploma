//
//  FaboritesTableViewController.swift
//  Industrial
//
//  Created by DmitriiG on 08.01.2023.
//

import UIKit
import CoreData


final class FavoritesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<PostFav>!

    func initFetchResultsController() {
        let request = PostFav.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: false)]
        
        if let searchRequest = textFieldForFilter.text, searchRequest != "" {
            request.predicate = NSPredicate(format: "author contains[cd] %@", searchRequest)
        }
        
        let fetchResultsControllerToDeliver = NSFetchedResultsController(fetchRequest: request, managedObjectContext: FavoritesCoreData.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchResultsControllerToDeliver.performFetch()
        
        fetchResultsController = fetchResultsControllerToDeliver
        
        fetchResultsController.delegate = self

    }
    
    
//    var posts: [PostFav] = {
//
//       return FavoritesCoreData.shared.posts
//
//    }()
    
//    var searchRequest: String? {
//        didSet {
//            posts = {
//                if searchRequest == nil {
//                    return FavoritesCoreData.shared.posts
//                } else {
//                    return FavoritesCoreData.shared.posts.filter({ post in
//                        post.author == searchRequest
//                    })
//                }
//            }()
//        }
//    }
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "no_posts_favorites".localizable
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let contentView: UIView = {
       let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textFieldForFilter: UITextField = {
        let text = UITextField()
        text.placeholder = "search_criteria".localizable
        text.layer.cornerRadius = 5
        text.backgroundColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
    
    lazy var applyButton = CustomButton(title: (name: "apply".localizable, state: .normal), titleColor: (color: .black, state: .normal), backgroundImage: (image: nil, state: nil)) {
//        self.searchRequest = self.textFieldForFilter.text
        self.contentView.removeFromSuperview()
        self.initFetchResultsController()
        self.tableView.reloadData()
    }
    
    lazy var searchButton = CustomButton(title: (name: "search".localizable, state: .normal), titleColor: (color: .systemBlue, state: .normal), backgroundImage: (image: nil, state: nil)) {
        self.setUpContentView()
    }
    
//    lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: #selector(cancelSearch))
//
//    @objc private func cancelSearch() {
//        searchRequest = nil
//        tableView.reloadData()
//    }
    
    lazy var cancelButton = CustomButton(title: (name: "cancel".localizable, state: .normal), titleColor: (color: .red, state: .normal), backgroundImage: (image: nil, state: nil)) {
   //     self.searchRequest = nil
        self.contentView.removeFromSuperview()
        self.textFieldForFilter.text = ""
        self.initFetchResultsController()
        self.tableView.reloadData()
    }
    
    lazy var cancelButtonItem = UIBarButtonItem(customView: cancelButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        tableView.estimatedRowHeight = 310
        searchButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        navigationItem.titleView = searchButton
        navigationItem.rightBarButtonItem = cancelButtonItem
        initFetchResultsController()
    }
    
    private func setUpContentView() {
        tableView.addSubview(contentView)
        applyButton.layer.cornerRadius = 5
        applyButton.backgroundColor = .systemBlue
        contentView.addSubview(applyButton)
        contentView.addSubview(textFieldForFilter)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10),
            contentView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            textFieldForFilter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            textFieldForFilter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            textFieldForFilter.heightAnchor.constraint(equalToConstant: 40),
            textFieldForFilter.widthAnchor.constraint(equalToConstant: 190),
            
            applyButton.topAnchor.constraint(equalTo: textFieldForFilter.bottomAnchor, constant: 1),
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            applyButton.heightAnchor.constraint(equalToConstant: 40),
            applyButton.widthAnchor.constraint(equalToConstant: 190),
            
        ])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int
//        if posts.isEmpty {
        if fetchResultsController.sections?[section].numberOfObjects == 0 {

            emptyLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = .none
            numberOfRows = 0

        } else {
            //numberOfRows = FavoritesCoreData.shared.posts.count
            // numberOfRows = posts.count
            numberOfRows = fetchResultsController.sections?[section].numberOfObjects ?? 0
        }
        return numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PostTableViewCell.self),
            for: indexPath) as? PostTableViewCell
        else {
            return UITableViewCell()
        }
        
        
   //     let data = FavoritesCoreData.shared.posts[indexPath.row]
   //     let data = posts[indexPath.row]
        let data = fetchResultsController.object(at: indexPath)
        
        let image: UIImage
        if let data = data.image {
            image = UIImage(data: data)!
        } else {
            image = UIImage(named: "No_image_available")!
        }
        
                
        let dataPost = Post(author: data.author, descriptionOfPost: data.descriptionOfPost, image: image, likes: data.likes, views: data.views)
        cell.post = dataPost
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            let post = FavoritesCoreData.shared.posts[indexPath.row]
//            FavoritesCoreData.shared.deletePost(post: post)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { actionDelete, swipeButtonView, completion in
//            let post = FavoritesCoreData.shared.posts[indexPath.row]
//            let post = self.posts[indexPath.row]
            let post = self.fetchResultsController.object(at: indexPath)
            FavoritesCoreData.shared.deletePost(post: post)
            completion(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [actionDelete])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            print("Fatal error")
        }
    }
    
}

