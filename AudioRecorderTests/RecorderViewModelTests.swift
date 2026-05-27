//
//  RecorderViewModelTests.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import XCTest
@testable import AudioRecorder

@MainActor
final class RecorderViewModelTests: XCTestCase {
    
    var viewModel: RecorderViewModel!
    
    
    override func setUp() {
        
        super.setUp()
        
        viewModel = RecorderViewModel()
    }
    
    override func tearDown() {
        
        viewModel = nil
        
        
        super.tearDown()
    }
    
    func testSearchFiltering() {
        
        let recording1 = Recording(
            id: UUID(), fileURL: URL(fileURLWithPath: "/tmp/Meeting.m4a"),
            createdAt: Date(),
            duration: 20
        )
        
        let recording2 = Recording(
            id: UUID(), fileURL: URL(fileURLWithPath: "/tmp/Interview.m4a"),
            createdAt: Date(),
            duration: 15
        )
        
        viewModel.recordings = [
            recording1,
            recording2
        ]
        
        viewModel.searchText = "Meeting"
        
        XCTAssertEqual(
            viewModel.filteredRecordings.count,
            1
        )
    }
    
    func testDeleteRecording() {
        
        let recording = Recording(
            id: UUID(), fileURL: URL(fileURLWithPath: "/tmp/Test.m4a"),
            createdAt: Date(),
            duration: 10
        )
        
        viewModel.recordings = [recording]
        
        viewModel.deleteRecording(recording)
        
        XCTAssertTrue(
            viewModel.recordings.isEmpty
        )
    }
    
    func testPrepareRename() {
        
        let recording = Recording(
            id: UUID(), fileURL: URL(fileURLWithPath: "/tmp/Test.m4a"),
            createdAt: Date(),
            duration: 10
        )
        
        viewModel.prepareRename(
            for: recording
        )
        
        XCTAssertEqual(
            viewModel.renameText,
            recording.fileName
        )
        
        XCTAssertTrue(
            viewModel.showRenameAlert
        )
    }
    
    func testRecordingTimerInitialValue() {
        
        XCTAssertEqual(
            viewModel.recordingDuration,
            0
        )
    }
}

