//: Playground - noun: a place where people can play

import Foundation
import TimerCore
import PlaygroundSupport

var str = "Hello, TimerCore"

// MARK: - Definitions -

extension TimeInterval {
	
	static var clockTick: TimeInterval {
		return 1.0 / 60.0
	}
}

// MARK: - Type -

open class TimerCore : NSObject {
	
	public enum State {
		case running
		case paused
		case finished
	}
	
	public enum Status {
		case start
		case update
		case pause
		case resume
		case end
	}
	
	public typealias UpdateHandler = (TimeInterval, Status) -> Void
	
	// MARK: - Properties
	
	private var timer: Timer?
	private let handler: UpdateHandler
	
	public private(set) var currentTime: TimeInterval = 0.0
	public var totalTime: TimeInterval
	
	public var state: State {
		didSet {
			switch (oldValue, state) {
			case (.paused, .running):
				runTimer()
			default:
				stopTimer()
			}
		}
	}
	
	public init(total: TimeInterval, handler update: @escaping UpdateHandler) {
		totalTime = total
		state = .running
		handler = update
		super.init()
		self.runTimer()
	}
	
	// MARK: - Constructors
	
	// MARK: - Protected Methods
	
	private func runTimer() {
		stopTimer()
		
		let newTimer = Timer(timeInterval: .clockTick,
							 target: self,
							 selector: #selector(updateTimer),
							 userInfo: nil,
							 repeats: true)
		RunLoop.current.add(newTimer, forMode: .common)
		//		RunLoop.current.run()
		//		RunLoop.current.run(mode: .commonModes, before: Date.distantPast)
		
		timer = newTimer
		handler(currentTime, currentTime == 0.0 ? .start : .resume)
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
		
		if currentTime > 0.0 {
			handler(currentTime, currentTime >= totalTime ? .end : .pause)
		}
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

let timer = TimerCore(total: 10.0) { (current, status) in
	switch status {
	case .start, .end:
		print("\(current) :: \(status)")
	default:
		break
	}
}

PlaygroundPage.current.needsIndefiniteExecution = true
