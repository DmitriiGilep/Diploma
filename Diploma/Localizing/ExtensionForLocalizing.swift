//
//  ExtensionForLocalizing.swift
//  Industrial
//
//  Created by DmitriiG on 01.02.2023.
//

import Foundation

extension String {
    
    var localizable: String {
        NSLocalizedString(self, comment: "")
    }
    
}
