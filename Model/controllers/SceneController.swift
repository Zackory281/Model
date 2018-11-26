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
		if let name = KEY_DIRECT_TOGGLES[c] {
			_uiSetting.boolInvert(name)
		}
	}
	
	func keyUp(_ c:String) {
		_keysDown.remove(c)
		if let name = KEY_DIRECT_TOGGLES[c] {
			_uiSetting.boolInvert(name)
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
			if _uiSetting[.Remove] as! Bool {
				_nodesModelController?.removeNodesAt(psx, psy)
			} else {
				if _uiSetting[.AddGeometry] as! Bool {
					_overlayController.display(.AddNode("GEO"))
					_nodesModelController?.clickToggleNode(psx, psy, type: .Geometry)
				} else {
					_overlayController.display(.AddNode("SHA"))
					_nodesModelController?.clickToggleNode(psx, psy, type: .Shape)
				}
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
	
	init(scene:NodeScene, setting: UISetting, overlayController: UIOverlayController) {
		self._scene = scene
		_uiSetting = setting
		_guiDelegate = GUIController(scene: scene, setting: setting, overlayController: overlayController)
		_overlayController = overlayController
		
		_uiSetting.delegate = _overlayController
	}
	
	func getScene() -> SKScene {
		return _scene
	}
}

let KEY_DIRECT_TOGGLES: Dictionary<String, SettingName> = [
	"r" : SettingName.Remove,
	"g" : SettingName.AddGeometry,
	"1" : SettingName.Toggle1,
	"2" : SettingName.Toggle2,
	"3" : SettingName.Toggle3,
]
let KEY_CODES:Dictionary<String, (NodesModelController) -> () -> ()> = [
	"t" : NodesModelController.tick,
	"l" : NodesModelController.preloadModel,
]

class UISetting: NSObject {
	var UI_SETTING:Dictionary<SettingName, SettingEntry> = [
		.AutoTick : SettingEntry.init(name: .AutoTick, set: true, type: .Boolean),
		.AddGeometry : SettingEntry.init(name: .AddGeometry, set: false, type: .Boolean),
		.Remove : SettingEntry.init(name: .Remove, set: false, type: .Boolean),
		.Toggle1 : SettingEntry.init(name: .Toggle1, set: false, type: .Boolean),
		.Toggle2 : SettingEntry.init(name: .Toggle2, set: false, type: .Boolean),
		.Toggle3 : SettingEntry.init(name: .Toggle3, set: false, type: .Boolean),
	]
	weak var delegate: UISettingDelegate?
	subscript(_ name: SettingName) -> Any {
		get {
			return UI_SETTING[name]!.set
		}
		set {
			UI_SETTING[name]!.set = newValue
			updateDelegate(name)
		}
	}
	
	func updateDelegate(_ name: SettingName) {
		if let delegate = delegate {
			delegate.update(entry: UI_SETTING[name]!)
		}
	}
	
	func boolInvert(_ name: SettingName) {
		guard let entry = UI_SETTING[name], entry.type == .Boolean else { print("Not a boolean entry", name); return }
		entry.set = !(entry.set as! Bool)
		updateDelegate(name)
	}
}

enum SettingName: String {
	case AutoTick = "Auto Tick"
	case AddGeometry = "Add Geo"
	case Remove = "Remove"
	case Toggle1 = "Toggle1"
	case Toggle2 = "Toggle2"
	case Toggle3 = "Toggle3"
}

class SettingEntry: NSObject {
	let name: SettingName
	var set: Any
	let type: SettingType
	init(name: SettingName, set: Any, type: SettingType = .Boolean) {
		self.name = name
		self.set = set
		self.type = type
	}
}

enum SettingType {
	case Integer
	case Float
	case Boolean
	case Other
}
