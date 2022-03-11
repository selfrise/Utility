//
//  ImageManager.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import Foundation

public typealias StateHandler = (Bool) -> Void

public enum ImageResult: Equatable {
    case value(Data)
    case none
    case expired
}

public protocol ImageManagerProtocol {
    @discardableResult
    func get(with imageURL: String, completion: @escaping (ImageResult) -> Void) -> URLSessionTask?
    func save(id: String, imageData: Data, completion: StateHandler?)
    func get(id: String, completion: @escaping (ImageResult) -> Void)
    func remove(forKey key: String)
}

public final class ImageManager: ImageManagerProtocol {
    
    // MARK: public properties
    
    public static let shared = ImageManager()
    
    // MARK: private properties
    
    private let dispatchQueue = DispatchQueue(label: "com.selfrise.Utility")
    private let fileManager: FileManager = .default
    private var fileURL: (String) -> URL? = {
        guard let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return directory.appendingPathComponent($0)
        
    }
    private let cache = NSCache<NSString, NSData>()
    
    private enum Constant {
        static let countLimit = 100
        static let memoryLimit = 1024 * 1024 * 100
        
    }
    
    private enum ImageManagerError: Error, CustomStringConvertible {
        case save
        case remove
        
        var description: String {
            switch self {
            case .save:
                return "error saving file with error"
            case .remove:
                return "couldn't remove file at path"
            }
            
        }
    }
    
    // MARK: init
    
    private init() {
        cache.totalCostLimit = Constant.memoryLimit
        cache.countLimit = Constant.countLimit
    }
    
    // MARK: public protocol methods
    
    public func get(id: String, completion: @escaping (ImageResult) -> Void) {
        if let image = cache.object(forKey: id as NSString) {
            completion(.value(image as Data))
            return
        }
        
        loadImageFromDiskWith(id: id) { (result) in
            if case .value(let image) = result {
                self.cache.setObject(image as NSData, forKey: id as NSString)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    public func save(
        id: String,
        imageData: Data,
        completion: StateHandler?
        
    ) {
        saveToFile(
            id: id,
            imageModel: ImageModel(imageData: imageData),
            completion: completion
        )
    }
    
    public func remove(forKey key: String) {
        removeFromMemory(id: key)
        dispatchQueue.async {
            self.removeFromDisk(id: key)
        }
    }
    
    @discardableResult
    public func get(with imageURL: String, completion: @escaping (ImageResult) -> Void)
    -> URLSessionTask?
    {
        if let cachedImage = cache.object(forKey: imageURL as NSString) as Data? {
            completion(.value(cachedImage))
            return nil
        }
        
        guard let url = URL(string: imageURL) else {
            completion(.none)
            return nil
        }
        
        let request = URLSession.shared.dataTask(
            with: url,
            completionHandler: { (data, _, _) in
                guard let data = data else {
                    completion(.none)
                    return
                }
                
                self.cache.setObject(data as NSData, forKey: NSString(string: url.absoluteString))
                
                DispatchQueue.main.async {
                    completion(.value(data))
                }
                
            })
        
        request.resume()
        return request
        
    }
    
    // MARK: private methods
    
    private func loadImageFromDiskWith(id: String, completion: @escaping (ImageResult) -> Void) {
        dispatchQueue.async {
            guard let url = self.fileURL(id) else {
                completion(.none)
                return
            }
            
            guard let data = try? Data(contentsOf: url),
                  let imageModel = try? JSONDecoder().decode(ImageModel.self, from: data)
            else {
                completion(.none)
                return
            }
            
            if let expirationDate = imageModel.expirationDate, Date() > expirationDate {
                self.remove(forKey: id)
                completion(.expired)
                return
                
            }
            if let image = imageModel.imageData {
                completion(.value(image))
                
            } else {
                completion(.none)
                
            }
        }
    }
    
    private func saveToFile(
        id: String,
        image: Data,
        completion: @escaping (Bool) -> Void
    ) {
        saveToFile(
            id: id,
            imageModel: ImageModel(imageData: image),
            completion: completion
        )
    }
    
    private func saveToFile(
        id: String,
        imageModel: ImageModel,
        completion: ((Bool) -> Void)?
    ) {
        dispatchQueue.async(qos: .background) {
            guard let fileURL = self.fileURL(id),
                  let data = try? JSONEncoder().encode(imageModel)
            else {
                completion?(false)
                return
            }
            
            self.removeFromDisk(id: id)
            
            do {
                try data.write(to: fileURL, options: .completeFileProtection)
                completion?(true)
                
            } catch let error {
                print(ImageManagerError.save.description, error)
                completion?(false)
            }
        }
    }
    
    private func removeFromMemory(id: String) {
        cache.removeObject(forKey: id as NSString)
    }
    
    private func removeFromDisk(id: String) {
        guard let fileURL = fileURL(id) else {
            return
        }
        if self.fileManager.fileExists(atPath: fileURL.path) {
            do {
                try self.fileManager.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print(ImageManagerError.remove.description, removeError)
            }
        }
    }
}

private final class ImageModel: Codable {
    let expirationDate: Date?
    let imageData: Data?
    
    init(imageData: Data, expirationDate: Date? = nil) {
        self.imageData = imageData
        self.expirationDate = expirationDate
    }
}
