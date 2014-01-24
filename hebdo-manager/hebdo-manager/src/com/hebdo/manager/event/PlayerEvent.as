package com.hebdo.manager.event
{
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class PlayerEvent extends Event
	{
		public static const LIST_RECEIVED:String = "listReceived";
		
		private var _players:ListCollection;
		
		public function PlayerEvent(type:String, players:ListCollection, bubbles:Boolean=false, data:Object=null)
		{
			_players = players;
			
			super(type, bubbles, data);
		}

		public function get players():ListCollection
		{
			return _players;
		}

	}
}