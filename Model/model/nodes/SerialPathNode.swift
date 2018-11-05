//
//  PathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class SerialPathNode : NSObject, PathNode {

	override var description: String { return "PathNode at \(_x), \(_y)" }
	private let _x, _y:IntC
	private var _next, _prev:SerialPathNode?
	private let _value:UInt16
	private var _dir:Direction?
	private weak var _meta:AnyObject?
	private var _occupacity:Occupacity
	private weak var _shapeNode:ShapeNode?

	init(_ x:IntC, _ y:IntC, prev:SerialPathNode? = nil, next:SerialPathNode? = nil, value:UInt16 = 0, dir:Direction? = nil, occupacity:Occupacity = .FREE, shapeNode:ShapeNode? = nil, meta:AnyObject? = nil) {
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
	
	convenience init(_ x:IntC, _ y:IntC, prev:SerialPathNode?, next:SerialPathNode?, value:UInt16, dir:Direction?) {
		self.init(x, y, prev: prev, next: next, value: value, dir: dir, occupacity:.FREE, shapeNode:nil, meta:nil)
	}
	
	func setPrev(_ node:SerialPathNode) { _prev = node }
	
	func setNext(_ node:SerialPathNode) { _next = node }
	
	func hasPrev() -> Bool { if let _ = _prev { return true }; return false }
	
	func prev() -> SerialPathNode? { return _prev }
	
	func getNext(for shapeNode: ShapeNode) -> PathNode? {
		return _next
	}
	
	func hasNext(for shapeNode: ShapeNode) -> Bool { return _next != nil }
	
	func getDirection(for shapeNode: ShapeNode) -> Direction? { return _dir ?? getOrientations()[0] }
	
	func isFree() -> Bool { if let _ = _shapeNode { return false }; return true }
	
	func liftShapeNode(for node: ShapeNode) {
		if node == _shapeNode {
			_shapeNode = nil
		}
	}
	
	func setShapeNode(node:ShapeNode) { _shapeNode = node }
	
	func getX() -> IntC { return _x }
	
	func getY() -> IntC { return _y }
	
	func getPoint() -> [IntC] { return [_x, _y] }
	
	func getType() -> NodeType { return .Path}
	
	func getShapeNode() -> ShapeNode? { return _shapeNode }
	
	func getColorCode() -> NSColor {
		return _shapeNode?.getColorCode() ?? .white
	}
	
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
	
	func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation? {
		if _prev?.getDirection() == direction {
			if let shapeNode = _shapeNode {
				return PRE(CustomQuery.ShapeNowMove(shapeNode))
			}
			return RES(true, 3)
		}
		print("we have a problem")
		return nil
	}
}

protocol PathNode: Node {
	
	func getNext(for shapeNode: ShapeNode) -> PathNode?
	func hasNext(for shapeNode: ShapeNode) -> Bool
	func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation?
	func setShapeNode(node:ShapeNode)
	func getDirection(for shapeNode: ShapeNode) -> Direction?
	func liftShapeNode(for node: ShapeNode)
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
