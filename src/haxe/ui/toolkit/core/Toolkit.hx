package haxe.ui.toolkit.core;

import flash.Lib;
import haxe.ui.toolkit.core.interfaces.IDataComponent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.xml.DataProcessor;
import haxe.ui.toolkit.core.xml.IXMLProcessor;
import haxe.ui.toolkit.core.xml.StyleProcessor;
import haxe.ui.toolkit.core.xml.UIProcessor;
import haxe.ui.toolkit.data.DataManager;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.hscript.ClientWrapper;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.style.StyleParser;
import haxe.ui.toolkit.style.Styles;
import haxe.ui.toolkit.util.TypeParser;

class Toolkit {
	private static var _instance:Toolkit;
	public static var instance(get, null):Toolkit;
	public static function get_instance():Toolkit {
		if (_instance == null) {
			Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
			Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			_instance = new Toolkit();
		}
		return _instance;
	}
	
	public static function init():Void {
		get_instance();
		registerXMLProcessor(UIProcessor, "ui");
		registerXMLProcessor(UIProcessor, "selection");
		registerXMLProcessor(StyleProcessor, "style");
		registerXMLProcessor(DataProcessor, "data");
	}
	
	private static var _registeredProcessors:Hash<String>;
	public static function registerXMLProcessor(cls:Class<IXMLProcessor>, prefix:String):Void {
		if (_registeredProcessors == null) {
			_registeredProcessors = new Hash<String>();
		}
		_registeredProcessors.set(prefix, Type.getClassName(cls));
	}
	//******************************************************************************************
	// Processes a chunk of xml, return values depend on what comes in, could return IDisplayObject, IDataSource
	// processing means constructing ui, registering data sources
	//******************************************************************************************
	
	public static function processXml(xml:Xml):Dynamic {
		var result:Dynamic = null;
		
		result = processXmlNode(xml.firstElement());
		
		return result;
	}
	
	private static function processXmlNode(node:Xml):Dynamic {
		if (node == null) {
			return null;
		}
		
		var result:Dynamic = null; 
		var nodeName:String = node.nodeName;
		var nodeNS:String = null;
		var n:Int = nodeName.indexOf(":");
		if (n != -1) {
			nodeNS = nodeName.substr(0, n);
			nodeName = nodeName.substr(n + 1, nodeName.length);
		}

		var condition:String = node.get("condition");
		if (condition != null) {
			var parser = new hscript.Parser();
			var program = parser.parseString(condition);
			var interp = new hscript.Interp();
			var clientWrapper:ClientWrapper = new ClientWrapper();
			interp.variables.set("Client", clientWrapper);
			var conditionResult:Bool = interp.execute(program);
			if (conditionResult == false) {
				return null;
			}
		}
		
		if (nodeNS == "sys") {
			if (nodeName == "import") {
				var importResource = node.get("resource");
				if (importResource != null) {
					var importData:String = ResourceManager.instance.getText(importResource);
					if (importData != null) {
						var importXml:Xml = Xml.parse(importData);
						return processXml(importXml);
					}
				}
			}
		} else {
			var p:IXMLProcessor = null;
			if (_registeredProcessors != null) {
				var processorClassName:String = _registeredProcessors.get(nodeNS);
				if (processorClassName != null) {
					p = Type.createInstance(Type.resolveClass(processorClassName), []);
				}
			}
		
			if (p != null) {
				result = p.process(node);
			}
		}
		
		for (child in node.elements()) {
			var childResult = processXmlNode(child);
			
			if (Std.is(childResult, IDataSource) && Std.is(result, IDataComponent)) {
				cast(result, IDataComponent).dataSource = cast(childResult, IDataSource);
			}
			
			if (Std.is(childResult, IDisplayObject) && Std.is(result, IDisplayObjectContainer)) {
				cast(result, IDisplayObjectContainer).addChild(cast(childResult, IDisplayObject));
			}
		}
		
		return result;
	}

	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		initInstance();
	}
	
	private function initInstance() {
		ClassManager.instance;
	}
}