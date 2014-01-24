package com.hebdo.manager.event
{
	import starling.events.Event;
	
	public class BusyEvent extends Event
	{
		public static const BUSY				:String = "busy";
		public static const NOT_BUSY_ANYMORE	:String = "notBusyAnymore";
		
		public function BusyEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}