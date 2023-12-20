////
////  FeedHeaderCollectionTableViewCell.swift
////  Diploma
////
////  Created by DmitriiG on 11.08.2023.
////
//
//import UIKit
//
//protocol FeedHeaderCollectionTableViewCellDelegate: AnyObject {
//    func FeedHeaderCollectionTableViewCellImageTapped(tappedImage: UIImage)
//}
//
//final class FeedHeaderCollectionTableViewCell: UITableViewCell {
//    
//    
//    weak var delegate: FeedHeaderCollectionTableViewCellDelegate?
//    
////    private var postDataArray = postDataFeed.postDataArray
//
//    private var feedCollectionViewFlowLayout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
// //       layout.minimumLineSpacing = 8
// //       layout.minimumInteritemSpacing = 8
//        layout.scrollDirection = .horizontal
////        layout.sectionInset = UIEdgeInsets(
////            top: 8,
////            left: 8,
////            bottom: 8,
////            right: 8)
//        return layout
//    }()
//    
//    lazy var feedCollectionView: UICollectionView = {
//        let feedView = UICollectionView(frame: .zero, collectionViewLayout: feedCollectionViewFlowLayout)
//        feedView.dataSource = self
//        feedView.delegate = self
//        feedView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
//        feedView.translatesAutoresizingMaskIntoConstraints = false
//        return feedView
//    }()
//    
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUP()
//
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func removeFromSuperview() {
//        super.removeFromSuperview()
//    }
//    
//    override func layoutSubviews() {
//        feedCollectionView.collectionViewLayout.invalidateLayout()
//
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//     
//    private func setUP() {
//        contentView.addSubview(feedCollectionView)
//        
//        NSLayoutConstraint.activate([
//            
//            feedCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            feedCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            feedCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            feedCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//            feedCollectionView.heightAnchor.constraint(equalToConstant: 50),
//            
//        ])
//    }
//    
//}
//
//extension FeedHeaderCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let arrayNumber = postDataFeed.postDataArray.count
//        if arrayNumber==0 {
//            return 1
//        } else {
//            return arrayNumber
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as? PhotosCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        cell.layer.cornerRadius = 25
//        cell.contentView.layer.cornerRadius = 25
//        cell.contentView.clipsToBounds = true
//        cell.clipsToBounds = true
//        
//        cell.imageForCell = postDataFeed.postDataArray[indexPath.row].avatarImage
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 50 , height: 50)
//
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let tappedImage = postDataFeed.postDataArray[indexPath.row].avatarImage
//        delegate?.FeedHeaderCollectionTableViewCellImageTapped(tappedImage: tappedImage!)
//        
//    }
//    
//}
//
//extension FeedHeaderCollectionTableViewCell: FeedControllerDelegate {
//    
//    func feedHeaderCollectionTableViewCellReload() {
//        feedCollectionView.reloadData()
//        print("😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️feedCollectionView.reloadData() has worked")
//        print(postDataFeed.postDataArray.count)
//    }
//    
//}
