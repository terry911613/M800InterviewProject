//
//  MusicViewModel.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import Foundation
import AVFoundation

public class MusicViewModel {
    
    private var musicInfos = [MusicInfo]()
    
    // MARK: - Bind
    public var musicCount: Int {
        musicInfos.count
    }
    
    public func imageData(for indexPath: IndexPath) -> Data? {
        musicInfos[indexPath.row].imageData
    }
    
    public func imageUrl(for indexPath: IndexPath) -> String {
        musicInfos[indexPath.row].artworkUrl100
    }
    
    public func trackName(for indexPath: IndexPath) -> String {
        musicInfos[indexPath.row].trackName
    }
    
    public func artistName(for indexPath: IndexPath) -> String {
        musicInfos[indexPath.row].artistName
    }
    
    public func previewUrl(for indexPath: IndexPath) -> String {
        musicInfos[indexPath.row].previewUrl
    }
    
    public func isPlaying(for indexPath: IndexPath) -> Bool {
        musicInfos[indexPath.row].isPlaying ?? false
    }
    
    // MARK: - Set Data
    public func setImageData(for indexPath: IndexPath, urlString: String, data: Data) {
        if musicInfos.count > indexPath.count, musicInfos[indexPath.row].artworkUrl100 == urlString {
            musicInfos[indexPath.row].imageData = data
        }
    }
    
    // MARK: - API
    public func searchMusic(text: String, completion: @escaping (Result<Void, Error>) -> ()) {
        let urlString = "https://itunes.apple.com/search?\(convertParamsToStr(params: ["term": text, "media": "music"]))"
        if let url = URL(string: urlString) {
            NetworkRouter.request(url: url, type: [MusicInfo].self) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let musicInfos):
                    self.musicInfos = musicInfos
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            completion(.failure(AppError.urlNotFound))
        }
    }
    
    private func convertParamsToStr(params: [String: Any]) -> String {
        var paramArray = [String]()
        for (key, value) in params {
            if let newValue = (value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.replacingOccurrences(of: " ", with: "+") {
                paramArray.append("\(key)=\(newValue)")
            }
        }
        let paramsStr = paramArray.joined(separator: "&")
        return paramsStr
    }
    
    public func clickCancel() {
        self.musicInfos.removeAll()
    }
    
    // MARK: - Player
    private var player = AVPlayer()
    private var currentUrlString = ""
    private (set) var currentPlayIndexPath: IndexPath?
    
    public func resetCurrentPlayIndexPath() {
        currentUrlString.removeAll()
        if let currentPlayIndexPath = currentPlayIndexPath {
            musicInfos[currentPlayIndexPath.row].isPlaying = false
        }
        currentPlayIndexPath = nil
    }
    
    public func play(indexPath: IndexPath) {
        
        let urlString = previewUrl(for: indexPath)
        
        if currentUrlString == urlString {
            if player.rate == 0 {
                player.play()
                musicInfos[indexPath.row].isPlaying = true
            }
            else {
                player.pause()
                musicInfos[indexPath.row].isPlaying = false
            }
        }
        else {
            resetCurrentPlayIndexPath()
            if let url = URL(string: urlString) {
                currentUrlString = urlString
                currentPlayIndexPath = indexPath
                let playerItem = AVPlayerItem(url: url)
                player.replaceCurrentItem(with: playerItem)
                player.volume = 1.0
                player.play()
                musicInfos[indexPath.row].isPlaying = true
            }
        }
        
        if #available(iOS 10.0, *) {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } else {
            try? AVAudioSession.sharedInstance().setCategory(.playback, options: [])
        }
    }
}
