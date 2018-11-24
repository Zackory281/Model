//
//  SceneController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

class SceneController : NSObject, SKSceneDelegate, SceneInputDelegate {
	
	private let _scene:NodeScene
	var _guiDelegate: GUIController
	
	var _overlayController: UIOverlayController
	private var px, py: Int!
	private var psx, psy: Int!
	private var withinSquare: Bool!
	private var _uiSetting: UISetting
	private var _keysDown = Set<String>()
	
	func keyDown(_ c:String) {
		_keysDown.insert(c)
		if c == "g" {
			_uiSetting[.AddGeometry] = true
		}
	}
	
	func keyUp(_ c:String) {
		_keysDown.remove(c)
		if c == "g" {
			_uiSetting[.AddGeometry] = false
		}
	}
	
	func keyClicked(_ c: String) {
		switch c {
		case "c":
			_guiDelegate.clearAllNodes()
			return
		case "t":
			_overlayController.display(.Tick(0))
			break
		case "a":
			_uiSetting[.AutoTick] = !(_uiSetting[.AutoTick] as! Bool)
			return
		default:
			break
		}
		guard let nodesModelController = _nodesModelController, let f = KEY_CODES[c] else { return }
		f(nodesModelController)()
	}
	
	func mouseDragged(_ x: Int, _ y: Int) {
		if withinSquare && (psx, psy) != (x / PATH_WIDTH, y / PATH_WIDTH) {
			withinSquare = false
		}
	}
	
	func mouseDown(_ x: Int, _ y: Int) {
		withinSquare = true
		(px, py) = (x, y)
		(psx, psy) = (x / PATH_WIDTH, y / PATH_WIDTH)
	}
	
	func mouseUp(_ x: Int, _ y: Int) {
		if withinSquare {
			if _uiSetting[.AddGeometry] as! Bool {
				_overlayController.display(.AddNode("GEO"))
				_nodesModelController?.clickToggleNode(psx, psy, type: .Geometry)
			} else {
				_overlayController.display(.AddNode("SHA"))
				_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
			}
			return
		}
		if let b = _nodesModelController?.addNodes(psx, psy, x / PATH_WIDTH, y / PATH_WIDTH), b {
			return
		}
	}
	
	func update() {
		if (_uiSetting[.AutoTick] as! Bool) {
			_nodesModelController?.tick()
		}
	}
	
	weak var _nodesModelController:NodesModelController?
	
	init(scene:NodeScene) {
		self._scene = scene
		_uiSetting = UISetting()
		_guiDelegate = GUIController(scene: scene, setting: _uiSetting)
		_overlayController = UIOverlayController(scene: scene, setting: _uiSetting)
		
		_uiSetting.delegate = _overlayController
	}
	
	func getScene() -> SKScene {
		return _scene
	}
}

let KEY_CODES:Dictionary<String, (NodesModelController) -> () -> ()> = [
	"t" : NodesModelController.tick,
	"l" : NodesModelController.preloadModel,
]

class UISetting: NSObject {
	var UI_SETTING:Dictionary<UISettingOption, Any> = [
		.AutoTick : true,
		.AddGeometry : false,
	]
	weak var delegate: UISettingDelegate?
	subscript(_ option: UISettingOption) -> Any {
		get {
			return UI_SETTING[option]!
		}
		set {
			if let delegate = delegate {
				delegate.update(option: option, content: newValue)
			}
			UI_SETTING[option] = newValue
		}
	}
}

enum UISettingOption {
	case AutoTick
	case AddGeometry
}
