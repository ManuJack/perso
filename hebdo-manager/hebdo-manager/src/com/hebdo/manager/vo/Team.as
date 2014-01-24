package com.hebdo.manager.vo
{
	/**
	 * Represent a team, can be one or two players
	 */
	public class Team
	{
		public static const POOL_A:String = "A";
		public static const POOL_B:String = "B";
		
		private var _seed:int;
		private var _poolId:String;
		
		private var _player1:PlayerRegistration;
		private var _player2:PlayerRegistration;
		
		public function Team(player1:PlayerRegistration, player2:PlayerRegistration = null)
		{
			_player1 = player1;
			_player2 = player2;
		}

		public function get poolId():String
		{
			return _poolId;
		}

		public function set poolId(value:String):void
		{
			_poolId = value;
		}

		public function get seed():int
		{
			return _seed;
		}

		public function set seed(value:int):void
		{
			_seed = value;
		}

		public function get player2():PlayerRegistration
		{
			return _player2;
		}

		public function get player1():PlayerRegistration
		{
			return _player1;
		}
		
		public function get totalElo():int
		{
			if (_player2)
				return _player1.elo + _player2.elo;
			else
				return _player1.elo;
		}
		
		public function toString():String
		{
			if (_player2)
				return _poolId + seed.toString() + " Total: " + totalElo + "\n" + _player1.name + " - " + _player1.elo + "\n" + _player2.name + " - " + player2.elo;
			else
				return _poolId + seed.toString() + "\n" + _player1.name + " - " + _player1.elo;
		}

	}
}