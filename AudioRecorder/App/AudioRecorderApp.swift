//
//  AudioRecorderApp.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import SwiftUI

@main
struct AudioRecorderApp: App {
    
    init() {
       AudioSessionManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
