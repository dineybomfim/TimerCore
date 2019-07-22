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

typealias StatusCount = [SmartTimer.Event : Int]

extension Dictionary where Key == SmartTimer.Event, Value == Int {
	
	static var zero: StatusCount {
		return [.start : 0, .pause : 0, .resume : 0, .end : 0]
	}
	
	mutating func addOne(to status: Key) {
		self[status] = (self[status] ?? 0) + 1
	}
}

// MARK: - Type -

class TimerTests : XCTestCase {

// MARK: - Properties

// MARK: - Constructors

// MARK: - Protected Methods

// MARK: - Exposed Methods

  func test_SmartTimer_WithUpdatingHandler_ShouldBegingWithStartStatus() {
	let expect = expectation(description: "\(#function)")
	var sequence = [SmartTimer.Event]()
	
	_ = SmartTimer(total: 1.0) { (_, status) in
		sequence.append(status)
		
		if status == .end {
			XCTAssertEqual(sequence.first!, .start)
			XCTAssertEqual(sequence.dropFirst().first!, .update)
			XCTAssertEqual(sequence.last!, .end)
			expect.fulfill()
		}
	}
	
	waitForExpectations(timeout: 1.5, handler: nil)
  }
	
	func test_SmartTimer_WithUpdatingHandler_ShouldHaveOneStartOneEndSeveralUpdates() {
		let expect = expectation(description: "\(#function)")
		var track = StatusCount.zero
		
		_ = SmartTimer(total: 1.0) { (_, status) in
			track.addOne(to: status)
			
			if status == .end {
				XCTAssertEqual(track[.start], 1)
				XCTAssertGreaterThan(track[.update]!, 1, "Clock tick should be faster than 1s")
				XCTAssertEqual(track[.end], 1)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 1.5, handler: nil)
	}
	
	func test_SmartTimer_WithPauseAndResume_ShouldHaveOneStartOneEndSeveralUpdates() {
		let expect = expectation(description: "\(#function)")
		var track = StatusCount.zero
		
		let timer = SmartTimer(total: 1.0) { (_, status) in
			track.addOne(to: status)
			
			if status == .end {
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
	
	func test_SmartTimer_WithRedundantPauseAndResume_ShouldHaveNoEffectOverTheNormalBehavior() {
		let expect = expectation(description: "\(#function)")
		var track = StatusCount.zero
		
		let timer = SmartTimer(total: 1.0) { (_, status) in
			track.addOne(to: status)
			
			if status == .end {
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
		
		waitForExpectations(timeout: 1.5, handler: nil)
	}
	
	func test_SmartTimer_With3SecondsCount_ShouldWaitFor3Seconds() {
		let expect = expectation(description: "\(#function)")
		let time = CACurrentMediaTime()
			
		_ = SmartTimer(total: 3.0) { (_, status) in
			
			if status == .end {
				XCTAssertGreaterThan(CACurrentMediaTime() - time, 3.0)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 4.0, handler: nil)
	}

// MARK: - Overridden Methods

}
