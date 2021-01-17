//
//  ImageCache.swift
//  Trouver
//
//  Created by Sagar Punhani on 12/24/20.
//

import SwiftUI

/*
 In memory cache wrapper around nscache
 */

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            if let value = newValue {
                cache.setObject(value, forKey: key as NSURL)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
