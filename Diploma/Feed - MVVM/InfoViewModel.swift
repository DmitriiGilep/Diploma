//
//  InfoViewModel.swift
//  Industrial
//
//  Created by DmitriiG on 30.08.2022.
//

import Foundation

final class InfoViewModel {
    
    enum InterFaceEvents {
        case buttonPresentAlertViewTapped
        case urlRequest
        case urlRequest2
        case urlRequest3
    }
    
    enum State {
        case goToAlertView
        case processUrlRequest
        case processUrlRequest2
        case processUrlRequest3
    }
    
    var title: String = "fetching_in_process".localizable {
        didSet {
            processInterfaceEvents?(.processUrlRequest) // как только появляется значение title запусается case .processURLReques, который в контроллере присваивает лэйблу текст
        }
    }
    
    var orbitalPeriod: String = "fetching_in_process".localizable {
        didSet {
            processInterfaceEvents?(.processUrlRequest2) // аналогично указанному выше в отношении орбитал периода
        }
    }
    
    var residentsUrl: [String] = [] {
        didSet {
            changeState(interFaceEvent: .urlRequest3, controller: nil) // как только появляются urlы запускается case urlRequest3 данной модели, в котором используются ссылки
        }
    }
    
    var residentsName: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.processInterfaceEvents?(.processUrlRequest3) // после получения имен из кейса .urlRequest3 запускается case .processUrlRequest3 в контроллере, который обновляет таблицу через reloadData()
            }
        }
    }
    
    var processInterfaceEvents: ((State) -> Void)?
    
    private(set) var state: State = .goToAlertView{
        didSet{
            processInterfaceEvents?(state)
        }
    }
    
    func changeState(interFaceEvent: InterFaceEvents, controller: InfoViewController?) {
        switch interFaceEvent {
        case .buttonPresentAlertViewTapped:
            state = .goToAlertView
        case .urlRequest: // serilization
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/9") else {
                print("error".localizable)
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    print("error".localizable)
                    return
                }
                guard let data = data else {
                    print("error".localizable)
                    return
                }
                
                do {
                    let object = try JSONSerialization.jsonObject(with: data)
                    if let dictionary = object as? [String: Any] {
                        _ = try JSONSerialization.data(withJSONObject: dictionary)
                        
                        DispatchQueue.main.async { // возвращаем в главный поток, тк JSONSerilization работает ассинхронно
                            self.title = dictionary["title"] as! String
                        }
                    }
                } catch {
                    print("error".localizable)
                    return
                }
            }
            task.resume()
            
        case .urlRequest2: // decoder
            guard let url = URL(string: "https://swapi.dev/api/planets/1") else {
                print("error2url")
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    print("error2task")
                    return
                }
                guard let data = data else {
                    print("error2date")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
               //     decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let tatooine = try decoder.decode(Tatooine.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.orbitalPeriod = tatooine.orbitalPeriod // присваиваю значения переменной, которая затем через didSet обновят интерфейс
                        self.residentsUrl = tatooine.residents // передаю url в массив для последующего запуска через didSet их обработки для получения имен
                    }
                    
                    } catch {
                    print("error2decoder")
                    return
                }
                
            }
            task.resume()
            
        case .urlRequest3: // decoder из массива, полученного из предыдущего кейса
            for ref in residentsUrl {
                guard let url = URL(string: ref) else {
                    print("error3url")
                    return
                }

                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard error == nil else {
                        print("error3task")
                        return
                    }
                    guard let data = data else {
                        print("error3date")
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let resident = try decoder.decode(Residents.self, from: data)
                        
                        self.residentsName.append(resident.name)
                        
                        } catch {
                        print("error3decoder")
                        return
                    }
                }
                task.resume()
            }
        }
    }
}
