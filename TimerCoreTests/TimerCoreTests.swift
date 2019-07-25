/*
 *	TimerTests.swift
 *	TimerCore
 *
 *	Created by Diney Bomfim on 7/22/19.
 *	Copyright 2019 db-in. All rights reserved.
 */

import XCTest
@testable import TimerCore

// MARK: - Definitions -

// MARK: - Type -

class TimerTests : XCTestCase {

// MARK: - Properties

// MARK: - Constructors

// MARK: - Protected Methods

// MARK: - Exposed Methods
	
	func test_TimerCore_WithUpdatingHandler_ShouldBegingWithStartStatus() {
		let expect = expectation(description: "\(#function)")
		var sequence = [TimerCore.Event]()
		
		_ = TimerCore(total: 1.0) { (_, event) in
			sequence.append(event)
			
			if event == .end {
				XCTAssertEqual(sequence.first!, .start)
				XCTAssertEqual(sequence.dropFirst().first!, .update)
				XCTAssertEqual(sequence.last!, .end)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 1.5, handler: nil)
	}
	
	func test_TimerCore_WithUpdatingHandler_ShouldHaveOneStartOneEndSeveralUpdates() {
		let expect = expectation(description: "\(#function)")
		var track = TimerCoreEventCount.zero
		
		_ = TimerCore(total: 1.0) { (_, event) in
			track.addOne(to: event)
			
			if event == .end {
				XCTAssertEqual(track[.start], 1)
				XCTAssertGreaterThan(track[.update]!, 1, "Clock tick should be faster than 1s")
				XCTAssertEqual(track[.end], 1)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 1.5, handler: nil)
	}
	
	func test_TimerCore_WithPauseAndResume_ShouldHaveOneStartOneEndSeveralUpdates() {
		let expect = expectation(description: "\(#function)")
		var track = TimerCoreEventCount.zero
		
		let timer = TimerCore(total: 1.0) { (_, event) in
			track.addOne(to: event)
			
			if event == .end {
				XCTAssertEqual(track[.start], 1)
				XCTAssertGreaterThan(track[.update]!, 1, "Clock tick should be faster than 1s")
				XCTAssertEqual(track[.pause], 1)
				XCTAssertEqual(track[.resume], 1)
				XCTAssertEqual(track[.end], 1)
				expect.fulfill()
			}
		}
		
		DispatchQueue.main.async {
			timer.state = .paused
			
			DispatchQueue.main.async {
				timer.state = .running
			}
		}
		
		waitForExpectations(timeout: 1.5, handler: nil)
	}
	
	func test_TimerCore_WithRedundantPauseAndResume_ShouldHaveNoEffectOverTheNormalBehavior() {
		let expect = expectation(description: "\(#function)")
		var track = TimerCoreEventCount.zero
		
		let timer = TimerCore(total: 1.0) { (_, event) in
			track.addOne(to: event)
			
			if event == .end {
				XCTAssertEqual(track[.pause], 2)
				XCTAssertEqual(track[.resume], 2)
				expect.fulfill()
			}
		}
		
		timer.state = .paused
		timer.state = .paused
		timer.state = .paused
		timer.state = .running
		timer.state = .running
		timer.state = .paused
		timer.state = .running
		timer.state = .finished
		timer.state = .finished
		
		waitForExpectations(timeout: 1.5, handler: nil)
	}
	
	func test_TimerCore_With3SecondsCount_ShouldWaitFor3Seconds() {
		let expect = expectation(description: "\(#function)")
		let time = CACurrentMediaTime()
		
		_ = TimerCore(total: 3.0) { (_, event) in
			
			if event == .end {
				XCTAssertGreaterThan(CACurrentMediaTime() - time, 3.0)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 4.0, handler: nil)
	}

// MARK: - Overridden Methods

}
