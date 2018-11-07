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
	private weak var _pathNode:PathNodeAbstract?
	private var _headShapeNode:HeadNode?
	private var _x, _y: IntC
	private var _orientations: [Direction]
	private var _color: NSColor
	private var _direction: Direction?
	
	init(_ x: IntC, _ y: IntC, direction: Direction, pathNode:PathNodeAbstract?, headNode:HeadNode?) {
		(_x, _y) = (x, y)
		_orientations = [direction]
		_pathNode = pathNode
		_headShapeNode = headNode
		_color = _colorsAvaliable.pop() ?? .white
	}
	
	func setPathNode(pathNode:PathNodeAbstract) {
		_pathNode = pathNode
	}
	
	func setPathNode(_ node: PathNodeAbstract) {
		_pathNode = node
		(_x, _y) = node.getPoint()
	}
	
	func getPathNode() -> PathNodeAbstract? {
		return _pathNode
	}
	
	func getPoint() -> Point { return (_x, _y) }
	func getX() -> IntC { return _x }
	func getY() -> IntC { return _y }
	func getOrientations() -> [Direction] { return [getDirection()!] }
	func getDirection() -> Direction? { return _direction }
	func getType() -> NodeType { return .Shape}
	func getColorCode() -> NSColor { return _color }
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
