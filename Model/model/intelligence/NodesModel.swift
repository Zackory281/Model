//
//  NodesModel.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesModel : NSObject, AssertionDelegate {
	var _tick: TickU
	
	var _modelActionDelegate: NodesModelActionDelegate? {
		set { _outputManager._modelActionDelegate = newValue }
		get { return _outputManager._modelActionDelegate }
	}
	
	private var _outputManager: NodesOutputManager!
	private var _nodeManager: NodesController!
	private var _logicManager: LogicManager!
	private var _shapeController: ShapeController!
	private var _attackController: AttackController!
	
	private let _queue = DispatchQueue(label: "com.NodeModel", qos: .userInteractive)
	
	override init() {
		_outputManager = NodesOutputManager()
		_nodeManager = NodesController()
		_logicManager = LogicManager()
		_attackController = AttackController(nodesController: _nodeManager)
		_shapeController = ShapeController(nodesController: _nodeManager, shapeNodeController: _nodeManager._shapeNodeController, pathNodeController: _nodeManager._pathNodeController, attackController: _attackController)
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
	
	func removeNodeAt(_ x:IntC, _ y:IntC, _ type: NodeType) -> Bool {
		//tick()
		_queue.sync { ///Thread queuing so threads that use the same data doesn't cross modify/access them
			_nodeManager.removeNodeAt((x, y))
		}
		return true
	}
	
	func addNodeStride(_ points: Points) {
		_queue.sync {
			if _nodeManager.getNode(at: (points[0], points[1])) == nil {
				_nodeManager.addPathNodesFromHead(generateNodesHead(points: points)!)
			} else {
				perPoint(points: points, function: { (x, y) in
					_nodeManager.addNodeAt(x, y, .Shape)
				})
			}
		}
	}
	
	func tick() -> Bool {
		_tick += 1
		_queue.sync {
			_logicManager.tick(_tick)
			_shapeController.tick(_tick)
			_attackController.tick(_tick)
			_nodeManager.tick(_tick)
			_outputManager.tick(_tick)
		}
		return true
	}
	
	func getTick() -> TickU {
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
	func uiAddQueue(_ : GUIQueue)
}

protocol OutputDelegate: NSObjectProtocol {
	func uiAddQueue(_ : GUIQueue)
}

extension NodesModel {
	
	func shapeNowMove(_ shapeNode: ShapeNode) -> LogicDerivation? {
		guard shapeNode._state == .CanNowMove, let nextPathNode = shapeNode._pathNode?.getNext(nil)
			, !nextPathNode._taken else {
			return RES(false, 1)
		}
		if nextPathNode._ocNode != nil {
			return RES(false, 2)
		}
		return PRE(.IsUntakenSquare(nextPathNode, shapeNode._direction!))
	}
	
	func isUntakeSquare(_ pathNode: PathNodeAbstract, _ direction: Direction) -> LogicDerivation? {
		return pathNode.getNowUntakeDerivation(ignore: direction)
	}
	
	func isEmptySquare(_ x: IntC, _ y: IntC, _ comingDirection: Direction) -> LogicDerivation? {
		return .Result(Result(true, 5))
	}
}
