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
				_lastState = oldValue
			}
		}
	}
	var _lastState: ShapeNodeState = .Chilling
	var _tick: TickU = 0
	var _lastStateTick: TickU = 0
	
	init(_ point: Point, direction: Direction, pathNode:PathNodeAbstract?, headNode:HeadNode?) {
		_orientations = [direction]
		super.init()
		self._point = point
		_pathNode = pathNode
		_headShapeNode = headNode
		_ccolor = _colorsAvaliable.pop() ?? .white
		_direction = direction
	}
	
	func tick(_ tick: TickU) {
		_tick = tick
	}
	override var _type: NodeType { get { return .Shape } }
	func getOrientations() -> [Direction] { return [_direction!] }
	func getDirection() -> Direction? { return _direction }
	func getType() -> NodeType { return .Shape}
	func getColorCode() -> NSColor? { return _color }
}

let CAN_MOVE_WAIT_TIME: TickU = 2
let MOVING_TIME: TickU = 25
let ATTACK_TIME: TickU = 60

enum ShapeNodeState {
	case Chilling
	case CanNowMoveWaiting
	case CanNowMove
	case Moving
	case Attacking
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
