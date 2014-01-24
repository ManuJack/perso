package com.hebdo.manager.event
{
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class RegistrationEvent extends Event
	{
		public static const PLAYER_LIST_RECEIVED:String = "playerListReceived";
		
		private var _players:ListCollection;
		
		public function RegistrationEvent(type:String, players:ListCollection, bubbles:Boolean=false, data:Object=null)
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