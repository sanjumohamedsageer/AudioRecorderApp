//
//  WaveformView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import SwiftUI

struct WaveformView: View {
    
    let samples: [CGFloat]
    
    var body: some View {
        
        HStack(spacing: 3) {
            
            ForEach(samples.indices, id: \.self) { index in
                
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                .blue.opacity(0.7),
                                .cyan
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: 4,
                        height: max(8, samples[index])
                    )
            }
        }
        .frame(height: 60)
    }
}

