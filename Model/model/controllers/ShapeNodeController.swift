//
//  NodeManager.swift
//  Model
//
//  Created by Zackory Cramer on 10/25/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ShapeNodeController {
	
	var _shapeNodes :Set<ShapeNode>
	var _idleShapeNodes: Set<ShapeNode>
	private var _shapeHeadNodes :Set<ShapeNode>
	private var _shapeNodeMap: NodeMap
	
	var _toStartAdvanceNodes = Set<ShapeNode>()
	var _toFinishAdvanceNodes = Set<ShapeNode>()
	private var _tick: TickU = 0
	private weak var _queue: GUIQueue?
	
	init(nodeMap: NodeMap, queue: GUIQueue) {
		_queue = queue
		_shapeNodes = Set<ShapeNode>()
		_idleShapeNodes = Set<ShapeNode>()
		_shapeHeadNodes = Set<ShapeNode>()
		_shapeNodeMap = nodeMap
		//_shapeNodeTree = NodeTree<ShapeNode>(width: 100, height: 100)
	}
	
	func addShapeNode(_ node: ShapeNode) {
		_shapeNodes.insert(node)
		_idleShapeNodes.insert(node)
		_shapeNodeMap.add(node: node)
		_queue?.add(node: node)
	}
	
	func addHeadNode(head :ShapeNode) {
		_shapeHeadNodes.insert(head)
		_shapeNodes.insert(head)
		_idleShapeNodes.insert(head)
		_shapeNodeMap.add(node: head)
		_queue?.add(node: head)
	}
	
	func remove(_ node: ShapeNode) {
		_shapeNodeMap.remove(node: node)
		_shapeHeadNodes.remove(node)
		_shapeNodes.remove(node)
		_toStartAdvanceNodes.remove(node)
		_toFinishAdvanceNodes.remove(node)
		_idleShapeNodes.remove(node)
		_queue?.remove(node)
	}
	
	func move(_ node: ShapeNode) {
		let _ = _shapeNodeMap.move(node: node)
		_queue?.update(node: node)
	}
	
	func hasShapeNodeAt(_ point: Point) -> Bool {
		return !_shapeNodeMap.contains(of: ShapeNode.self, at: point)
	}
	
	func hasShapeNodeAt(_ x: IntC, y: IntC) -> Bool {
		return hasShapeNodeAt((x, y))
	}
	
	func getShapeNode(at point:Point) -> ShapeNode? {
		return _shapeNodeMap.getNodes(of: ShapeNode.self, at: point).first
	}
	
	func tick(_ tick: TickU) {
		_tick = tick
	}
	
}
