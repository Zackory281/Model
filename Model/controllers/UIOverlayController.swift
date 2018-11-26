//
//  UIOverlayController.swift
//  Model
//
//  Created by Zackory Cramer on 11/23/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

class UIOverlayController : NSObject, UISettingDelegate {
	private weak var _scene: NodeScene?
	private weak var _uiSetting : UISetting?
	private var _settingNode: [SettingName : SKNode] = [:]
	private var _actionTop: BaseActionItemNode
	
	init(scene: NodeScene, setting: UISetting) {
		_scene = scene
		_uiSetting = setting
		_actionTop = BaseActionItemNode()
		super.init()
		loadTags()
	}
	
	func display(_ action: OverlayAction) {
		var item = SKNode()
		var time: TimeInterval = 1
		switch action {
		case let .Tick(i):
			item = getActionNode(text: "Ticked \(i)", color: NSColor.systemPurple)
			time = 1
		case let .AddNode(i):
			item = getActionNode(text: "Add Node \(i)", color: NSColor.systemPurple)
			time = 1
		case let .Display(i):
			item = getActionNode(text: i, color: NSColor.systemPurple)
			time = 1
		default:
			print("not set display for ", action)
		}
		let anode = ActionItemNode(node: item, before: _actionTop, after: nil, time: time)
		_actionTop._nodeAfter = anode
		_actionTop = anode
		item.position.y = height - CGFloat(_actionTop._index) * (nodeHeight + nodeCrack)
		_scene!.addChild(item)
		item.xScale = 0
		item.yScale = 0
		item.run(SKAction.scale(to: 1, duration: 0.1))
		item.run(SKAction.sequence([SKAction.wait(forDuration: time), SKAction.run({[unowned self] in self.removeDisplay(anode)})]))
	}
	
	func removeDisplay(_ node: ActionItemNode) {
		let b4 = node._nodeBefore
		b4._nodeAfter = node._nodeAfter
		if let a = node._nodeAfter {
			a._nodeBefore = b4
		}
		var af = node._nodeAfter
		while let a = af {
			let node = a._node
			a._index = a._nodeBefore._index + 1
			node.run(SKAction.moveTo(y: height - CGFloat(a._index) * (nodeHeight + nodeCrack), duration: 0.1))
			af = a._nodeAfter
		}
		if node === _actionTop {
			_actionTop = b4
		}
		node._node.run(SKAction.scale(to: 0, duration: 0.1))
		node._node.run(SKAction.sequence([.fadeOut(withDuration: 0.1), .run{node._node.removeFromParent()}]))
	}
	
	func loadTags() {
		var i = 0
		for (name, entry) in _uiSetting!.UI_SETTING {
			var node: SKNode
			switch entry.type {
			case .Boolean:
				node = getBooleanNode(name.rawValue, i: i, b: entry.set as! Bool)
			default:
				print("not configuered for ", entry.type)
				continue
			}
			_settingNode[name] = node
			update(entry: entry)
			_scene!.addChild(node)
			i += 1
		}
	}
	
	func getBooleanNode(_ text: String, i: Int, b: Bool) -> SKNode {
		let y = CGFloat(i) * (nodeHeight + nodeCrack) + 100
		let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: nodeWidth, height: nodeHeight))
		let label = SKLabelNode(text: text)
		label.fontSize = nodeHeight / 1.5
		node.position = CGPoint(x: _scene!.size.width, y: y)
		label.position = CGPoint(x: nodeWidth/2, y: nodeHeight/2 - label.frame.height/2)
		label.fontName = "SF Mono Regular"
		node.addChild(label)
		node.fillColor = NSColor.systemGreen//b ? NSColor.systemGreen : NSColor.systemRed
		//node.alpha = 0.7
		node.lineWidth = 0
		return node
	}
	
	func update(entry: SettingEntry) {
		switch entry.type {
		case .Boolean:
			if entry.set as! Bool {
				makeAppear(_settingNode[entry.name]!)
			} else {
				makeDisappear(_settingNode[entry.name]!)
			}
		default:
			print("UILay not configured for ", entry.name)
		}
	}
	
	func getActionNode(text: String, color: NSColor) -> SKNode {
		let node = SKShapeNode(rect: CGRect(x: -nodeWidth / 2, y: 0, width: nodeWidth, height: nodeHeight))
		let label = SKLabelNode(text: text)
		label.fontSize = nodeHeight / 1.5
		node.position = CGPoint(x: width / 2, y: 0)
		label.position = CGPoint(x: 0, y: nodeHeight/2 - label.frame.height/2)
		label.fontName = "SF Mono"
		node.addChild(label)
		node.fillColor = color
		node.alpha = 0.7
		node.lineWidth = 0
		label.alpha = 1
		return node
	}
	
	func makeAppear(_ node: SKNode) {
		node.run(makeAppearAction)
	}
	
	func makeDisappear(_ node: SKNode) {
		node.run(makeDisappearAction)
	}
	
	var width: CGFloat { get { return _scene!.size.width } }
	var height: CGFloat { get { return _scene!.size.height } }
	lazy var makeAppearAction = {return SKAction.moveTo(x: width - nodeWidth, duration: 0.1)}()
	lazy var makeDisappearAction = {return SKAction.moveTo(x: width, duration: 0.1)}()
}

class BaseActionItemNode {
	var _nodeAfter: ActionItemNode?
	var _index: Int
	init() {
		_nodeAfter = nil
		_index = 0
	}
}
class ActionItemNode: BaseActionItemNode {
	var _nodeBefore: BaseActionItemNode
	var _node: SKNode
	let _time: TimeInterval
	init(node: SKNode, before: BaseActionItemNode, after: ActionItemNode?, time: TimeInterval) {
		_nodeBefore = before
		_time = time
		_node = node
		super.init()
		_nodeAfter = after
		_index = before._index + 1
	}
}

let nodeWidth: CGFloat = 120.0
let nodeHeight: CGFloat = 30.0
let nodeCrack: CGFloat = 10

enum OverlayAction {
	case Tick(TickU)
	case AddNode(String)
	case Display(String)
}
protocol UISettingDelegate: class {
	func update(entry: SettingEntry)
}
