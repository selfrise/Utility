//
//  BundleSPM.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import class Foundation.Bundle

#if !SWIFT_PACKAGE

private class BundleFinder {}

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module,
    
    static var module: Bundle = {
        let bundle = Bundle(for: BundleFinder.self)
        return bundle
    }()
}
#endif
