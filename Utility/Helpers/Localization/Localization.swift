//
//  Localization.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import Foundation

public final class Localization: NSObject {
    
    /// Internal current language key
    static let LCLCurrentLanguageKey = "CurrentLanguageKey"
    
    private static var userDefaults: UserDefaults = .standard
    private static var bundle: Bundle = .main
    
    public enum LanguageType: String {
        case en, tr
        
        public var id: String { rawValue }
        
        public var toggledValue: Self {
            self == .en ? .tr : .en
        }
    }
    
    /**
      List available languages
      - Returns: Array of available languages.
      */
    public static var availableLanguages: [String] {
        return bundle.localizations
    }
    
    /**
      Selected default language by developers
      - Returns: The app's default language. LanguageType.
      */
    public static let defaultLanguage: LanguageType = .tr
    
    /**
      Get current language
      - Returns: The current language. LanguageType.
      */
    public static func getCurrentLanguage() -> LanguageType {
        let languageStr = userDefaults.object(forKey: LCLCurrentLanguageKey) as? String ?? defaultLanguage.id
        return LanguageType.init(rawValue: languageStr) ?? defaultLanguage
    }
    
    public static func getCurrentLocale() -> Locale {
        let identifier: String = getCurrentLanguage() == .tr ? "tr_TR" : "en_US_POSIX"
        return Locale(identifier: identifier)
    }
    
    /**
      Change the current language
      - Parameter language: Desired language.
      */
    public static func setCurrentLanguage(_ language: LanguageType) {
        let selectedLanguage = availableLanguages.contains(language.id) ? language : defaultLanguage
        guard selectedLanguage != getCurrentLanguage() else { return }
        userDefaults.set(selectedLanguage.id, forKey: LCLCurrentLanguageKey)
    }
    
    /**
      Resets the current language to the default
      */
    public static func resetCurrentLanguageToDefault() {
        setCurrentLanguage(defaultLanguage)
    }
    
    // MARK: Language Setting Functions
    
    public static func toggleLanguage() {
        let newLanguage: LanguageType = getCurrentLanguage().toggledValue
        setCurrentLanguage(newLanguage)
    }
    
    public static func register(
        bundle: Bundle,
        userDefaults: UserDefaults
    ) {
        self.bundle = bundle
        self.userDefaults = userDefaults
    }
}
