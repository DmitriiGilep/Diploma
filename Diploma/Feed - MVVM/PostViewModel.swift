//
//  PostViewModel.swift
//  Industrial
//
//  Created by DmitriiG on 30.08.2022.
//

import Foundation

final class PostViewModel {
    
    enum InterfaceEvents{
        case buttonGoToInfoViewControllerPressed
    }
    
    enum State {
        case goToInfoViewController
    }
    
    var processInterfaceEvents: ((State) -> Void)?
    
    private(set) var state: State = .goToInfoViewController {
        didSet {
            processInterfaceEvents?(state)
        }
    }
    
    
    func changeState(interfaceEvent: InterfaceEvents, controller: PostViewController){
        switch interfaceEvent {
        case .buttonGoToInfoViewControllerPressed:
            state = .goToInfoViewController
        }
    }
}
