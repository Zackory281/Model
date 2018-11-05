//
//  Map.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class PathNodeController {
	
	private var _tailNodes:[PathNode]
	private var _nodeTree:NodeTree<Dummy>
	private var _headNodes: Set<Dummy>
	
	func addNodeOnStep() {
		
	}
	
	/// - returns: the pathnode successfully inserted
	func addPathNodeWrongAt(_ x:IntC, _ y:IntC) -> PathNode?{
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		let node = PathNode(x, y)
		guard addNodeIntoTree(node: node) else { print("insertion of node into tree failed"); return nil }
		_nodeTree.addNode(node: node)
		return node
	}
	
	/// - returns: the pathnode successfully inserted
	func addPathNode(_ node: PathNode) -> PathNode?{
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		guard addNodeIntoTree(node: node) else { print("insertion of node into tree failed"); return nil }
		_nodeTree.addNode(node: node)
		return node
	}
	
	func addTailNodes(tailNode:PathNode) {
		_tailNodes.append(tailNode)
	}
	
	/// - returns: the pathnodes successfully inserted
	func addHeadNode(_ head: PathNode) -> [PathNode] {
		guard addNodeIntoHeadSet(node: head) else { print("insertion into head set failed"); return []}
		var head: PathNode? = head
		var points: Points = []
		var nodes: [PathNode] = []
		repeat{
			guard addNodeIntoTree(node: head!) else {
				print("insertion of seg node into tree failed");
				break
			}
			points.append(contentsOf: head!.getPoint())
			nodes.append(head!)
			head = head?.prev()
		} while head != nil
		return nodes
	}
	
	func addShapeNodeToTail(shapeNode:ShapeNode) {
		shapeNode.setPathNode(pathNode: _tailNodes[0])
		_tailNodes[0].setShapeNode(node: shapeNode)
	}
	
	func getPathNodeAt(_ x: IntC, _ y: IntC) -> PathNode?{
		return _nodeTree.getNodesAt(x, y).first
	}
	
	init(width: IntC, height: IntC) {
		_nodeTree = NodeTree<PathNode>.init(width: width, height: height)
		_tailNodes = []
		_headNodes = Set<PathNode>()
		//_nodeTree = NodeTree<PathNode>()
	}
	
	private func addNodeIntoTree(node: PathNode) -> Bool{
		guard !_nodeTree.exists(node: node) else { return false;}
		_nodeTree.addNode(node: node)
		return true
	}
	
	private func addNodeIntoHeadSet(node: PathNode) -> Bool{
		guard !_headNodes.contains(node) else { return false;}
		_headNodes.insert(node)
		return true
	}
}

protocol PathNodeActionDelegate :NSObjectProtocol {
	func uiAddPathNodes(nodes: [Node])
}
