//
//  ShapeNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit

class ShapeNode : NodeAbstract {
	
	override var description: String { return "ShapeNode at \(_point)" }
	weak var _pathNode:PathNodeAbstract? {
		didSet {
			if let p = _pathNode?._point {
				_point = p
			}
		}
	}
	private var _headShapeNode:HeadNode?
	private var _orientations: [Direction]
	var _changedState: Bool = false
	override var _color: NSColor? { get { return _ccolor } }
	var _ccolor: NSColor?
	var _direction: Direction?
	var _state: ShapeNodeState = .Chilling {
		didSet{
			if _state != oldValue {
				_lastStateTick = _tick
				_changedState = true
			}
		}
	}
	var _tick: TickU = 0
	var _lastStateTick: TickU = 0
	
	init(_ point: Point, direction: Direction, pathNode:PathNodeAbstract?, headNode:HeadNode?) {
		_point = point
		_orientations = [direction]
		_pathNode = pathNode
		_headShapeNode = headNode
		_ccolor = _colorsAvaliable.pop() ?? .white
		super.init()
		_direction = direction
	}
	
	func tick(_ tick: TickU) {
		_tick = tick
		switch _state {
		case .CanNowMoveWaiting:
			if _lastStateTick + CAN_MOVE_WAIT_TIME < tick {
				_state = .CanNowMove
				_lastStateTick = tick
			}
		case .Moving:
			if _lastStateTick + MOVING_TIME < tick {
				_state = .Chilling
				_lastStateTick = tick
			}
		default:
			break
		}
	}
	override var _type: NodeType { get { return .Shape } }
	func getOrientations() -> [Direction] { return [_direction!] }
	func getDirection() -> Direction? { return _direction }
	func getType() -> NodeType { return .Shape}
	func getColorCode() -> NSColor? { return _color }
}

//let CHILL_TIME: TickU = 10
let CAN_MOVE_WAIT_TIME: TickU = 30
let MOVING_TIME: TickU = 60

enum ShapeNodeState {
	case Chilling
	case CanNowMoveWaiting
	case CanNowMove
	case Moving
}

let _colorsAvaliable = Stack<NSColor>([NSColor.systemBlue,
									   NSColor.systemRed,
									   NSColor.systemPink,
									   NSColor.systemBrown,
									   NSColor.systemGreen,
									   NSColor.systemOrange,
									   NSColor.systemYellow])

class HeadNode {
	
	var _headNode:ShapeNode
	
	init(head: ShapeNode) {
		_headNode = head
	}
	func getHeadShapeNode() -> ShapeNode {
		return _headNode
	}
}
