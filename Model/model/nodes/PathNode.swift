//
//  PathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class PathNode : NSObject, Node {

	private let _x, _y:Int16
	private var _next, _prev:PathNode?
	private let _value:UInt16
	private var _dir:Direction?
	private weak var _meta:AnyObject?
	private var _occupacity:Occupacity
	private weak var _shapeNode:ShapeNode?

	init(_ x:Int16, _ y:Int16, prev:PathNode? = nil, next:PathNode? = nil, value:UInt16 = 0, dir:Direction? = nil, occupacity:Occupacity = .FREE, shapeNode:ShapeNode? = nil, meta:AnyObject? = nil) {
		_x = x;
		_y = y;
		_prev = prev
		_next = next
		_value = value
		_dir = dir
		_occupacity = occupacity
		_shapeNode = shapeNode
		_meta = meta
	}
	
	convenience init(_ x:Int16, _ y:Int16, prev:PathNode?, next:PathNode?, value:UInt16, dir:Direction?) {
		self.init(x, y, prev: prev, next: next, value: value, dir: dir, occupacity:.FREE, shapeNode:nil, meta:nil)
	}
	
	func getPrevDirection() -> Direction? { return _dir }
	
	func setPrev(_ node:PathNode) { _prev = node }
	
	func setNext(_ node:PathNode) { _next = node }
	
	func hasPrev() -> Bool { if let _ = _prev { return true }; return false }
	
	func hasNext() -> Bool{ if let _ = _next { return true }; return false }
	
	func next() -> PathNode? { return _next }
	
	func prev() -> PathNode? { return _prev }
	
	func isFree() -> Bool { if let _ = _shapeNode { return false }; return true }
	
	func liftShapeNode() { _shapeNode = nil	}
	
	func setShapeNode(node:ShapeNode) { _shapeNode = node }
	
	func getPoint() -> [Int16] { return [_x, _y] }
	
	func getType() -> NodeType { return .Path}
	
	func getOrientations() -> [Direction] {
		var dir:[Direction] = []
		if _dir != nil {
			dir.append(_dir!)
		}
		if let prev = _next,let d = prev._dir{
			dir.append(d.opposite())
		}
		return dir
	}
}

enum Occupacity {
	case OCCUPIED
	case FREE
	case HALF_OCCUPIED
}

enum Direction {
	case UP
	case RIGHT
	case DOWN
	case LEFT
	
	func opposite() -> Direction {
		switch (self) {
		case Direction.UP:
			return Direction.DOWN
		case .RIGHT:
			return .LEFT
		case .DOWN:
			return .UP
		case .LEFT:
			return .RIGHT
		}
	}
}
