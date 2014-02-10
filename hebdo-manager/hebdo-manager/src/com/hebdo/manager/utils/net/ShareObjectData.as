package com.hebdo.manager.utils.net
{
	import com.hebdo.manager.utils.net.event.ShareObjectDataEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	[Event(name="initializeCompleted", type="com.hebdo.manager.utils.net.event.ShareObjectDataEvent")]
	[Event(name="saveCompleted", type="com.hebdo.manager.utils.net.event.ShareObjectDataEvent")]
	[Event(name="saveError", type="com.hebdo.manager.utils.net.event.ShareObjectDataEvent")]
	public class ShareObjectData extends EventDispatcher
	{
		private static const DEFAULT_NAME				:String = "default";
		private static const DEFAULT_PATH				:String = "/";
		
		private var _cookie								:SharedObject;
		
		private var _name								:String;
		private var _path								:String;
		
		private var _initialized						:Boolean;
		private var _minDiskSpace						:int;
		
		private var _dataBuffer:Object;
		private var _isDataBufferEnabled:Boolean;
		private var _deletedProperties:Vector.<String>;
		
		public function ShareObjectData(name:String, path:String)
		{
			construct(name, path);
		}
		
		private function construct(name:String, path:String):void
		{
			_name = name ? name : DEFAULT_NAME;
			_path = path ? path : DEFAULT_PATH;
		}
		
		public function destroy():void
		{
			if (_cookie != null)
			{
				_cookie.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
				_cookie.close();
				_cookie = null;
			}
			clearDataBuffer();
			if (_deletedProperties != null)
			{
				_deletedProperties.length = 0;
				_deletedProperties = null;
			}
			_initialized = false;
		}
		
		public function init(minDiskSpace:int = 0):void
		{
			if (_initialized)
			{
				return notifyInitialized();
			}
			_minDiskSpace = minDiskSpace;
			_cookie = SharedObject.getLocal(_name);
			save();
		}
		
		public function save():void
		{
			if (_cookie != null)
			{
				var flushStatus:String;
				try
				{
					flushStatus = _cookie.flush(_minDiskSpace);
				}
				catch (error:Error)
				{
					dispatchEvent(new ShareObjectDataEvent(ShareObjectDataEvent.SAVE_ERROR));	
				}
				
				if (flushStatus != null)
				{
					switch (flushStatus)
					{
					   	case SharedObjectFlushStatus.PENDING:
					       	_cookie.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
					        break;
					    case SharedObjectFlushStatus.FLUSHED:
					        success();
					        break;
					}
				}
			}
		}

		public function clear():void
		{
			if (_cookie)
			{
				_cookie.clear();
			}	
		}

		private function onFlushStatus(e:NetStatusEvent):void
		{
            var code:String = e.info.code;
            switch (code) {
                case "SharedObject.Flush.Success":
                	success();
                    break;
                case "SharedObject.Flush.Failed":
					dispatchEvent(new ShareObjectDataEvent(ShareObjectDataEvent.SAVE_ERROR));					
                    break;
            }			
		}
		
		private function success():void
		{
			var isInitialized:Boolean = _initialized;
			_initialized = true;
			if (!isInitialized)
				notifyInitialized();
			else
				notifySaveCompleted();
		}

		private function notifyInitialized():void
		{
			if (hasEventListener(ShareObjectDataEvent.INTIALIZE_COMPLETED))
				dispatchEvent(new ShareObjectDataEvent(ShareObjectDataEvent.INTIALIZE_COMPLETED));
		}
		
		private function notifySaveCompleted():void
		{
			if (hasEventListener(ShareObjectDataEvent.SAVE_COMPLETED))
				dispatchEvent(new ShareObjectDataEvent(ShareObjectDataEvent.SAVE_COMPLETED));
		}
		
		public function setProperty(property:String, value:Object, flushNow:Boolean = true):void
		{
			if (_isDataBufferEnabled)
			{
				if (_deletedProperties != null)
				{
					var index:int = _deletedProperties.indexOf(property);
					if (index != -1)
					{
						_deletedProperties.splice(index, 1);
					}
				}
				
				_dataBuffer ||= {};
				_dataBuffer[property] = value;
				return;
			}
			
			if (_cookie != null && _cookie.data != null)
			{
				_cookie.data[property] = value;
				
				if (flushNow)
					save();
			}
		}

		public function getProperty(property:String, defaultValue:Object = null):Object
		{
			if (_isDataBufferEnabled)
			{
				if (_deletedProperties != null)
				{
					var index:int = _deletedProperties.indexOf(property);
					if (index != -1)
					{
						return null;
					}
				}
				
				if (_dataBuffer != null && property in _dataBuffer)
				{
					return _dataBuffer[property];
				}
			}
			if (_cookie != null && _cookie.data != null && property in _cookie.data)
			{
				return _cookie.data[property];	
			}
			return defaultValue;
		}
		
		public function hasProperty(property:String):Boolean
		{
			return getProperty(property) != null;
		}

		public function removeProperty(property:String):void
		{
			if (_isDataBufferEnabled)
			{
				if (_deletedProperties == null)
				{ 
					_deletedProperties = new <String>[];
				}
				
				_deletedProperties[_deletedProperties.length] = property;
				
				if (_dataBuffer != null && property in _dataBuffer)
				{
					delete _dataBuffer[property];
					return;
				}
			}
			
			if (_cookie != null && _cookie.data != null)
			{
				delete _cookie.data[property];	
			}
			save();
		}
		
		public function flushDataBuffer():void
		{
			if (_dataBuffer == null || _cookie == null || _cookie.data == null) return;
			
			var data:Object = _cookie.data;
			for (var key:String in _dataBuffer)
			{
				data[key] = _dataBuffer[key];
			}
			
			if (_deletedProperties != null)
			{
				while (_deletedProperties.length > 0)
				{
					var deletedProperty:String = _deletedProperties.pop();
					if (deletedProperty in data)
					{
						delete data[deletedProperty];
					}
				}
				
				_deletedProperties = null;
			}
			
			save();
			_dataBuffer = null;
		}
		
		public function clearDataBuffer():void
		{
			if (_dataBuffer == null) return;
			
			for (var key:* in _dataBuffer)
			{
				delete _dataBuffer[key];
			}
			_dataBuffer = null;
		}
		
		protected function getStringProperty(property:String, defaultValue:String = null):String
		{
			var value:Object = getProperty(property);
			return value != null ? String(value) : null;
		}

		protected function getBooleanProperty(property:String, defaultValue:Boolean = false):Boolean
		{
			var value:Object = getProperty(property);
			return value != null ? Boolean(value) : defaultValue;
		}
		
		protected function getNumberProperty(property:String, defaultValue:Number = 0):Number
		{
			var value:Object = getProperty(property);
			return value != null ? Number(value) : defaultValue;
		}

		protected function deleteProperty(property:String):void
		{
			if (_cookie != null && _cookie.data != null)
			{
				delete _cookie.data[property];
			}
		}
		
		public function get isDataBufferEnabled():Boolean
		{
			return _isDataBufferEnabled;
		}
		
		public function set isDataBufferEnabled(value:Boolean):void
		{
			if (_isDataBufferEnabled == value) return;
			
			_isDataBufferEnabled = value;
			flushDataBuffer();
		}
		
		public function get cacheData():Object
		{
			return _cookie.data;
		}
		
		public function get size():uint
		{
			return _cookie.size;
		}

	}
}