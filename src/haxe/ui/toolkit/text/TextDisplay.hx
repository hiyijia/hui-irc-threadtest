package haxe.ui.toolkit.text;

import flash.display.DisplayObject;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

class TextDisplay implements ITextDisplay {
	private var _style:Dynamic;
	private var _tf:TextField; 
	
	public function new() {
		_tf = new TextField();
		_tf.type = TextFieldType.DYNAMIC;
		_tf.selectable = false;
		_tf.multiline = false;
		_tf.mouseEnabled = false;
		_tf.wordWrap = false;
		_tf.autoSize = TextFieldAutoSize.NONE;
		_tf.text = "";
	}
	
	//******************************************************************************************
	// ITextDisplay
	//******************************************************************************************
	public var text(get, set):String;
	public var style(get, set):Dynamic;
	public var display(get, null):DisplayObject;
	public var interactive(get, set):Bool;
	public var multiline(get, set):Bool;

	private function get_text():String {
		return _tf.text;
	}
	
	private function set_text(value:String):String {
		if (_tf.multiline == false) {
			//_tf.htmlText = StringTools.replace(value, "\\n", "<br>");
			_tf.text = StringTools.replace(value, "\\n", "\n");
		} else {
			//_tf.htmlText = StringTools.replace(value, "\\n", "<br>");
			_tf.text = StringTools.replace(value, "\\n", "\n");
		}
		style = _style;
		if (value.length > 0) {
			if (_tf.type == TextFieldType.DYNAMIC) {
				_tf.width = _tf.textWidth + 4;
				_tf.height = _tf.textHeight + 4;
			} else if (_tf.type == TextFieldType.INPUT && _tf.multiline == false) {
				//_tf.width = _tf.textWidth + 4;
				//_tf.height = _tf.textHeight + 4;
			}
		} else {
			if (_tf.type == TextFieldType.DYNAMIC) {
				_tf.width = 0;
				_tf.height = 0;
			} else if (_tf.type == TextFieldType.INPUT && _tf.multiline == false) {
			}
		}
		return value;
	}
	
	private function get_style():Dynamic {
		return _style;
	}
	
	private function set_style(value:Dynamic):Dynamic {
		if (value == null) {
			return value;
		}
		_style = value;
		var format:TextFormat = _tf.getTextFormat();
		if (_style.fontName != null) {
			format.font = _style.fontName;
		}
		if (_style.fontSize != null) {
			format.size = _style.fontSize;
		}
		if (_style.color != null) {
			format.color = _style.color;
		}
		
		_tf.defaultTextFormat = format;
		_tf.setTextFormat(format);
		
		if (text.length > 0) {
			if (_tf.type == TextFieldType.DYNAMIC) {
				_tf.width = _tf.textWidth + 4;
				_tf.height = _tf.textHeight + 4;
			} else if (_tf.type == TextFieldType.INPUT && _tf.multiline == false) {
				//_tf.width = _tf.textWidth + 4;
				//_tf.height = _tf.textHeight + 4;
			}
		}
		
		return value;
	}
	
	private function get_display():DisplayObject {
		return _tf;
	}
	
	private function get_interactive():Bool {
		return _tf.type == TextFieldType.INPUT;
	}
	
	private function set_interactive(value:Bool):Bool {
		if (value == true) {
			_tf.type = TextFieldType.INPUT;
			_tf.selectable = true;
			_tf.mouseEnabled = true;
		} else {
			_tf.type = TextFieldType.DYNAMIC;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
		}
		return value;
	}
	
	private function get_multiline():Bool {
		return _tf.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_tf.multiline = value;
		_tf.wordWrap = value;
		return value;
	}
}