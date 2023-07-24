//
//  PhotosViewController.swift
//  Navigation
//
//  Created by DmitriiG on 20.05.2022.
//

import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {
    
    //    private let imagePublisherFacade = ImagePublisherFacade()
    let imageProcessor = ImageProcessor()
    let profileErrorsProcessor = ProfileErrorsProcessor()
    
    // экземпляр класса, в котором будет массив для хранения всех картинок imagesArray
    private var photoData = PhotoData(photos: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20])
    //private var photoData = PhotoData(photos: []) // пустой массив для вывода ошибки - нет картинок
    
    private var photosCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8)
        return layout
    } ()
    
    private lazy var photosCollectionView: UICollectionView = {
        let photos = UICollectionView(frame: .zero, collectionViewLayout: photosCollectionViewFlowLayout)
        photos.dataSource = self
        photos.delegate = self
        photos.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        photos.translatesAutoresizingMaskIntoConstraints = false
        return photos
    }()
    
    private func setUP() {
        self.title = "photo_gallery".localizable
        self.view.addSubview(photosCollectionView)
        
        NSLayoutConstraint.activate([
            
            photosCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
    }
    
    func applyFilterToImagesArrayWithTimer() {
        
        let start = DispatchTime.now()
        imageProcessor.processImagesOnThread(
            sourceImages: self.photoData.imagesArray,
            filter: .colorInvert,
            qos: .background) {
                outPutImages in
                self.photoData.imagesArray = outPutImages.compactMap { cgImage -> UIImage in return UIImage(cgImage: cgImage!) }
                // конец выполнения кода зафиксировал внутри completion, так как completion выполняется самостоятельно не в главном потоке позже запуска функции
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("!!!TIME FOR processImagesOnThread \(timeInterval)")
            }
        
        photoData.imageArrayUpdateStatus = {
            [weak self] in
            DispatchQueue.main.async { // вернул обработку UIKit метода reloadData в main поток
                self?.photosCollectionView.reloadData()
                
            }
        }
    }

    // функция с Result, определяет, пустой ли массив
    private func imageForCell(images: [UIImage], indexPath: IndexPath, completion: @escaping (Result<UIImage, ProfileErrors>) -> Void) {
        switch images.isEmpty {
        case false:
            let image = images[indexPath.row]
            completion(.success(image))
        case true:
            completion(.failure(ProfileErrors.noImagesForCollection))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        navigationController?.navigationBar.isHidden = false
        // подписал на протокол = добавление контроллера в массив observer
        //imagePublisherFacade.subscribe(self)
        // вызов функции по добавлению в массив observer картинок для последующей его передачи в функцию receive
        //       imagePublisherFacade.addImagesWithTimer(time: 5, repeat: 10)
        applyFilterToImagesArrayWithTimer()
        print("value of imagesArray: \(photoData.imagesArray.isEmpty)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        
        // удаляет из подписки и обнуляет массив observer
        //        imagePublisherFacade.removeSubscription(for: self)
        //        imagePublisherFacade.rechargeImageLibrary()
    }
    
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //    func receive(images: [UIImage]) {
    //
    //        // добавил в общий массив картинок полученные images
    //   //     photoData.createPhotoDataUIImage(photo: images)
    //        // обновил ячейки, чтобы добавить новые картинки
    //        photosCollectionView.reloadData()
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arrayNumber = photoData.imagesArray.count
        // в случае пустого массива устанавливается значение 1, чтобы сработал метод cellForItemAt и в нем функция imageForCell
        if arrayNumber==0 {
            return 1
        } else {
            return arrayNumber
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
//        let alertView = self.profileErrorsProcessor.processErrors(error: ProfileErrors.noImagesForCollection)
//        self.present(alertView, animated: true, completion: nil)
        
        imageForCell(images: photoData.imagesArray, indexPath: indexPath) { [weak self] result in
            switch result {
            case .success(let image):
                cell.imageForCell = image
            case .failure(let error):
                let alertView = self?.profileErrorsProcessor.processErrors(error: error)
                self?.present(alertView!, animated: true, completion: nil)
            }
        }
        
        //        let imageForCell = photoData.imagesArray[indexPath.row]
        //        cell.imageForCell = imageForCell
        
        
        //        if let image = cell.photoImageView.image { imageProcessor.processImage(sourceImage: image, filter: .chrome, completion: {filteredPicture in cell.photoImageView.image = filteredPicture})
        //        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding: CGFloat = 8*4
        let numberOfCellInRow : CGFloat = 3
        let collectionCellWidth: CGFloat = (self.view.frame.size.width - totalPadding) / numberOfCellInRow
        return CGSize(width: collectionCellWidth , height: collectionCellWidth*0.7)
        
    }
    
}
