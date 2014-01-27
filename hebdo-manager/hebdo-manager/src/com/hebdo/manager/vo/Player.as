package com.hebdo.manager.vo
{
	public class Player
	{
		public static const FIRSTNAME		:String = "prenom";
		public static const LASTNAME		:String = "nom";
		public static const ELO				:String = "classement";
		
		private var _data:Object;
		
		private var _firstname:String;
		private var _lastname:String;
		private var _elo:Number;
		
		public function Player(data:Object)
		{
			_data = data;
			
			_firstname = data[FIRSTNAME];
			_lastname = data[LASTNAME];
			_elo = data[ELO];
		}

		public function get firstname():String
		{
			return _firstname;
		}

		public function get lastname():String
		{
			return _lastname;
		}

		public function get elo():String
		{
			if (isNaN(_elo) || !_elo)
				return "";
			
			return _elo.toString();
		}
		
		public function toString():String
		{
			if (_lastname)
				return _firstname + " " + _lastname;
			return _firstname;
		}

	}
}