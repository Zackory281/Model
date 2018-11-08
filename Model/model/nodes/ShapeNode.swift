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
	
	override var description: String { return "ShapeNode at \(_point)" }
	private weak var _pathNode:PathNodeAbstract?
	private var _headShapeNode:HeadNode?
	private var _orientations: [Direction]
	var _color: NSColor?
	private var _direction: Direction?
	
	init(_ point: Point, direction: Direction, pathNode:PathNodeAbstract?, headNode:HeadNode?) {
		_point = point
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
		_point = node._point
	}
	
	func getPathNode() -> PathNodeAbstract? {
		return _pathNode
	}
	
	var _point: Point
	var _type: NodeType { get { return .Shape } }
	func getOrientations() -> [Direction] { return [getDirection()!] }
	func getDirection() -> Direction? { return _direction }
	func getType() -> NodeType { return .Shape}
	func getColorCode() -> NSColor? { return _color }
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
