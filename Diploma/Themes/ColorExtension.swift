//
//  Colors.swift
//  Industrial
//
//  Created by DmitriiG on 13.02.2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        
        return UIColor { (traitcollection) -> UIColor in
            return traitcollection.userInterfaceStyle == .light ? lightMode: darkMode
            
        }
    }
}
