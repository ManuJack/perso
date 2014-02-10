package com.hebdo.manager.model
{
	import com.hebdo.manager.utils.SessionData;
	import com.hebdo.manager.utils.net.ShareObjectData;
	import com.hebdo.manager.vo.Player;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	public class PlayersEloAssociationModel
	{
		private static const CACHE_KEY:String = "-association";
		
		private var _data:ShareObjectData;
		private var _sessionData:SessionData;
		
		public function PlayersEloAssociationModel(sessionData:SessionData)
		{
			_sessionData = sessionData;
			_data = sessionData.sharedObject;
			_data.isDataBufferEnabled = false;
		}
		
		public function getPlayerRegistrationElo(playerRegistration:PlayerRegistration):Number
		{
			var cacheKey:String = getCacheKey();
			if (!_data.hasProperty(cacheKey))
				return NaN;
			
			var associations:Object = _data.getProperty(cacheKey);
			var player:Object = associations[playerRegistration.name];
			if (player)
			{
				trace("Found player in cache for", playerRegistration.name);
				return player.elo;
			}
			
			return NaN;
		}
		
		public function setPlayerRegistrationElo(playerRegistration:PlayerRegistration, player:Player):void
		{
			var cacheKey:String = getCacheKey();
			
			var associations:Object = _data.getProperty(cacheKey);
			if (!associations)
				associations = {};
			
			associations[playerRegistration.name] = player;
			
			_data.setProperty(cacheKey, associations);
			trace("Setting cache for player", playerRegistration.name, player.elo);
		}
		
		protected function getCacheKey():String
		{
			return  _sessionData.hebdo.name + CACHE_KEY;
		}
	}
}