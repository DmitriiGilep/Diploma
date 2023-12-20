//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by DmitriiG on 04.05.2022.
//

import UIKit


final class PostTableViewCell: UITableViewCell {
    
    var tapAddToFavorites: ((PostTableViewCell) -> Void)?
    
    lazy var tapAddToFavoritesGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 2
        recognizer.addTarget(self, action: #selector(addToFavorites))
        return recognizer
    }()
    
    var post: PostProtocol? {
        didSet {
            
            authorLabel.text = post?.author
            descriprionLabel.text = post?.descriptionOfPost
            let formattedLikes = String(format: "likes".localizable, post?.likes ?? 0)
            likesLabel.text = formattedLikes
 //           likesLabel.text = "likes:".localizable + "\(post?.likes ?? 0)"
            let formattedViews = String(format: "views".localizable, post?.views ?? 0)
            viewsLabel.text = formattedViews
 //           viewsLabel.text = "views:".localizable + "\(post?.views ?? 0)"
        }
    }
    
    let authorLabel: UILabel = {
        let author = UILabel()
        author.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        author.translatesAutoresizingMaskIntoConstraints = false
        return author
    }()
    
    let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriprionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.systemFont(ofSize: 14)
        //для автозаполнения
        description.numberOfLines = 0
        description.textColor = .gray
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    let likesLabel: UILabel = {
        let likes = UILabel()
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    let viewsLabel: UILabel = {
        let views = UILabel()
        views.textAlignment = .right
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        self.backgroundColor = .white
        addGestureRecognizer(tapAddToFavoritesGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    @objc
    private func addToFavorites() {
        tapAddToFavorites?(self)
    }
    
    
    private func setViews() {
        
        self.addSubview(authorLabel)
        self.addSubview(avatarImage)
        self.addSubview(postImage)
        self.addSubview(descriprionLabel)
        self.addSubview(likesLabel)
        self.addSubview(viewsLabel)
        
        NSLayoutConstraint.activate(
            [
                avatarImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                avatarImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                avatarImage.widthAnchor.constraint(equalToConstant: 50),
                avatarImage.heightAnchor.constraint(equalToConstant: 50),
                
                authorLabel.leadingAnchor.constraint(equalTo: self.avatarImage.trailingAnchor, constant: 5),
                authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                authorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                authorLabel.heightAnchor.constraint(equalToConstant: 50),
                
                postImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                postImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                postImage.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 5),
                //self.postImage.bottomAnchor.constraint(equalTo: self.descriprionLabel.topAnchor, constant: -5),
                postImage.heightAnchor.constraint(equalToConstant: 200),
                
                descriprionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                descriprionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                descriprionLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 5),
                descriprionLabel.bottomAnchor.constraint(equalTo: self.likesLabel.topAnchor, constant: -5),
                
                likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                likesLabel.topAnchor.constraint(equalTo: self.descriprionLabel.bottomAnchor, constant: 5),
                likesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                likesLabel.widthAnchor.constraint(equalToConstant: 150),
                
                viewsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                viewsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                viewsLabel.widthAnchor.constraint(equalToConstant: 200)
            ]
        )
    }
    
}
