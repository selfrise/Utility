//
//  String+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import Foundation

extension String {
    
    func localized() -> String {
        localized(bundle: Bundle.module)
    }
    
    public func localized(
        for resource: String = Localization.getCurrentLanguage().id,
        bundle: Bundle = Bundle.main
    ) -> String {
        guard let path = bundle.path(forResource: resource, ofType: "lproj") else {
            return self
        }
        
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

