//
//  NodesModel.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesModel : NSObject, AssertionDelegate {
	
	private var _tick :Int16
	
	var _modelActionDelegate: NodesModelActionDelegate? {
		set { _outputManager._modelActionDelegate = newValue }
		get { return _outputManager._modelActionDelegate }
	}
	
	private var _outputManager: NodesOutputManager!
	private var _nodeManager: NodesController!
	private var _logicManager: LogicManager!
	
	private let _queue = DispatchQueue(label: "com.NodeModel", qos: .userInteractive)
	
	override init() {
		_outputManager = NodesOutputManager()
		_nodeManager = NodesController()
		_logicManager = LogicManager()
		_nodeManager._nodeActionDelegate = _outputManager
		_logicManager._nodeQueryDelegate = _nodeManager
		_logicManager._nodeController = _nodeManager
		_tick = 0
		super.init()
		_logicManager.initializeLogicSystem(self)
	}
	
	// Mark: NodesModel stubs
	func addNodeAt(_ x:IntC, _ y:IntC, _ type: NodeType) {
		//tick()
		_queue.sync { ///Thread queuing so threads that use the same data doesn't cross modify/access them
			_nodeManager.addNodeAt(x, y, type)
		}
	}
	
	func tick() -> Bool {
		_tick += 1
		_queue.sync {
			_logicManager.tick(_tick)
			_nodeManager.tick(_tick)
			_outputManager.tick(_tick)
		}
		return false
	}
	
	func getTick() -> IntC {
		return _tick
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension NodesModel {
	func loadModel() {
		let points:[IntC] = [0,0, 0,1, 0,2, 1,2, 2,2, 2,3, 3,3, 4,3, 5,3, 6,3, 7,3]
		_nodeManager.addPathNodesFromHead(generateNodesHead(points: points)!)
//		perPoint(points: points) { (x, y) in
//			addShapeNodeAt(x, y)
//		}
	}
}

let MAP_WIDTH: IntC = 200, MAP_HEIGHT: IntC = 200

protocol NodesModelActionDelegate: NSObjectProtocol {
	func uiAddNodes(_ nodes: [Node])
	func uiUpdateNodes(_ nodes: [Node])
}

protocol OutputDelegate: NSObjectProtocol {
	//func moveNodes(points :Points, directions :[Direction])
	func uiAddNodes(nodes: [Node])
	func uiUpdateNodes(nodes: [Node])
}

extension NodesModel {
	
	func shapeNowMove(_ shapeNode: ShapeNode) -> LogicDerivation? {
		guard let pathNode = shapeNode.getPathNode(), let nextPathNode = pathNode.next() else { return RES(false, 1) }
		return PRE(.IsUntakenSquare(nextPathNode, shapeNode.getDirection()!))
	}
	
	func isUntakeSquare(_ pathNode: SerialPathNode, _ direction: Direction) -> LogicDerivation? {
		return pathNode.getNowUntakeDerivation(ignore: direction)
	}
	
	
	func isEmptySquare(_ x: IntC, _ y: IntC, _ comingDirection: Direction) -> LogicDerivation? {
		return .Result(Result(true, 5))
	}
}
