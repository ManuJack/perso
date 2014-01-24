package com.hebdo.manager.event
{
	import starling.events.Event;
	
	public class DrawEvent extends Event
	{
		public static const DRAW_COMPLETE:String = "drawComplete";
		
		public function DrawEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}