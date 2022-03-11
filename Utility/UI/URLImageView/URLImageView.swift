//
//  URLImageView.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import UIKit

public final class URLImageView: UIImageView {
    
    // MARK: - Variables
    
    private var imageTask: URLSessionTask?
    private let showIndicator: Bool
    private lazy var loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - Init
    
    public init(showIndicator: Bool = false) {
        self.showIndicator = showIndicator
        super.init(frame: .zero)
        buildIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func buildIndicator() {
        guard showIndicator else {
            return
        }
        
        fit(subView: loadingIndicator)
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setIndicator(show: Bool) {
        guard showIndicator else {
            return
        }
        
        show
        ? loadingIndicator.startAnimating()
        : loadingIndicator.stopAnimating()
    }
    
    // MARK: - Internal methods
    
    public func imageWithURL(_ url: String, placeHolder: UIImage?) {
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        imageTask?.cancel()
        imageTask = nil
        image = placeHolder
        setIndicator(show: true)
        
        imageTask = ImageManager.shared.get(with: urlString, completion: { result in
            switch result {
            case .value(let data):
                guard let downloadedImage = UIImage(data: data) else {
                    return
                }
                
                self.image = downloadedImage
            default:
                print("Image URL: \(url) can not load")
            }
            
            self.setIndicator(show: false)
        })
        
        imageTask?.resume()
    }
}
