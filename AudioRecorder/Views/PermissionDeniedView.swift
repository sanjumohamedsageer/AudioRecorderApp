//
//  PermissionDeniedView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import SwiftUI

struct PermissionDeniedView: View {
    
    let openSettings: () -> Void
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Spacer()
            
            Image(systemName: "mic.slash.fill")
                .font(.system(size: 70))
                .foregroundStyle(.red)
            
            VStack(spacing: 10) {
                
                Text("Microphone Access Denied")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Text(
                    "Please allow microphone access in Settings to record audio."
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
            }
            
            Button(action: openSettings) {
                
                Text("Open Settings")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.accent)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
