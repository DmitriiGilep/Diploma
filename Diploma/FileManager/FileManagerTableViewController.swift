//
//  FileManagerTableViewController.swift
//  Industrial
//
//  Created by DmitriiG on 29.10.2022.
//

import UIKit

final class FileManagerTableViewController: UITableViewController {
    
    var sortStatus = true {
        didSet {
            UserDefaults.standard.set(sortStatus, forKey: "sortStatus")
            UserDefaults.standard.synchronize()
            tableView.reloadData()
        }
    }
    
    var imageToSave: UIImage?
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var urlArray: [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)) ?? []
    }
    private var urlPathsArray: [String] {
        var urls: [String] = []
        let urlArray = (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)) ?? []
        for i in urlArray {
            urls.append(i.lastPathComponent)
        }
        if sortStatus {
            return urls.sorted(by: < )
        } else {
            return urls.sorted(by: > )
        }
        
    }
    
    lazy var settingsTableViewController = SettingsTableViewController(passwordView: passwordView, controller: self)
    
    let passwordView = PasswordView()
    
    private func setUpAndLaunchAlertController() {
        let alertController = UIAlertController(title: "save_picture".localizable, message: "choose_name_picture".localizable, preferredStyle: .alert)
        alertController.addTextField { text in
            text.placeholder = "insert_filename".localizable
        }
        let alertActionSave = UIAlertAction(title: "save".localizable, style: .default) { UIAlertAction in
            self.savePhoto(alertController: alertController)
        }
        let alertActionCancel = UIAlertAction(title: "cancel".localizable, style: .default)
        alertController.addAction(alertActionSave)
        alertController.addAction(alertActionCancel)
        self.present(alertController, animated: true)
    }
    
    private func savePhoto(alertController: UIAlertController) {
        guard let imageName = alertController.textFields![0].text else {return}
        let imageURL = url.appendingPathComponent(imageName)
        var unique = true
        urlArray.forEach({ URL in
            if imageURL == URL {
                unique = false
            }
        })
        guard unique else {
            let alert = UIAlertController(title: "error".localizable, message: "name_exist".localizable, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(actionOk)
            self.present(alert, animated: true)
            return
            
        }
        guard let image = imageToSave else {return}
        if let imageJPEG = image.jpegData(compressionQuality: 0.8) {
            do {
                try imageJPEG.write(to: imageURL)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUpPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true)
    }
    
    @objc func addPhoto() {
        setUpPicker()
    }
    
    @objc func launchSettingsTableViewController() {
        settingsTableViewController.title = "settings".localizable
 //       self.present(settingsTableViewController, animated: true)
        self.navigationController?.pushViewController(settingsTableViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.navigationItem.title = "directory".localizable
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add_photo".localizable, style: .done, target: self, action: #selector(addPhoto))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "settings".localizable, style: .plain, target: self, action: #selector(launchSettingsTableViewController))
        
        sortStatus = UserDefaults.standard.bool(forKey: "sortStatus")
  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if passwordView.loginStatus == false {
            self.navigationController?.isNavigationBarHidden = true
            passwordView.launchCreatePasswordAlertWindow(controller: self)
        }
  //      fullUpUrlPathsArray()
  //      sortArrayAndReload(up: sortStatus)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlPathsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  
        var content = cell.defaultContentConfiguration()
        content.text = urlPathsArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? FileManager.default.removeItem(at: urlArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = try? Data(contentsOf: urlArray[indexPath.row])
        let imageViewFromTable = UIImageView(image: UIImage(data: data!))
        
        let transparentView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.alpha = 0.9
            return view
        }()
        
        lazy var buttonX = CustomButton(title: (name: "X", state: .normal), titleColor: (color: .black, state: .normal), backgroundImage: (image: nil, state: nil)) {
            removeViews()
        }
        
        buttonX.setTitle("XX", for: .highlighted)
        
        transparentView.frame = view.frame
        imageViewFromTable.frame = view.frame
        view.addSubview(transparentView)
        view.addSubview(imageViewFromTable)
        view.addSubview(buttonX)

        NSLayoutConstraint.activate([
            buttonX.trailingAnchor.constraint(equalTo: imageViewFromTable.trailingAnchor),
            buttonX.leadingAnchor.constraint(equalTo: imageViewFromTable.trailingAnchor, constant: -40),
            buttonX.bottomAnchor.constraint(equalTo: imageViewFromTable.bottomAnchor, constant: -180),
            buttonX.topAnchor.constraint(equalTo: imageViewFromTable.bottomAnchor, constant: -220)
        ])
    
        func removeViews() {
                buttonX.removeFromSuperview()
                transparentView.removeFromSuperview()
                imageViewFromTable.removeFromSuperview()

        }
        
    }
    
}

extension FileManagerTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // метод срабатывает после окончания выбора
        
        guard let image = info[.editedImage] as? UIImage else { return } // .editedImage так как picker.allowsEditing = true
        imageToSave = image
        dismiss(animated: true)
        setUpAndLaunchAlertController()
    }
}
