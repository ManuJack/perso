package com.hebdo.manager.service
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class JsonService implements IService
	{
		private static const JSON_CONTENT_TYPE		:String = "application/json";
		
		private static const JSON_ALT_TYPE			:String = "json";
		private static const TYPE					:String = "alt";
		
		private var _definition						:ServiceDefinition;
		private var _data							:Object;
		
		private var _resultCallback					:Function;
		private var _errorCallback					:Function;
		
		private var _urlRequest						:URLRequest;
		private var _urlLoader						:URLLoader;
		
		private var _url							:String;
		
		public function JsonService(url:String)
		{
			construct(url);
		}
		
		private function construct(url:String):void
		{
			_url = url;
		}
		
		public function call():IService
		{
			if (_urlLoader)
			{
				removeUrlLoaderListeners(_urlLoader);
			}
			
			if (!url)
				throw new Error("Url can not be null.");
			
			//var header:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");
			
			_urlRequest = new URLRequest(url + action);
			//_urlRequest.requestHeaders.push(header);
			//_urlRequest.contentType = JSON_CONTENT_TYPE;
			_urlRequest.method = URLRequestMethod.POST;
			_urlRequest.data = getVariables();
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderCompleted);
			_urlLoader.addEventListener(ErrorEvent.ERROR, onUrlLoaderError);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderIOError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlLoaderSecurityError);
			_urlLoader.load(_urlRequest);
			
			return this;
		}
		
		private function getVariables():Object
		{
			var variables:URLVariables = new URLVariables();

			var property:String,
				value:Object;
			
			for (property in _data)
			{
				value = _data[property];

				variables[property] = value;
			}
			
			return variables;
		}
		
		private function onUrlLoaderCompleted(event:Event):void
		{
			var loader:IEventDispatcher = event.currentTarget as IEventDispatcher;
			removeUrlLoaderListeners(loader);
			
			var data:String = _urlLoader.data;
			try
			{
				var result:Object = JSON.parse(data);
				commonReceive(result);
			}
			catch (e:Error)
			{
				commonFail(e);
			}
		}
		
		private function onUrlLoaderError(event:ErrorEvent):void
		{
			var loader:IEventDispatcher = event.currentTarget as IEventDispatcher;
			removeUrlLoaderListeners(loader);
			
			commonError(event);
		}
		
		private function onUrlLoaderIOError(event:ErrorEvent):void
		{
			var loader:IEventDispatcher = event.currentTarget as IEventDispatcher;
			removeUrlLoaderListeners(loader);
			
			commonError(event);
		}
		
		private function onUrlLoaderSecurityError(event:ErrorEvent):void
		{
			var loader:IEventDispatcher = event.currentTarget as IEventDispatcher;
			removeUrlLoaderListeners(loader);
			
			commonError(event);
		}
		
		private function removeUrlLoaderListeners(dispatcher:IEventDispatcher):void
		{
			if (dispatcher != null)
			{
				dispatcher.removeEventListener(Event.COMPLETE, onUrlLoaderCompleted);
				dispatcher.removeEventListener(ErrorEvent.ERROR, onUrlLoaderError);
				dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderIOError);
				dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlLoaderSecurityError);
			}
		}
		
		private function removeListeners():void
		{
			removeUrlLoaderListeners(_urlLoader);
		}
		
		private function commonReceive(result:Object):void
		{
			removeListeners();
			
			//Error result received from service
			if(!result || ((result.execution && result.execution.error) || (result.data && result.data.error)))
			{
				commonError(result);
				return;
			}
			
			if (_resultCallback != null)
				_resultCallback(this, result);
			
			_data = {};
		}
		
		private function commonFail(result:Object):void
		{
			_data = {};
			removeListeners();
			
			//commonError(result);
			throw new Error("JSON failed:" + result);
		}
		
		private function commonError(error:Object):void
		{
			if (_errorCallback != null)
				_errorCallback(this, error);
		}
		
		public function set definition(value:ServiceDefinition):void
		{
			_definition = value;
		}
		
		public function get definition():ServiceDefinition
		{
			return _definition;
		}
		
		public function get action():String
		{
			return _definition.action;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set resultCallback(value:Function):void
		{
			_resultCallback = value;
		}
		
		public function set errorCallback(value:Function):void
		{
			_errorCallback = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
	}
}