package haxe.ui.toolkit.core;

import haxe.ui.toolkit.controls.popups.BusyPopupContent;
import haxe.ui.toolkit.controls.popups.CustomPopupContent;
import haxe.ui.toolkit.controls.popups.ListPopupContent;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.popups.SimplePopupContent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.data.ArrayDataSource;
import haxe.ui.toolkit.data.IDataSource;

class PopupManager {
	private static var _instance:PopupManager;
	public static var instance(get_instance, null):PopupManager;
	public static function get_instance():PopupManager {
		if (_instance == null) {
			_instance = new PopupManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		
	}
	
	public function showSimple(root:Root, text:String, title:String = null, config:Dynamic = PopupButtonType.OK, fn:Dynamic->Void = null):Popup {
		var p:Popup = new Popup(title, new SimplePopupContent(text), getPopupConfig(config), fn);
		
		p.root = root;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		
		return p;
	}
	
	public function showCustom(root:Root, display:IDisplayObject, title:String = null, config:Dynamic = PopupButtonType.CONFIRM, fn:Dynamic->Void = null):Popup {
		var p:Popup = new Popup(title, new CustomPopupContent(display), getPopupConfig(config), fn);

		p.root = root;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		
		return p;
	}
	
	public function showList(root:Root, items:Dynamic, title:String = null, selectedIndex:Int = -1, fn:Dynamic->Void):Popup {
		var ds:IDataSource = null;
		if (Std.is(items, Array)) { // we need to convert items into a proper data source for the list
			var arr:Array<Dynamic> = cast(items, Array<Dynamic>);
			ds = new ArrayDataSource();
			for (item in arr) { // TODO: have to use objects in data sources else cant get proper object ids, means you cant just add an array of strings
				if (Std.is(item, String)) {
					var o:Dynamic = { };
					o.text = cast(item, String);
					ds.add(o);
				} else { // assume its an object
					ds.add(item);
				}
			}
		} else if (Std.is(items, IDataSource)) {
			ds = cast(items, IDataSource);
		}

		var p:Popup = new Popup(title, new ListPopupContent(ds, selectedIndex, fn), new PopupConfig());
		
		p.root = root;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		
		return p;
	}
	
	public function showBusy(root:Root, text:String, delay:Int = -1, title:String = null):Popup {
		var p:Popup = new Popup(title, new BusyPopupContent(text), new PopupConfig());
		
		p.root = root;
		centerPopup(p);
		root.showModalOverlay();
		root.addChild(p);
		
		return p;
	}
	
	public function hidePopup(p:Popup):Void {
		p.root.removeChild(p);
		p.root.hideModalOverlay();
	}
	
	public function centerPopup(p:Popup):Void {
		p.x = Std.int((p.root.width / 2) - (p.width / 2));
		p.y = Std.int((p.root.height / 2) - (p.height / 2));
	}
	
	private function getPopupConfig(config:Dynamic):PopupConfig {
		var conf:PopupConfig = new PopupConfig();
		if (Std.is(config, Int)) {
			var n:Int = cast(config, Int);
			if (n & PopupButtonType.OK == PopupButtonType.OK) {
				conf.addButton(PopupButtonType.OK);
			}
			if (n & PopupButtonType.YES == PopupButtonType.YES) {
				conf.addButton(PopupButtonType.YES);
			}
			if (n & PopupButtonType.NO == PopupButtonType.NO) {
				conf.addButton(PopupButtonType.NO);
			}
			if (n & PopupButtonType.CANCEL == PopupButtonType.CANCEL) {
				conf.addButton(PopupButtonType.CANCEL);
			}
			if (n & PopupButtonType.CONFIRM == PopupButtonType.CONFIRM) {
				conf.addButton(PopupButtonType.CONFIRM);
			}
		}
		return conf;
	}
}

class PopupConfig {
	public var buttons:Array<PopupButtonConfig>;
	
	public function new() {
		buttons = new Array<PopupButtonConfig>();
	}
	
	public function addButton(type:Int):Void {
		var butConfig:PopupButtonConfig = new PopupButtonConfig();
		butConfig.type = type;
		buttons.push(butConfig);
	}
}

class PopupButtonConfig {
	public var type:Int;
	
	public function new() {
		
	}
}

class PopupButtonType {
	public static inline var OK:Int =      0x00000001;
	public static inline var YES:Int =     0x00000010;
	public static inline var NO:Int =      0x00000100;
	public static inline var CANCEL:Int =  0x00001000;
	public static inline var CONFIRM:Int = 0x00010000;
	public static inline var CUSTOM:Int =  0x00100000;
}