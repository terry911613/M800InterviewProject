//
//  MusicInfo.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import Foundation

public struct MusicInfo: Codable {
    public let artistName: String
    public let trackName: String
    public let artworkUrl100: String
    public let previewUrl: String
    
    public var imageData: Data?
    public var isPlaying: Bool? = false
}
