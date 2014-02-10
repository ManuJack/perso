package com.hebdo.manager.model
{
	import com.hebdo.manager.event.RegistrationEvent;
	import com.hebdo.manager.service.fooscore.RegistrationListService;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.vo.Player;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import flash.utils.Dictionary;
	
	import feathers.controls.Alert;
	import feathers.data.ListCollection;

	public class RegistrationModel extends BaseModel
	{
		public static const INVALIDATE_DATA:String = "invalidateData";
		
		private var _players:Vector.<PlayerRegistration>;
		private var _playersCollection:ListCollection;
		
		private var _localPlayers:Vector.<PlayerRegistration>;
		
		private var _cache:Dictionary;
		
		private var _currentSession:SessionData;
		
		public function RegistrationModel(config:Config)
		{
			super(config);
		}
		
		public function get playersCollection():ListCollection
		{
			return _playersCollection;
		}

		public function get players():Vector.<PlayerRegistration>
		{
			return _players;
		}

		public function retreiveList(session:SessionData):void
		{
			_currentSession = session;
			
			_playersCollection = getListFromCache(session);
			
			//TODO : Add refresh 
			//for now, if already requested, return the lists
			if (_playersCollection)
			{
				const event:RegistrationEvent = new RegistrationEvent(RegistrationEvent.PLAYER_LIST_RECEIVED, _playersCollection);
				dispatchEvent(event);
				return;
			}
			
			/*_players = getMockedList();
			_playersCollection = new ListCollection(_players);
			const mockedEvent:RegistrationEvent = new RegistrationEvent(RegistrationEvent.PLAYER_LIST_RECEIVED, _playersCollection);
			dispatchEvent(mockedEvent);
			return;*/
			
			var service:RegistrationListService = new RegistrationListService(_config, onResult, onError);
			service.call(session.hebdo.name);
			busy();
		}
		
		private function getListFromCache(session:SessionData):ListCollection
		{
			if (!_cache)
				return null;
			
			return _cache[session.hebdo.name] as ListCollection;
		}
		
		private function saveCache():void
		{
			if (!_cache)
				_cache = new Dictionary();
			_cache[_currentSession.hebdo.name] = _playersCollection;
		}
		
		private function onError(error:Object):void
		{
			notBusyAnymore();
			
			Alert.show(error.toString(), "Error while calling foosballquebec.com", new ListCollection([{label:"OK"}]));
		}
		
		private function onResult(registrations:Vector.<PlayerRegistration>):void
		{
			_players = registrations;
			
			var dataSource:Vector.<PlayerRegistration>;
			if (_localPlayers)
				dataSource = _players.concat(_localPlayers);
			else
				dataSource = _players.concat();
			
			_playersCollection = new ListCollection(dataSource);
			saveCache();
			
			const event:RegistrationEvent = new RegistrationEvent(RegistrationEvent.PLAYER_LIST_RECEIVED, _playersCollection);
			dispatchEvent(event);
			
			notBusyAnymore();
		}
		
		private function getRandomElo():int
		{
			return Math.random() * 1500 + 500
		}
		
		private function getMockedList():Vector.<PlayerRegistration>
		{
			const list:Vector.<PlayerRegistration> = new <PlayerRegistration>[];
			
			var i:uint = 32;
			while (i-- > 0)
			{
				list.push(new PlayerRegistration({name:"Player" + i, elo:getRandomElo()}));
			}
			return list;
		}
		
		public function deletePlayer(player:PlayerRegistration):void
		{
			if (!_players || !_playersCollection)
				return;
			
			var index:int = _playersCollection.getItemIndex(player);
			if (index > -1)
			{
				_playersCollection.removeItemAt(index);
			}
		}
		
		public function addPlayer(name:String, elo:int):void
		{
			if (!_players || !_playersCollection)
				return;
			
			const data:Object = {};
			data[PlayerRegistration.NAME] = name;
			data[PlayerRegistration.ELO] = elo;
			
			const player:PlayerRegistration = new PlayerRegistration(data);
			_playersCollection.addItem(player);
			
			if (!_localPlayers)
				_localPlayers = new Vector.<PlayerRegistration>();
			
			_localPlayers.push(player);
		}
		
		public function replacePlayer(registration:PlayerRegistration, player:Player):void
		{
			if (!_players || !_playersCollection)
				return;
			
			registration.name = player.toString();
			registration.elo = parseInt(player.elo);
			const index:int = _playersCollection.getItemIndex(registration);
			_playersCollection.setItemAt(registration, index);
		}
		
		/**
		 * Set player ELO
		 * Because we want to be able to reset changes, clone instance before setting new value
		 */
		public function setPlayerElo(registration:PlayerRegistration, value:int):void
		{
			const clonedRegistration:PlayerRegistration = registration.clone();
			clonedRegistration.elo = value;
			
			const index:int = _playersCollection.getItemIndex(registration);
			_playersCollection.setItemAt(clonedRegistration, index);
		}
		
		public function validateRegistrations():Boolean
		{
			if (!_players || !_playersCollection)
				return false;
			
			var i:int;
			var registration:PlayerRegistration;
			for (i; i<_players.length; ++i)
			{
				registration = _players[i] as PlayerRegistration;
				if (!registration.isValid())
					return false;
			}
			
			return true;
		}
		
		override public function reset():void
		{
			_localPlayers = null;
			_playersCollection = new ListCollection(_players.concat());
			saveCache();
			
			dispatchEventWith(INVALIDATE_DATA);
		}
		
	}
}