package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.HorizontalLayout;

class OptionBox extends Component {
	private var _value:OptionBoxValue;
	private var _label:Text;
	
	private var _group:String;
	private static var _groups:Hash<Array<OptionBox>>;
	
	public function new() {
		super();
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		if (_groups == null) {
			_groups = new Hash<Array<OptionBox>>();
		}
		
		_value = new OptionBoxValue();
		_value.interactive = false;
		_label = new Text();
		_layout = new HorizontalLayout();
		_autoSize = true;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		addChild(_value);
		addChild(_label);
		
		addEventListener(MouseEvent.CLICK, function(e) {
			if (selected == false) {
				selected = !selected;
			}
		});
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		return _label.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		_label.text = value;
		return value;
	}
	
	//******************************************************************************************
	// Component getters/setters
	//******************************************************************************************
	public var selected(get, set):Bool;
	public var group(get, set):String;
	
	private function get_selected():Bool {
		return (_value.value == "selected");
	}
	
	private function set_selected(value:Bool):Bool {
		_value.value = (value == true) ? "selected" : "unselected";
		if (_group != null && value == true) { // set all the others in group
			var arr:Array<OptionBox> = _groups.get(_group);
			if (arr != null) {
				for (option in arr) {
					if (option != this) {
						option.selected = false;
					}
				}
			}
		}
		return value;
	}
	
	private function get_group():String {
		return _group;
	}
	
	private function set_group(value:String):String {
		if (value != null) {
			var arr:Array<OptionBox> = _groups.get(value);
			if (arr != null) {
				arr.remove(this);
			}
		}
		
		_group = value;
		var arr:Array<OptionBox> = _groups.get(value);
		if (arr == null) {
			arr = new Array<OptionBox>();
		}
		
		if (optionInGroup(value, this) == false) {
			arr.push(this);
		}
		_groups.set(value, arr);
		
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private static function optionInGroup(value:String, option:OptionBox):Bool {
		var exists:Bool = false;
		var arr:Array<OptionBox> = _groups.get(value);
		if (arr != null) {
			for (test in arr) {
				if (test == option) {
					exists = true;
					break;
				}
			}
		}
		return exists;
	}
}

class OptionBoxValue extends Value {
	public function new() {
		super();
		_value = "unselected";
		addValue("selected");
		addValue("unselected");
	}
}