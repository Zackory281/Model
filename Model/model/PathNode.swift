//
//  PathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class PathNode : Node {

	private var _nodes:[PathNode?]
	private let _value:UInt16
	private lazy var _next:PathNode? = getNextNode();
	private var _occupied:Bool
	private let _meta:[Int16]
	private var _shapeNode:ShapeNode?

	init(value:UInt16, occupied:Bool = false, pos:[Int16], up:PathNode?=nil, right:PathNode?=nil, down:PathNode?=nil, left:PathNode?=nil) {
		_nodes = [up, right, down, left]
		_value = value
		_occupied = occupied
		_meta = pos
	}
	
	convenience init(value:UInt16, occupied:Bool = false, shapeNode:ShapeNode?=nil, pos:[Int16], nodes:[PathNode?]=[]) {
		self.ini
	}
	
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
