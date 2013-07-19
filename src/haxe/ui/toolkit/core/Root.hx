package haxe.ui.toolkit.core;

import flash.events.Event;
import flash.filters.BlurFilter;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.layout.AbsoluteLayout;
import haxe.ui.toolkit.layout.Layout;

class Root extends Component {
	private var _modalOverlay:Component;
	
	public function new() {
		super();
		_layout = new AbsoluteLayout();
		Screen.instance.addEventListener(Event.RESIZE, _onScreenResize);
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		resizeRoot();
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onScreenResize(event:Event):Void {
		resizeRoot();
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function resizeRoot():Void {
		if (percentWidth > 0) {
			width = (Screen.instance.width * percentWidth) / 100; 
		}
		if (percentHeight > 0) {
			height = (Screen.instance.height * percentHeight) / 100; 
		}
	}
	
	public function showModalOverlay():Void {
		if (_modalOverlay == null) {
			_modalOverlay = new Component();
			_modalOverlay.id = "modalOverlay";
			_modalOverlay.percentWidth = _modalOverlay.percentHeight = 100;
		}
		if (findChild("modalOverlay") == null) {
			addChild(_modalOverlay);
		}
		_modalOverlay.visible = true;
		
		#if !(android)
		for (child in children) {
			if (Std.is(child, Popup) == false && child.id != "modalOverlay") {
				var c:Component = cast(child, Component);
				c.sprite.filters = [new BlurFilter(4, 4)];
			}
		}
		#end
	}
	
	public function hideModalOverlay():Void {
		if (_modalOverlay != null) {
			_modalOverlay.visible = false;
		}
		
		#if !(android)
		for (child in children) {
			if (Std.is(child, Popup) == false && child.id != "modalOverlay") {
				var c:Component = cast(child, Component);
				c.sprite.filters = null;
			}
		}
		#end
	}
}