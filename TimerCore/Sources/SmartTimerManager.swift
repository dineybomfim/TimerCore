/*
 *	SmartTimerManager.swift
 *	TimerCore
 *
 *	Created by Diney Bomfim on 7/23/19.
 *	Copyright 2019 db-in. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

// MARK: - Type -

public class SmartTimerManager {

// MARK: - Properties
	
	private var timers: [String : SmartTimer] = [:]
	
	public static var shared = SmartTimerManager()

// MARK: - Constructors

// MARK: - Protected Methods
	
// MARK: - Exposed Methods
	
	public func timer(with identifier: String) -> SmartTimer? {
		return timers[identifier]
	}
	
	public func triggerTimer(with identifier: String,
							 totalTime: TimeInterval,
							 handler: @escaping SmartTimer.UpdateHandler) {
		timers[identifier]?.state = .finished
		
		let newTimer = SmartTimer(total: totalTime) { timer, state in
			handler(timer, state)
			
			if state == .end {
				self.timers[identifier] = nil
			}
		}
		
		timers[identifier] = newTimer
	}

// MARK: - Overridden Methods

}
