//
//  RecordingSavedPopupView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import SwiftUI

struct RecordingSavedPopupView: View {
    
    let recordingName: String
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.green)
            
            Text("Recording Saved")
                .font(.headline)
            
            Text(recordingName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: 250)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 20)
    }
}

