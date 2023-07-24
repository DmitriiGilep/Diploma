//
//  FavoritesCell.swift
//  Industrial
//
//  Created by DmitriiG on 08.01.2023.
//

import Foundation
import UIKit

final class FavoritesCell: UIView {
    
    private let textLabel: UILabel = {
       let text = UILabel()
        text.text = "favorites".localizable
        text.adjustsFontSizeToFitWidth = true
        text.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let doorSign: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "door.right.hand.open")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setup()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(textLabel)
        self.addSubview(doorSign)
        
        NSLayoutConstraint.activate([
            
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            textLabel.heightAnchor.constraint(equalToConstant: 70),
            
            doorSign.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            doorSign.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            doorSign.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            doorSign.heightAnchor.constraint(equalToConstant: 70),
            doorSign.widthAnchor.constraint(equalToConstant: 70)
            
            ])

    }
    
}
