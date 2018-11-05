//
//  ShapeNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ShapeNode : NSObject, Node {
	
	override var description: String { return "ShapeNode at \(_x), \(_y)" }
	private weak var _pathNode:PathNode?
	private var _headShapeNode:HeadNode?
	private var _x, _y: IntC
	private var _orientations: [Direction]
	
	init(_ x: IntC, _ y: IntC, direction: Direction, pathNode:PathNode?, headNode:HeadNode?) {
		(_x, _y) = (x, y)
		_orientations = [direction]
		_pathNode = pathNode
		_headShapeNode = headNode
	}
	
	func setPathNode(pathNode:PathNode) {
		_pathNode = pathNode
	}
	
	func advance() -> Bool {
		guard let pathNode = _pathNode else { return false}
		if pathNode.hasNext() {
			let next = pathNode.next()!
			(_x, _y) = (next.getPoint()[0], next.getPoint()[1])
			_pathNode = pathNode
		}
		return false
	}
	
	func getPathNode() -> PathNode? {
		return _pathNode
	}
	
	func getPoint() -> [IntC] {
		return [_x, _y]
	}
	
	func getOrientations() -> [Direction] {
		return _orientations
	}
	
	func getDirection() -> Direction? {
		return _pathNode?.getDirection()
	}
	
	func getType() -> NodeType { return .Shape}
}

class HeadNode {
	
	var _headNode:ShapeNode
	
	init(head: ShapeNode) {
		_headNode = head
	}
	func getHeadShapeNode() -> ShapeNode {
		return _headNode
	}
}
