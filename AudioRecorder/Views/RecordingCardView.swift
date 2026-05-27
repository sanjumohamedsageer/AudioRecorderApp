//
//  RecordingCardView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//


import SwiftUI

struct RecordingCardView: View {
    
    let recording: Recording
    let isActive: Bool
    @ObservedObject
    var playbackService: AudioPlaybackService
    let playAction: () -> Void
    let seekAction: (Double) -> Void
    let deleteAction: () -> Void
    let renameAction: () -> Void
    private var progress: CGFloat {
        
        guard playbackService.duration > 0 else {
            return 0
        }
        
        let value =
        playbackService.currentTime /
        playbackService.duration
        
        return CGFloat(value)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                
                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {
                    
                    Text(recording.fileName)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(
                        recording.createdAt
                            .formattedString()
                    )
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Text(
                    recording.duration
                        .formattedTime()
                )
                .font(.caption)
                .foregroundStyle(.gray)
            }
            
            HStack(spacing: 16) {
                
                Button(action: playAction) {
                    
                    Image(
                        systemName:
                            isActive &&
                            playbackService.isPlaying
                            ? "pause.fill"
                            : "play.fill"
                    )
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(AppTheme.accent)
                    )
                }
                
                VStack(spacing: 10) {
                    
                    ZStack(alignment: .leading) {
                        
                        Capsule()
                            .fill(
                                Color.white.opacity(0.15)
                            )
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(AppTheme.accent)
                            .frame(
                                width:
                                    isActive
                                    ? max(
                                        0,
                                        min(
                                            progress * 240,
                                            240
                                        )
                                    )
                                    : 0,
                                height: 6
                            )
                            .animation(
                                .linear(duration: 0.1),
                                value:
                                    playbackService.currentTime
                            )
                    }
                    .frame(width: 240, height: 6)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(
                            minimumDistance: 0
                        )
                        .onChanged { value in
                            
                            guard isActive else {
                                return
                            }
                            
                            let percentage =
                            min(
                                max(
                                    0,
                                    value.location.x / 240
                                ),
                                1
                            )
                            
                            seekAction(percentage)
                        }
                    )
                    
                    HStack {
                        
                        Text(
                            isActive
                            ? playbackService.currentTime
                                .formattedTime()
                            : "00:00"
                        )
                        
                        Spacer()
                        
                        Text(
                            isActive
                            ? playbackService.duration
                                .formattedTime()
                            : recording.duration
                                .formattedTime()
                        )
                    }
                    .font(.caption2)
                    .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(AppTheme.card)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
        .contextMenu {
            
            Button {
                renameAction()
            } label: {
                
                Label(
                    "Rename",
                    systemImage: "pencil"
                )
            }
            
            Button(
                role: .destructive
            ) {
                deleteAction()
            } label: {
                
                Label(
                    "Delete Recording",
                    systemImage: "trash"
                )
            }
        }
    }
}
