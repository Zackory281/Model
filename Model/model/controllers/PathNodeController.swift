//
//  Map.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit


class PathNodeController {
	
	private var _tailNodes:[PathNodeAbstract]
	private var _nodeTree: NodeTree<PathNodeAbstract>
	private var _headNodes: Set<PathNodeAbstract>
	
	func addNodeOnStep() {
		
	}
	
	/// - returns: the pathnode successfully inserted
	func addPathNodeWrongAt(_ x:IntC, _ y:IntC) -> PathNodeAbstract?{
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		fatalError("addPathNodeWrongAt not implemented!")
//		let node = SerialPathNode(x, y)
//		guard addNodeIntoTree(node: node) else { print("insertion of node into tree failed"); return nil }
//		_nodeTree.addNode(node: node)
		return nil
	}
	
	/// - returns: the pathnode successfully inserted
	func addPathNode(_ node: PathNodeAbstract) -> PathNodeAbstract?{
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		guard addNodeIntoTree(node: node) else { print("insertion of node into tree failed"); return nil }
		_nodeTree.addNode(node: node)
		return node
	}
	
	func addTailNodes(tailNode:PathNodeAbstract) {
		_tailNodes.append(tailNode)
	}
	
	/// - returns: the pathnodes successfully inserted
	func addHeadNode(_ head: PathNodeAbstract) -> [PathNodeAbstract] {
		guard addNodeIntoHeadSet(node: head) else { print("insertion into head set failed"); return []}
		let nodes = Stack<PathNodeAbstract>()
		var rNodes: [PathNodeAbstract] = []
		rNodes.append(head)
		nodes.stack(head)
		while let top = nodes.pop() {
			guard addNodeIntoTree(node: top) else {
				print("insertion of seg node into tree failed");
				break
			}
			nodes.stack(top._prevs)
			rNodes.append(contentsOf: top._prevs)
		}
		return rNodes
	}
	
	func addShapeNodeToTail(shapeNode:ShapeNode) {
		shapeNode.setPathNode(pathNode: _tailNodes[0])
		_tailNodes[0]._shapeNode = shapeNode
	}
	
	func getPathNodeAt(_ point: Point) -> PathNodeAbstract?{
		return _nodeTree.getNodesAt(point.0, point.1).first
	}
	
	init(width: IntC, height: IntC) {
		_nodeTree = NodeTree<PathNodeAbstract>.init(width: width, height: height)
		_tailNodes = []
		_headNodes = Set<PathNodeAbstract>()
		//_nodeTree = NodeTree<PathNode>()
	}
	
	private func addNodeIntoTree(node: PathNodeAbstract) -> Bool{
		guard !_nodeTree.exists(node: node) else { return false;}
		_nodeTree.addNode(node: node)
		return true
	}
	
	private func addNodeIntoHeadSet(node: PathNodeAbstract) -> Bool{
		guard !_headNodes.contains(node) else { return false;}
		_headNodes.insert(node)
		return true
	}
}

protocol PathNodeActionDelegate :NSObjectProtocol {
	func uiAddPathNodes(nodes: [Node])
}
