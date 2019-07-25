/*
 *	TimerCoreFactory.swift
 *	TimerCore
 *
 *	Created by Diney Bomfim on 7/23/19.
 *	Copyright 2019 db-in. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

// MARK: - Type -

public class TimerCoreFactory {

// MARK: - Properties
	
	private var timers: [String : TimerCore] = [:]
	
	public static var shared = TimerCoreFactory()

// MARK: - Constructors

// MARK: - Protected Methods
	
// MARK: - Exposed Methods
	
	public func timer(with identifier: String) -> TimerCore? {
		return timers[identifier]
	}
	
	public func triggerTimer(with identifier: String,
							 totalTime: TimeInterval,
							 handler: @escaping TimerCore.UpdateHandler) {
		timers[identifier]?.state = .finished
		
		let newTimer = TimerCore(total: totalTime) { timer, state in
			handler(timer, state)
			
			if state == .end {
				self.timers[identifier] = nil
			}
		}
		
		timers[identifier] = newTimer
	}

// MARK: - Overridden Methods

}
