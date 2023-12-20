//
//  FeedHeaderCollectionView.swift
//  Diploma
//
//  Created by DmitriiG on 01.09.2023.
//

import UIKit
import CoreData

protocol FeedHeaderCollectionViewDelegate: AnyObject {
    func FeedHeaderCollectionViewImageTapped(tappedImage: UIImage)
}

final class FeedHeaderCollectionView: UIView {
    
    weak var delegate: FeedHeaderCollectionViewDelegate?
    var fetchResultsController: NSFetchedResultsController<PostFeed>!
    
    private var feedCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        //       layout.minimumLineSpacing = 8
        //       layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        //        layout.sectionInset = UIEdgeInsets(
        //            top: 8,
        //            left: 8,
        //            bottom: 8,
        //            right: 8)
        return layout
    }()
    
    lazy var feedCollectionView: UICollectionView = {
        let feedView = UICollectionView(frame: .zero, collectionViewLayout: feedCollectionViewFlowLayout)
        feedView.dataSource = self
        feedView.delegate = self
        feedView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        feedView.translatesAutoresizingMaskIntoConstraints = false
        return feedView
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setUP()
        initFetchResultsController()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        feedCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setUP() {
        self.addSubview(feedCollectionView)
        
        NSLayoutConstraint.activate([
            
            feedCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            feedCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
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
    
}

extension FeedHeaderCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 25
        cell.contentView.layer.cornerRadius = 25
        cell.contentView.clipsToBounds = true
        cell.clipsToBounds = true
        let data = fetchResultsController.object(at: indexPath)
        let avatarImageURL = data.avatarImage
        
        DispatchQueue.global().async {
            if let urlLinkForAvatar = avatarImageURL, let dataForAvatar = try? Data(contentsOf: URL(string: urlLinkForAvatar)!) {
                if let avatarFromURL = UIImage(data: dataForAvatar) {
                    DispatchQueue.main.async {
                        cell.imageForCell = avatarFromURL
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.imageForCell = UIImage(named: "No_image_available")!
                }
            }
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50 , height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let tappedCell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell else {return}
        guard let tappedImage = tappedCell.photoImageView.image else {return}
//        let data = fetchResultsController.object(at: indexPath)
//
//        let tappedImage: UIImage
//
//        if let dataForAvatarImage = data.avatarImage {
//            tappedImage = UIImage(data: dataForAvatarImage)!
//        } else {
//            tappedImage = UIImage(named: "No_image_available")!
//        }
        delegate?.FeedHeaderCollectionViewImageTapped(tappedImage: tappedImage)
        
    }
}

extension FeedHeaderCollectionView: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        DispatchQueue.main.async {
            switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                self.feedCollectionView.insertItems(at: [newIndexPath])
            case .delete:
                guard let indexPath = indexPath else { return }
                self.feedCollectionView.deleteItems(at: [indexPath])
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
                self.feedCollectionView.moveItem(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { return }
                self.feedCollectionView.reloadItems(at: [indexPath])
            @unknown default:
                print("Fatal error")
            }
        }
    }
}
