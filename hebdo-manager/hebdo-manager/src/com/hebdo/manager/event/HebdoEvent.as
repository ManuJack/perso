package com.hebdo.manager.event
{
	import com.hebdo.manager.vo.Hebdo;
	
	import starling.events.Event;
	
	public class HebdoEvent extends Event
	{
		public static const HEBDO_LIST_RECEIVED:String = "hebdoListReceived";
		
		private var _hebdos:Vector.<Hebdo>;
		
		public function HebdoEvent(type:String, hebdos:Vector.<Hebdo>, bubbles:Boolean=false, data:Object=null)
		{
			_hebdos = hebdos;
			super(type, bubbles, data);
		}

		public function get hebdos():Vector.<Hebdo>
		{
			return _hebdos;
		}

	}
}