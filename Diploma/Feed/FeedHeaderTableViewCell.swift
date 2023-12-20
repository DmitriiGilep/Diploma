////
////  FeedHeaderTableViewCell.swift
////  Diploma
////
////  Created by DmitriiG on 08.08.2023.
////
//
//import UIKit
//
//class FeedHeaderTableViewCell: UITableViewCell {
//
//    var scrollViewForStack: UIScrollView = {
//        var scroll = UIScrollView()
//        scroll.showsHorizontalScrollIndicator = true
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        return scroll
//    }()
//
//    var feedContentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomColors.customViewColor
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let imagesStack: UIStackView = {
//        let images = UIStackView()
//        images.axis = .horizontal
//        images.spacing = 1.0
//        images.distribution = .fillEqually
//        images.translatesAutoresizingMaskIntoConstraints = false
//        return images
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUp()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setImages(imagesNames: [String]) {
//
//        imagesNames.forEach({
//            let image = UIImageView()
//            image.image = UIImage(named: $0)
//            image.layer.cornerRadius = image.frame.size.width/2
//            image.heightAnchor.constraint(equalToConstant: 50).isActive = true
//            image.widthAnchor.constraint(equalToConstant: 50).isActive = true
//            image.clipsToBounds = true
//            image.layer.masksToBounds = true
//            image.contentMode = .scaleToFill
//            image.translatesAutoresizingMaskIntoConstraints = false
//            imagesStack.addArrangedSubview(image)
//        })
//    }
//
//    private func setUp() {
//
//        self.contentView.addSubview(scrollViewForStack)
//        scrollViewForStack.addSubview(feedContentView)
//        feedContentView.addSubview(imagesStack)
//
//        NSLayoutConstraint.activate([
//
//            scrollViewForStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            scrollViewForStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            scrollViewForStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            scrollViewForStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//
//            feedContentView.topAnchor.constraint(equalTo: scrollViewForStack.topAnchor),
//            feedContentView.bottomAnchor.constraint(equalTo: scrollViewForStack.bottomAnchor),
//            feedContentView.leadingAnchor.constraint(equalTo: scrollViewForStack.leadingAnchor),
//            feedContentView.trailingAnchor.constraint(equalTo: scrollViewForStack.trailingAnchor),
//            feedContentView.heightAnchor.constraint(equalTo: scrollViewForStack.heightAnchor),
//
//            imagesStack.leadingAnchor.constraint(equalTo: feedContentView.leadingAnchor, constant: 5),
//            imagesStack.trailingAnchor.constraint(equalTo: feedContentView.trailingAnchor, constant: -5),
//            imagesStack.topAnchor.constraint(equalTo: feedContentView.topAnchor, constant: 5),
//            imagesStack.bottomAnchor.constraint(equalTo: feedContentView.bottomAnchor, constant: -5),
//            imagesStack.heightAnchor.constraint(equalToConstant: 50),
//
//
//        ])
//    }
//
//
//
//}
