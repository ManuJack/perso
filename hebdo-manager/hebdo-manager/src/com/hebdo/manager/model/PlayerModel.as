package com.hebdo.manager.model
{
	import com.hebdo.manager.event.PlayerEvent;
	import com.hebdo.manager.service.fooscore.PlayerListService;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.vo.Player;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import flash.utils.Dictionary;
	
	import feathers.data.ListCollection;
	
	public class PlayerModel extends BaseModel
	{
		private var _players:Vector.<Player>;
		private var _playersCollection:ListCollection;
		
		private var _cache:Dictionary;
		private var _currentSession:SessionData;
		
		private var _replacePlayerRegistration:PlayerRegistration;
		
		public function PlayerModel(config:Config)
		{
			super(config);
		}
		
		public function get players():Vector.<Player>
		{
			return _players;
		}

		public function get playersCollection():ListCollection
		{
			return _playersCollection;
		}

		public function get replacePlayerRegistration():PlayerRegistration
		{
			return _replacePlayerRegistration;
		}

		public function set replacePlayerRegistration(value:PlayerRegistration):void
		{
			_replacePlayerRegistration = value;
		}

		public function retreiveList(session:SessionData):void
		{
			_currentSession = session;
			
			_playersCollection = getListFromCache(session);
			
			if (_playersCollection)
			{
				const event:PlayerEvent = new PlayerEvent(PlayerEvent.LIST_RECEIVED, _playersCollection);
				dispatchEvent(event);
				return;
			}
			
			var service:PlayerListService = new PlayerListService(_config, onResult, onError);
			service.call(session.hebdo.name);
			busy();
		}
		
		private function getListFromCache(session:SessionData):ListCollection
		{
			if (!_cache)
				return null;
			
			return _cache[session.hebdo.name] as ListCollection;
		}
		
		private function onError(error:Object):void
		{
			trace("error", error);
			notBusyAnymore();
		}
		
		private function onResult(results:Vector.<Player>):void
		{
			_players = results;
			_playersCollection = new ListCollection(_players);
			
			if (!_cache)
				_cache = new Dictionary();
			_cache[_currentSession.hebdo.name] = _playersCollection;
			
			const event:PlayerEvent = new PlayerEvent(PlayerEvent.LIST_RECEIVED, _playersCollection);
			dispatchEvent(event);
			
			notBusyAnymore();
		}
		
		override public function reset():void
		{
			_cache = null;
		}
	}
}