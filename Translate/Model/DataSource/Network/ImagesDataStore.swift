//
//  ImagesDataStore.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

typealias ImagesDataStoreCompletion = (String?) -> Void

protocol IImagesDataStore {
    func downloadImage(link: String, completion: @escaping ImagesDataStoreCompletion)
}

fileprivate class DownloadQueueItem: Equatable {
    
    let link: String
    let completion: ImagesDataStoreCompletion
    
    init(link: String, completion: @escaping ImagesDataStoreCompletion) {
        self.link = link
        self.completion = completion
    }
    
    static func == (lhs: DownloadQueueItem, rhs: DownloadQueueItem) -> Bool {
        return lhs.link == rhs.link
    }
}

final class ImagesDataStore: IImagesDataStore {
    
    private let urlSession: URLSession = URLSession.shared
    private var item: DownloadQueueItem?
    
    // MARK: IImagesDataStore
    
    public func downloadImage(link: String, completion: @escaping ImagesDataStoreCompletion)  {
        self.item = DownloadQueueItem(link: link, completion: completion)
        
        if let cachedImagePath = self.localImageForRemoteImage(link: link) {
            self.didCompleted(link: link, resultPath: cachedImagePath)
        } else {
            self.downloadImageFrom(link: link)
        }
    }
    
    // MARK: Public

    public func downloadLink(link: String?) -> String? {
        guard let link = link else { return nil }
        if link.isEmpty { return nil }
        
        var fullLink = link
        if false == fullLink.contains("https") {
            fullLink = "https:" + link
        }
        
        guard let encodedLink = fullLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else  { return nil }
        
        return encodedLink
    }
    
    public func isDwonloaded(link: String) -> Bool {
        let cachedImagePath = self.localImageForRemoteImage(link: link)
        return nil != cachedImagePath
    }
    
    public func removeDwonloaded(link: String?) {
        guard let encodedLink = self.downloadLink(link: link) else { return }
        guard let cachedImagePath = self.localImageForRemoteImage(link: encodedLink) else { return }
        
        do {
            try FileManager.default.removeItem(atPath: cachedImagePath)
        } catch {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) \(error)")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
            #endif
        }
    }
    
    public func localImageForRemoteImage(link: String) -> String? {
        
        guard var path = self.directory() else {
            return nil
        }
        
        guard let fileName = self.fileName(link: link) else {
            return nil
        }
        
        path += "/" + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        
        return nil
    }
    
    // MARK: - Private
    
    private func directory() -> String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    private func didCompleted(link: String, resultPath: String?) {
        DispatchQueue.main.async {
            self.item?.completion(resultPath)
        }
    }
    
    private func downloadImageFrom(link: String) {
        guard let encodedLink = self.downloadLink(link: link) else {
            self.didCompleted(link: link, resultPath: nil)
            return
        }
        
        guard let url = URL(string: encodedLink) else {
            self.didCompleted(link: link, resultPath: nil)
            return
        }
        
        let downloadTask = self.urlSession.downloadTask(with: url) { [weak self] (tempFile: URL?, response: URLResponse?, error: Error?) in

            guard let self = self else { return }
            
            var data: Data?
            if let tempFile = tempFile {
                do {
                    data = try Data(contentsOf: tempFile)
                } catch {
                    #if DEBUG
                    fatalError("Exception \(#file) \(#function) \(#line) \(error)")
                    #else
                    debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
                    #endif
                }
            } else if let error = error {
                debugPrint("downloadTask error \(link) \(#file) \(#function) \(#line) \(error)")
            }
            
            if let data = data {
                self.saveDataFrom(link: link, data: data)
            } else {
                self.didCompleted(link: link, resultPath: nil)
            }
        }
        downloadTask.resume()
    }
    
    private func saveDataFrom(link: String, data: Data) {
        guard var path = self.directory() else {
            self.didCompleted(link: link, resultPath: nil)
            return
        }
        
        guard let fileName = self.fileName(link: link) else {
            self.didCompleted(link: link, resultPath: nil)
            return
        }
        
        path += "/" + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            self.didCompleted(link: link, resultPath: path)
        } else if FileManager.default.createFile(atPath: path, contents: data, attributes: nil) {
            self.didCompleted(link: link, resultPath: path)
        } else {
            self.didCompleted(link: link, resultPath: nil)
        }
    }
    
    private func fileName(link: String) -> String? {
        guard let fileName = CryptoHelper().stringMD5(string: link) else {
            return nil
        }
        return fileName.replacingOccurrences(of: "/", with: "-")
    }
}
