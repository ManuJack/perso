package com.hebdo.manager.model
{
	import com.hebdo.manager.event.BusyEvent;
	import com.hebdo.manager.utils.Config;
	
	import starling.events.EventDispatcher;

	public class BaseModel extends EventDispatcher
	{
		public static const SYNCH_COMPLETE:String = "synchComplete";
		
		protected var _config:Config;
		
		public function BaseModel(config:Config)
		{
			_config = config;
		}
		
		public function reset():void
		{
			
		}
		
		protected function busy():void
		{
			dispatchEventWith(BusyEvent.BUSY);
		}
		
		protected function notBusyAnymore():void
		{
			dispatchEventWith(BusyEvent.NOT_BUSY_ANYMORE);
		}
			
	}
}