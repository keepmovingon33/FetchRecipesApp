//
//  DataCache.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

final class DataCache {
    private let cache = NSCache<NSString, NSData>()
        
    func getData(for key: String) -> Data? {
        return cache.object(forKey: key as NSString) as? Data
    }
    
    func setData(_ data: Data, for key: String) {
        let nsData = NSData(data: data)
        cache.setObject(nsData, forKey: key as NSString)
    }
}
