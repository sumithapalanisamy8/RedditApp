//
//  UrlImage.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import UIKit
import SwiftUI
import Combine

final class UrlImage: ObservableObject {
    @Published var image: UIImage?
    var imageCache = ImageCache()
    let apiService: APIService
    let imageUrl: URL
    var subscriptions = Set<AnyCancellable>()
    
    init(api: APIService = APIService(), url: URL) {
        self.apiService = api
        self.imageUrl = url
    }

    func fetchImage() {
        //Load image from cache
        if loadImageFromCache() {
            return
        }
        //If image not available in cache, load from url
        loadImageFromUrl()
    }

    func loadImageFromCache() -> Bool {
        guard let cacheImage = imageCache.get(forKey: "\(imageUrl)") else {
            return false
        }
        self.image = cacheImage
        return true
    }

    func loadImageFromUrl() {
        self.apiService.image(from: imageUrl)
            .sink(receiveCompletion: { (error) in
                print(error)
            }, receiveValue: { data in
                guard let data = data else {
                    return
                }
                self.getImageFromResponse(data: data)
            })
            .store(in: &subscriptions)
    }

    func getImageFromResponse(data: Data?) {
        guard let data = data else {
            print("No data found")
            return
        }
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.imageCache.set(forKey: "\(self.imageUrl)", image: loadedImage)
            self.image = loadedImage
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }

    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}
