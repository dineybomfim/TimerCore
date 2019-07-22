/*
 *	SmartTimer.swift
 *	TimerCore
 *
 *	Created by Diney Bomfim on 7/22/19.
 *	Copyright 2019 db-in. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

extension TimeInterval {
	
	static var clockTick: TimeInterval {
		return 1.0 / 60.0
	}
}

// MARK: - Type -

open class SmartTimer : NSObject {
	
	public enum State {
		case running
		case paused
		case finished
	}
	
	public enum Event : Int {
		case start
		case update
		case pause
		case resume
		case end
	}
	
	public typealias UpdateHandler = (TimeInterval, Event) -> Void
	
// MARK: - Properties
	
	private var timer: Timer?
	private let handler: UpdateHandler
	
	public private(set) var currentTime: TimeInterval = 0.0
	public var totalTime: TimeInterval
	
	public var state: State {
		didSet {
			switch (oldValue, state) {
			case (.paused, .running):
				runTimer(.resume)
			case (.running, .paused):
				stopTimer(.pause)
			case (_, .finished):
				stopTimer(.end)
			default:
				break
			}
		}
	}
	
	public init(total: TimeInterval, handler update: @escaping UpdateHandler) {
		totalTime = total
		state = .running
		handler = update
		super.init()
		runTimer(.start)
	}
	
// MARK: - Constructors

// MARK: - Protected Methods
	
	private func runTimer(_ event: SmartTimer.Event) {
		
		let newTimer = Timer(timeInterval: .clockTick,
							 target: self,
							 selector: #selector(updateTimer),
							 userInfo: nil,
							 repeats: true)
		RunLoop.current.add(newTimer, forMode: .common)
		
		timer?.invalidate()
		timer = newTimer
		handler(currentTime, event)
	}
	
	private func stopTimer(_ event: SmartTimer.Event) {
		timer?.invalidate()
		timer = nil
		handler(currentTime, event)
	}
	
	@objc private func updateTimer() {
		currentTime += .clockTick
		handler(currentTime, .update)
		
		if currentTime >= totalTime {
			state = .finished
		}
	}
	
// MARK: - Exposed Methods

// MARK: - Overridden Methods
	
}
