//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by DmitriiG on 19.05.2022.
//

import UIKit

final class PhotosTableViewCell: UITableViewCell {
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "photos".localizable
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrow: UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage(named: "Arrow")
        arrow.translatesAutoresizingMaskIntoConstraints = false
        return arrow
    }()
    
    let imagesStack: UIStackView = {
        let images = UIStackView()
        images.axis = .horizontal
        images.spacing = 8
        images.distribution = .fillEqually
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        setUp()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(imagesNames: [String]) {
        
        imagesNames.forEach({
            let image = UIImageView()
            image.image = UIImage(named: $0)
            image.layer.cornerRadius = 6
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
            imagesStack.addArrangedSubview(image)
        })
    }
    
    private func setUp() {
        
        self.addSubview(photoLabel)
        photoLabel.addSubview(arrow)
        self.addSubview(imagesStack)
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            photoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            photoLabel.bottomAnchor.constraint(equalTo: imagesStack.topAnchor, constant: -12),
            photoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            
            arrow.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: photoLabel.trailingAnchor),
            
            imagesStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            imagesStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            imagesStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            imagesStack.heightAnchor.constraint(equalToConstant: 80)
            
        ])
    }
    
}
