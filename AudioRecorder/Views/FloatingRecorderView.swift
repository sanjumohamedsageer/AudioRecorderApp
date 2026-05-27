//
//  FloatingRecorderView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import SwiftUI

struct FloatingRecorderView: View {
    
    let isRecording: Bool
    let waveformSamples: [CGFloat]
    let recordingDuration: TimeInterval
    let action: () -> Void
    var body: some View {
        
        VStack(spacing: 16) {
            
            Capsule()
                .fill(.gray.opacity(0.4))
                .frame(width: 40, height: 5)
            
            HStack(spacing: 16) {
                
                Button(action: action) {
                    
                    Image(systemName:
                            isRecording
                           ? "stop.fill"
                           : "mic.fill"
                    )
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(
                        Circle()
                            .fill(
                                isRecording
                                ? .red
                                : AppTheme.accent
                            )
                    )
                    .shadow(
                        color: isRecording
                        ? .red.opacity(0.5)
                        : .clear,
                        radius: 12
                    )
                    .scaleEffect(
                        isRecording ? 1.05 : 1
                    )
                    .animation(
                        isRecording
                        ? .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true)
                        : .default,
                        value: isRecording
                    )
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    WaveformView(
                        samples: waveformSamples
                    )
                    
                    HStack {
                        
                        Text(
                            isRecording
                            ? "Recording..."
                            : "Ready to Record"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text(
                            recordingDuration.formattedTime()
                        )
                        .font(
                            .caption.monospacedDigit()
                        )
                        .foregroundStyle(
                            isRecording
                            ? .red
                            : .gray
                        )
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 30)
        )
        .padding()
        .shadow(radius: 20)
    }
}
