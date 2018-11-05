//
//  ShapeNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit

class ShapeNode : NSObject, Node {
	
	override var description: String { return "ShapeNode at \(_x), \(_y)" }
	private weak var _pathNode:PathNode?
	private var _headShapeNode:HeadNode?
	private var _x, _y: IntC
	private var _orientations: [Direction]
	private var _color: NSColor
	
	init(_ x: IntC, _ y: IntC, direction: Direction, pathNode:PathNode?, headNode:HeadNode?) {
		(_x, _y) = (x, y)
		_orientations = [direction]
		_pathNode = pathNode
		_headShapeNode = headNode
		_color = _colorsAvaliable.pop() ?? .white
	}
	
	func setPathNode(pathNode:PathNode) {
		_pathNode = pathNode
	}
	
	private func advance() -> Bool {
		guard let pathNode = _pathNode else { return false}
		if pathNode.hasNext() {
			let next = pathNode.next()!
			(_x, _y) = (next.getPoint()[0], next.getPoint()[1])
			_pathNode = pathNode
		}
		return false
	}
	
	func setPathNode(_ node: PathNode) {
		_pathNode = node
		(_x, _y) = (node.getPoint()[0], node.getPoint()[1])
	}
	
	func getPathNode() -> PathNode? {
		return _pathNode
	}
	
	func getPoint() -> [IntC] { return [_x, _y] }
	
	func getX() -> IntC { return _x }
	
	func getY() -> IntC { return _y }
	
	func getOrientations() -> [Direction] {
		return [getDirection()!]
	}
	
	func getDirection() -> Direction? {
		return _pathNode?.getDirection()
	}
	
	func getType() -> NodeType { return .Shape}
	
	func getColorCode() -> NSColor {
		return _color
	}
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
