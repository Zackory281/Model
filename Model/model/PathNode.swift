//
//  PathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class PathNode {

	private var _next:PathNode?
	private let _value:UInt16
	private var _dir:Direction?
	private weak var _meta:Any?
	private var _occupacity:Occupacity
	private weak var _shapeNode:ShapeNode?
	private let _x, _y:Int16

	init(_ x:Int16, _ y:Int16, next:PathNode? = nil, value:UInt16 = -1, dir:Direction?, occupacity:Occupacity, shapeNode:ShapeNode? = nil, meta:Any? = nil) {
		_x = x;
		_y = y;
		_next = next
		_value = value
		_dir = dir
		_occupacity = occupacity
		_shapeNode = shapeNode
		_meta = meta
	}
	
//	convenience init(value:UInt16, occupied:Bool = false, shapeNode:ShapeNode?=nil, pos:[Int16], nodes:[PathNode?]=[]) {
//		self.ini
//	}
	
	func hasNext() -> Bool{
		if let _ = _next {
			return true;
		}
		return false
	}
	
	func next() -> PathNode {
		return _next!
	}
	
	func isFree() -> Bool {
		if let _ = _shapeNode {
			return false
		}
		return true
	}
	
	func liftShapeNode() {
		_shapeNode = nil
	}
	
	func setShapeNode(node:ShapeNode) {
		_shapeNode = node
	}
	
	func getPoint() -> [Int] {
		return [Int(_meta[0]), Int(_meta[1])]
	}
	
	func getNodes() -> [PathNode?] {
		return _nodes
	}
	
	private func getNextNode() -> PathNode? {
		for node in _nodes {
			if let n = node, n.isFree() {
				return n
			}
		}
		return nil
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
}
