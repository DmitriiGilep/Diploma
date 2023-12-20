//
//  PostViewController.swift
//  Diploma
//
//  Created by DmitriiG on 06.08.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var imageToSave: UIImage?
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    

    let authorLabel: UILabel = {
        let author = UILabel()
        author.text = FavoritesCoreData.shared.user[0].name ?? "No name"
        author.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        author.layer.borderColor = UIColor.black.cgColor
        author.translatesAutoresizingMaskIntoConstraints = false
        return author
    }()
    
    let avatarImage: UIImageView = {
        let view = UIImageView()
        if let url = URL(string: FavoritesCoreData.shared.user[0].avatarImage!) {
            NetworkService.requestForAvatar(url: url) { imageViaLink in
                DispatchQueue.main.async {
                    view.image = imageViaLink
                }
            }
        } else {
            view.image = UIImage(named: "No_image_available")!
        }
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageForPost: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "No_image_available")
        view.image = image
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addImageButton = CustomButton(title: (name: "add_photo".localizable, state: nil), titleColor: (color: .black, state: .disabled), cornerRadius: 6, backgroundColor: CustomColors.customButtonBlue, backgroundImage: (image: nil, state: nil), clipsToBounds: true) {
        self.addImage()
    }
    
    let postTextField: UITextField = {
        let postText = UITextField()
        postText.layer.borderWidth = 1
        postText.layer.borderColor = CustomColors.customButtonBlue.cgColor
        postText.layer.cornerRadius = 12
        postText.layer.backgroundColor = CustomColors.customGray.cgColor
        postText.placeholder = "writeYourPost".localizable
        postText.textAlignment = .natural
        postText.translatesAutoresizingMaskIntoConstraints = false
        return postText
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
    }
   
    @objc private func cancel() {
        self.dismiss(animated: true)
    }
    
    
    private func setViews() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localizable, style: .done, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "post".localizable, style: .done, target: self, action: #selector(postPost))
        view.addSubview(authorLabel)
        view.addSubview(avatarImage)
        view.addSubview(imageForPost)
        view.addSubview(addImageButton)
        view.addSubview(postTextField)
        
        NSLayoutConstraint.activate(
            [
                avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                avatarImage.widthAnchor.constraint(equalToConstant: 50),
                avatarImage.heightAnchor.constraint(equalToConstant: 50),
                
                authorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                authorLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 5),
                authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                authorLabel.heightAnchor.constraint(equalToConstant: 50),
                
                imageForPost.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                imageForPost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                imageForPost.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
                imageForPost.heightAnchor.constraint(equalToConstant: 230),
                
                addImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                addImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                addImageButton.topAnchor.constraint(equalTo: imageForPost.bottomAnchor, constant: 10),
                addImageButton.heightAnchor.constraint(equalToConstant: 40),
                
                postTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                postTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                postTextField.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 15),
                postTextField.heightAnchor.constraint(equalToConstant: 300),
                
            ]
        )
    }
    
    private func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true)
    }
    
    private func setImage() {
        imageForPost.image = imageToSave
//        let imageName = UUID().uuidString
//        let imageURL = url.appendingPathComponent(imageName)
//        var unique = true
//        
//        guard let image = imageToSave else {return}
//        if let imageJPEG = image.jpegData(compressionQuality: 0.8) {
//            do {
//                try imageJPEG.write(to: imageURL)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
    
    @objc private func postPost(){
        NetworkService.request { message in
            
            let imageURL = message.message
            DispatchQueue.main.async {
                let post = Post(author: self.authorLabel.text!, avatarImage: FavoritesCoreData.shared.user[0].avatarImage!, descriptionOfPost: self.postTextField.text!, image: imageURL, likes: 0, views: 0)
                
                FavoritesCoreData.shared.addPostFeed(post: post)
                FavoritesCoreData.shared.addPostProfile(post: post)
                self.dismiss(animated: true)
            }
            
        } completionForData: { profile in
            ()
        } completionForDesctription: { description in
            ()
        }

        

    }
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageToSave = image
        dismiss(animated: true)
        setImage()
    }
    
}
