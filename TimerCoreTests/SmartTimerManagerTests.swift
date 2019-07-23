/*
 *	SmartTimerManagerTests.swift
 *	TimerCore
 *
 *	Created by Diney Bomfim on 7/23/19.
 *	Copyright 2019 db-in. All rights reserved.
 */

import XCTest
@testable import TimerCore

// MARK: - Definitions -

extension ClosedRange where Bound == Double {
	
	func randomElements(_ n: Int) -> [Bound] {
		return (0..<n).map { _ in .random(in: self) }
	}
}

// MARK: - Type -

class SmartTimerManagerTests : XCTestCase {

// MARK: - Properties

// MARK: - Constructors

// MARK: - Protected Methods

// MARK: - Exposed Methods
	
	func test_SmartTimerManager_WithTriggerAction_ShouldInitializeATimer() {
		let expect = expectation(description: "\(#function)")
		var track = SmartTimerEventCount.zero
		
		SmartTimerManager.shared.triggerTimer(with: "com.test", totalTime: 0.5) { (timer, event) in
			track.addOne(to: event)
			
			if event == .end {
				XCTAssertEqual(track[.start], 1)
				XCTAssertEqual(track[.end], 1)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 1.0, handler: nil)
	}
	
	func test_SmartTimerManager_WithTriggerActionAndTimerFunction_ShouldRetrieveTheSameTimer() {
		let expect = expectation(description: "\(#function)")
		let shared = SmartTimerManager.shared
		
		shared.triggerTimer(with: "com.test", totalTime: 0.5) { (timer, event) in
			if event == .end {
				XCTAssertEqual(shared.timer(with: "com.test"), timer)
				expect.fulfill()
			}
		}
		
		waitForExpectations(timeout: 1.0, handler: nil)
	}
	
	func test_SmartTimerManager_WithTriggerActionFinishes_ShouldAutomaticallyStripTimer() {
		let expect = expectation(description: "\(#function)")
		let shared = SmartTimerManager.shared
		
		shared.triggerTimer(with: "com.test", totalTime: 0.0) { (timer, event) in
			if event == .end {
				XCTAssertEqual(shared.timer(with: "com.test"), timer)
				
				DispatchQueue.main.async {
					XCTAssertEqual(shared.timer(with: "com.test"), nil)
					expect.fulfill()
				}
			}
		}
		
		waitForExpectations(timeout: 1.0, handler: nil)
	}
	
	func test_SmartTimerManager_WithMultipleTriggers_ShouldAllRunInParallel() {
		let expect = expectation(description: "\(#function)")
		let maxTime = 5.0
		let timmings = (1.0...maxTime).randomElements(10)
		let time = CACurrentMediaTime()
		let group = DispatchGroup()
		
		timmings.forEach { value in
			group.enter()
			SmartTimerManager.shared.triggerTimer(with: "\(value)", totalTime: value) { (_, event) in
				if event == .end {
					XCTAssertGreaterThan(CACurrentMediaTime() - time, value)
					group.leave()
				}
			}
		}
		
		group.notify(queue: DispatchQueue.main) {
			expect.fulfill()
		}
		
		waitForExpectations(timeout: maxTime + 1.0, handler: nil)
	}

// MARK: - Overridden Methods

}
