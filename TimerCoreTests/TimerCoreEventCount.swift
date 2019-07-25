/*
 *	TimerCoreEventCount.swift
 *	TimerCore
 *
 *	Created by Diney Bomfim on 7/23/19.
 *	Copyright 2019 db-in. All rights reserved.
 */

@testable import TimerCore

// MARK: - Definitions -

typealias TimerCoreEventCount = [TimerCore.Event : Int]

// MARK: - Extension -

extension Dictionary where Key == TimerCore.Event, Value == Int {
	
	static var zero: TimerCoreEventCount {
		return [.start : 0, .pause : 0, .resume : 0, .end : 0]
	}
	
	mutating func addOne(to status: Key) {
		self[status] = (self[status] ?? 0) + 1
	}
}
