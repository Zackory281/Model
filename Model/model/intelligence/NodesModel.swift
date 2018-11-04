//
//  NodesModel.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesModel : NSObject, ShapeNodeActionDelegate, PathNodeActionDelegate, AssertionDelegate {
	
	private var _tick :IntC
	private var _pathNodeController :PathNodeController
	private var _shapeNodeController :ShapeNodeController
	private lazy var _logic: LogicSystem = { return LogicSystem(self) }()
	
	weak var  _modelActionDelegate: NodesModelActionDelegate?
	weak var _guiDelegate: GUIDelegate?
	
	convenience override init() {
		self.init(guiDelegate: nil)
	}
	
	init(guiDelegate: GUIDelegate?) {
		_tick = 0
		_guiDelegate = guiDelegate
		_pathNodeController = PathNodeController(width: MAP_WIDTH, height: MAP_HEIGHT)
		_shapeNodeController = ShapeNodeController()
		super.init()
		_shapeNodeController._nodeActionDelegate = self
		_pathNodeController._pathNodeActionDelegate = self
	}
	
	// Mark: PathNodeActionDelegate stubs
	func uiAddPathNodes(nodes: [Node]) {
		_modelActionDelegate?.uiAddPathNodes(nodes)
	}
	
	// Mark: ShapeNodeActionDelegate stubs
	func moveNodes(points :Points, directions :[Direction]) {
		perPoint(points: points, meta: directions, function: {(x:IntC, y:IntC, dir:Direction) in
			print("x: \(x)")
		})
	}
	
	// Mark: NodesModel stubs
	func addPathNodeAt(_ x:IntC, _ y:IntC) {
		//let pathNode = PathNode(IntC(x), IntC(y))
		_pathNodeController.addPathNodeAt(x, y)
	}
	
	func addPathNodesFromTail(points: Points) {
		let head = generateNodesHead(points: points)!
		_pathNodeController.addHeadNode(head)
	}
	
	func loadModel() {
		_pathNodeController.addHeadNode(generateNodesHead(points: [0,0, 0,1, 0,2, 1,2, 2,2, 2,3, 3,3, 4,3, 5,3, 6,3, 7,3])!)
	}
	
	func tick() -> Bool {
		_tick += 1
		_shapeNodeController.tick()
		
		return false
	}
	
	func getTick() -> IntC {
		return _tick
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let MAP_WIDTH: IntC = 200, MAP_HEIGHT: IntC = 200

protocol NodesModelActionDelegate: NSObjectProtocol {
	func uiAddPathNodes(_ nodes: [Node])
}

protocol ShapeNodeActionDelegate: NSObjectProtocol {
	func moveNodes(points :Points, directions :[Direction])
}

extension NodesModel {
	
	func isEmptySquare(_ x: Int, _ y: Int) -> Bool {
		return !hasObjectAt(x, y)
	}
	
	func hasObjectAt(_ x: Int, _ y: Int) -> Bool {
		return _shapeNodeController.hasShapeNodeAt(IntC(x), y: IntC(y))
	}
}
