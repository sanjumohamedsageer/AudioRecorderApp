//
//  EmptyStateView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Spacer()
            
            Image(systemName: "waveform")
                .font(.system(size: 60))
                .foregroundStyle(.gray)
            
            Text("No Recordings Yet")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text("Tap the recorder below to start")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
