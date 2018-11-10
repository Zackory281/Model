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
	
	private var _pathNodeController: PathNodeController
	private var _shapeNodeController: ShapeNodeController
	private var _queue: GUIQueue
	
	func addNodeAt(_ point: Point, _ type: NodeType) {
		if _pathNodeController.getPathNodeAt(point) == nil {
			guard let _ = _pathNodeController.addPathNode(at: point) else { return }
		} else if let pathNode = _pathNodeController.getPathNodeAt(point), pathNode._shapeNode == nil {
			let shapeNode = ShapeNode.init(point, direction: pathNode._directions[safe: 0] ?? .UP, pathNode: pathNode, headNode: nil)
			pathNode._shapeNode = shapeNode
			pathNode._taken = true
			_shapeNodeController.addShapeNode(shapeNode)
		}
	}
	
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType) { addNodeAt((x, y), type) }
	
	func addNodeToadvance(_ node: ShapeNode) {
		_shapeNodeController._toStartAdvanceNodes.insert(node)
	}
	
	func addPathNodesFromHead(_ head: PathNodeAbstract) {
		let _ = _pathNodeController.addHeadNode(head)
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
		_nodeActionDelegate?.uiAddQueue(_queue)
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
			_queue._nodesToUpdate.append(contentsOf: ns)
			//_nodeActionDelegate?.uiUpdateNodes(nodes: ns)
		}
		_shapeNodeController._toStartAdvanceNodes.removeAll()
	}
	
	func finishAdvanceNodes() {
		for node in _shapeNodeController._toFinishAdvanceNodes {
			let oldPath = (node._pathNode! as! SerialPathNode)._prev!
			if oldPath._shapeNode == node {
				oldPath._taken = false
			}
			node._state = .Chilling
			//			node.setPathNode(newPathNode)
			//			_shapeNodeController.move(node)
			//			newPathNode._shapeNode = node
			//			node._state = .Moving
			_queue._nodesToUpdate.append(contentsOf: [node, oldPath])
		}
		_shapeNodeController._toFinishAdvanceNodes.removeAll()
	}
	
	override init() {
		_queue = GUIQueue()
		_pathNodeController = PathNodeController(width: 100, height: 100, queue: _queue)
		_shapeNodeController = ShapeNodeController(queue: _queue)
		super.init()
	}
}

protocol NodeControlDelegate: NSObjectProtocol {
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType)
	func addNodeAt(_ p: Point, _ type: NodeType)
	func addNodeToadvance(_ node: ShapeNode)
}
