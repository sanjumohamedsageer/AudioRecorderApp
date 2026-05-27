//
//  AudioPlaybackServiceProtocol.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import Foundation

protocol AudioPlaybackServiceProtocol:AnyObject {
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    
    func startPlayback(url:URL)
    func pausePlayback()
    func seek(to time: TimeInterval)
    
}
