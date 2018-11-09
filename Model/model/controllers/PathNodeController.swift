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
	
	var _nodesToUpdate: [PathNodeAbstract]
	var _nodesToAdd: [PathNodeAbstract]
	
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
	func addPathNode(at point: Point) -> PathNodeAbstract?{
		//_nodeTree.addPathNode(pathNode: PathNode.init(x, y))
		// TODO: fix me!
		guard _nodeTree.isEmpty(at: point) else { print("I thought there weren't any nodes?");return nil }
		let node = SerialPathNode(point: point)
		_nodesToAdd.append(node)
		let _dirNodes = _nodeTree.getNeibhorNodesAt(node._point).filter { (node, dir) -> Bool in
			return (node._nexts.isEmpty || node._prevs.isEmpty)
		}
		switch _dirNodes.count {
		case 0:
			break
		case 1:
			let (n, d) = _dirNodes[0]
			if let n = n as? SerialPathNode {
				if n._next == nil {
					n._next = node
					node._prev = n
					n._direction = d.opposite()
					_nodesToUpdate.append(n)
					break
				}
				if n._prev == nil && (n._next?._point)! != node._point {
					n._prev = node
					node._next = n
					node._direction = d.opposite()
					n._direction = d
					_nodesToUpdate.append(n)
					break
				}
			}
		case 2:
			for (n, d) in _dirNodes {
				if let n = n as? SerialPathNode {
					if n._next == nil {
						n._next = node
						node._prev = n
						n._direction = d.opposite()
						_nodesToUpdate.append(n)
					} else if n._prev == nil && (n._next?._point)! != node._point {
						n._prev = node
						node._next = n
						node._direction = d
						_nodesToUpdate.append(n)
					}
				}
			}
			break
		default:
			break
		}
//		for (n, dir) in _nodeTree.getNeibhorNodesAt(node._point) {
//			switch n {
//			case let n as SerialPathNode:
//				if n._next == nil {
//					n._next = node
//					node._prev = n
//					n._direction = dir.opposite()
//					_nodesToUpdate.append(n)
//					continue
//				} else if n._prev == nil{
////					n._prev = node
////					node._next = n
////					_nodesToUpdate.append(n)
////					continue
//				}
//			default:
//				continue
//			}
//		}
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
		shapeNode._pathNode = _tailNodes[0]
		_tailNodes[0]._shapeNode = shapeNode
	}
	
	func getPathNodeAt(_ point: Point) -> PathNodeAbstract?{
		return _nodeTree.getNodesAt(point.0, point.1).first
	}
	
	init(width: IntC, height: IntC) {
		_nodeTree = NodeTree<PathNodeAbstract>.init(width: width, height: height)
		_tailNodes = []
		_headNodes = Set<PathNodeAbstract>()
		_nodesToUpdate = []
		_nodesToAdd = []
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
