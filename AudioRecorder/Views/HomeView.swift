//
//  HomeView.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//


import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = RecorderViewModel()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            AppTheme.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.permissionState == .denied {
                    
                    PermissionDeniedView {
                        viewModel.openSettings()
                    }
                    
                } else {
                
                
                Text("Audio Recorder")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                HStack {
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    
                    TextField(
                        "Search recordings",
                        text: $viewModel.searchText
                    )
                    .foregroundStyle(.white)
                }
                .padding()
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
                
                if viewModel.recordings.isEmpty {
                    
                    Spacer()
                    
                    EmptyStateView()
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        
                        LazyVStack(spacing: 16) {
                            
                            ForEach(viewModel.filteredRecordings) { recording in
                                
                            RecordingCardView(
                                    recording: recording,
                                    isActive:
                                        viewModel.playbackService.currentlyPlayingURL ==
                                        recording.fileURL,
                                    playbackService: viewModel.playbackService,
                                    playAction: {
                                        viewModel.togglePlayback(for: recording)
                                    },
                                    seekAction: { value in
                                        viewModel.seekPlayback(to: value)
                                    },
                                    deleteAction: {
                                        viewModel.deleteRecording(recording)
                                    },
                                    renameAction: {
                                        viewModel.prepareRename(for: recording)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 180)
                    }
                }
            }
        }
            .padding(.top, 60)
            
            if viewModel.permissionState == .granted {
                
                FloatingRecorderView(
                    isRecording: viewModel.isRecording,
                    waveformSamples: viewModel.waveformSamples,
                    recordingDuration: viewModel.recordingDuration,
                    action: {
                        viewModel.toggleRecording()
                    }
                )
            }
            
            if viewModel.showSavedPopup {
                
                VStack {
                    
                    RecordingSavedPopupView(
                        recordingName: viewModel.savedRecordingName
                    )
                    
                    Spacer()
                }
                .padding(.top, 80)
            }
        }.alert(
            "Rename Recording",
            isPresented: $viewModel.showRenameAlert
        ) {
            
            TextField(
                "Recording Name",
                text: $viewModel.renameText
            )
            
            Button("Cancel", role: .cancel) {}
            
            Button("Save") {
                viewModel.renameRecording()
            }
        }
    }
}
