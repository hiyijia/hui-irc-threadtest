package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.text.ITextDisplay;
import haxe.ui.toolkit.text.TextDisplay;

class Text extends StateComponent {
	private var _textDisplay:ITextDisplay;
	
	public function new() {
		super();
		autoSize = true;
		_textDisplay = new TextDisplay();
		_textDisplay.text = "";
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		sprite.addChild(_textDisplay.display);

		if (autoSize == true) {
			if (width == 0) {
				width = _textDisplay.display.width;
			}
			if (height == 0) {
				height = _textDisplay.display.height;
			}
		}
	}
	
	public override function dispose() {
		sprite.removeChild(_textDisplay.display);
		super.dispose();
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		return _textDisplay.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		//_textDisplay.multiline = true;
		_textDisplay.text = value;
		if (autoSize == true) {
			width = _textDisplay.display.width;
			height = _textDisplay.display.height;
		} 
		return value;
	}
	
	private override function set_width(value:Float):Float {
		super.set_width(value);
		_textDisplay.display.width = value;
		_textDisplay.text = text;
		height = _textDisplay.display.height;
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	private override function applyStyle():Void {
		super.applyStyle();
		
		// apply style to TextDisplay
		if (_textDisplay != null) {
			_textDisplay.style = style;
			if (autoSize == true) {
				width = _textDisplay.display.width;
				height = _textDisplay.display.height;
			}
		}
	}
	
	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	public var multiline(get, set):Bool;
	
	private function get_multiline():Bool {
		return _textDisplay.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_textDisplay.multiline = value;
		return value;
	}
}