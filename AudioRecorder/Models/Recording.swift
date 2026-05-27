//
//  Recording.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import Foundation

struct Recording:Identifiable,Equatable {
    let id: UUID
    let fileURL:URL
    let createdAt:Date
    let duration:TimeInterval
    var fileName: String {
           fileURL.deletingPathExtension().lastPathComponent
       }
}

