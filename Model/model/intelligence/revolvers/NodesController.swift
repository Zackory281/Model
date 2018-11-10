//
//  NodesManager.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesController: NSObject, NodeControlDelegate, QueryNodeDelegate{
	
	weak var _nodeActionDelegate: OutputDelegate?
	
	private var _pathNodeController :PathNodeController = PathNodeController(width: 100, height: 100)
	private var _shapeNodeController :ShapeNodeController = ShapeNodeController()
	
	func addNodeAt(_ point: Point, _ type: NodeType) {
		if _pathNodeController.getPathNodeAt(point) == nil {
			guard let _ = _pathNodeController.addPathNode(at: point) else { return }
//			_pathNodeController._nodesToAdd.removeAll()
//			_pathNodeController._nodesToUpdate.removeAll()
		} else if let pathNode = _pathNodeController.getPathNodeAt(point), pathNode._shapeNode == nil {
			print("adding a shape")
			let shapeNode = ShapeNode.init(point, direction: pathNode._directions[safe: 0] ?? .UP, pathNode: pathNode, headNode: nil)
			pathNode._shapeNode = shapeNode
			pathNode._taken = true
			_shapeNodeController.addShapeNode(shapeNode)
//			addNodes.append(shapeNode)
//			updateNodes.append(pathNode)
		}
	}
	
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType) { addNodeAt((x, y), type) }
	
	func addNodeToadvance(_ node: ShapeNode) {
		_shapeNodeController._toStartAdvanceNodes.insert(node)
	}
	
	func addPathNodesFromHead(_ head: PathNodeAbstract) {
		let ups = _pathNodeController.addHeadNode(head)
		guard !ups.isEmpty else { return }
		addToAddQueue([ups as! Node])
	}
	
	func getQueries() -> Set<CustomQuery> {
		var qs = Set<CustomQuery>()
		for n in _shapeNodeController._shapeNodes {
			if n._state == .CanNowMove {
				qs.insert(.ShapeNowMove(n))
			}
		}
		return qs
	}
	
	func tick(_ tick: TickU) {
		startAdvanceNodes()
		finishAdvanceNodes()
		_shapeNodeController.tick(tick)
	}
	
	func startAdvanceNodes() {
		for node in _shapeNodeController._toStartAdvanceNodes {
			let newPath = node._pathNode!.getNext(node._direction)!
			var ns: [NodeAbstract] = [newPath, node]
			if let oldPath = node._pathNode, oldPath._shapeNode == node {
				ns.append(oldPath)
				oldPath._shapeNode = nil
				oldPath._taken = false
			}
			newPath._shapeNode = node
			newPath._taken = true
			node._state = .Moving
			node._pathNode = newPath
			//let newPathNode = node.getPathNode()!.getNext(nil)!
//			node.setPathNode(newPathNode)
//			_shapeNodeController.move(node)
//			newPathNode._shapeNode = node
//			node._state = .Moving
			addToUpdateQueue(ns)
			//_nodeActionDelegate?.uiUpdateNodes(nodes: ns)
		}
		_shapeNodeController._toStartAdvanceNodes.removeAll()
	}
	
	func finishAdvanceNodes() {
		for node in _shapeNodeController._toFinishAdvanceNodes {
			let oldPath = (node._pathNode! as! SerialPathNode)._prev!
			oldPath._taken = false
			node._state = .Chilling
			//			node.setPathNode(newPathNode)
			//			_shapeNodeController.move(node)
			//			newPathNode._shapeNode = node
			//			node._state = .Moving
			addToUpdateQueue([node, oldPath])
		}
		_shapeNodeController._toFinishAdvanceNodes.removeAll()
	}
	
	func addToAddQueue(_ array: [NodeAbstract]) {
		for r in array {
			switch (r) {
			case let r as ShapeNode:
				_shapeNodeController._nodesToAdd.insert(r)
			case let r as PathNodeAbstract:
				_pathNodeController._nodesToAdd.insert(r)
			default:
				break
			}
		}
	}
	func addToUpdateQueue(_ array: [NodeAbstract]) {
		for r in array {
			switch (r) {
			case let r as ShapeNode:
				_shapeNodeController._nodesToUpdate.insert(r)
			case let r as PathNodeAbstract:
				_pathNodeController._nodesToUpdate.insert(r)
			default:
				break
			}
		}
	}
}

protocol NodeControlDelegate: NSObjectProtocol {
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType)
	func addNodeAt(_ p: Point, _ type: NodeType)
	func addNodeToadvance(_ node: ShapeNode)
}
