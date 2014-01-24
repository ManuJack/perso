package com.hebdo.manager.utils
{
	import com.hebdo.manager.vo.Hebdo;
	import com.hebdo.manager.vo.PlayerRegistration;

	public class SessionData
	{
		private var _hebdo:Hebdo;
		private var _players:Vector.<PlayerRegistration>;
		private var _useMedian:Boolean;
		
		public function SessionData()
		{
		}

		public function get useMedian():Boolean
		{
			return _useMedian;
		}

		public function set useMedian(value:Boolean):void
		{
			_useMedian = value;
		}

		public function get players():Vector.<PlayerRegistration>
		{
			return _players;
		}

		public function set players(value:Vector.<PlayerRegistration>):void
		{
			_players = value;
		}

		public function get hebdo():Hebdo
		{
			return _hebdo;
		}

		public function set hebdo(value:Hebdo):void
		{
			_hebdo = value;
		}
		
		public function getHebdoSession():HebdoSessionData
		{
			if (!_hebdo)
				return null;
			
			return new HebdoSessionData();
		}
		
	}
}