package com.hebdo.manager.utils.net.event
{
	import flash.events.Event;
	
	public class ShareObjectDataEvent extends Event
	{
		public static const INTIALIZE_COMPLETED			:String = "initializeCompleted";
		public static const SAVE_COMPLETED				:String = "saveCompleted";
		public static const SAVE_ERROR					:String = "saveError";
		
		public function ShareObjectDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ShareObjectDataEvent(type, bubbles, cancelable);
		}
	}
}