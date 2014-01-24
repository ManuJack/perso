package com.hebdo.manager.vo
{
	public class PlayerRegistration
	{
		public static const NAME				:String = "name";
		public static const FULLNAME			:String = "fullname";
		public static const PARTNER_FULLNAME	:String = "partner_fullname";
		public static const PARTNER_ELO			:String = "partner_elo";
		public static const USER_ID				:String = "user_id";
		public static const ELO					:String = "elo";
		public static const TIME_RESERVED		:String = "time_reserved";
		public static const TOURNAMENT			:String = "tournoi";
		
		private var _data:Object;
		
		private var _name:String;
		private var _fullName:String;
		private var _elo:Number = NaN;
		private var _timeReserved:String;
		private var _tournament:String; //string tournoi
		
		public var isEditMode:Boolean = false;
		
		private var _partner:PlayerRegistration;
		
		public function PlayerRegistration(data:Object, partner:PlayerRegistration = null, isPartner:Boolean = false)
		{
			_data = data;
			
			if (!isPartner)
			{
				_name = data[NAME];
				_elo = data[ELO];
				_fullName = data[FULLNAME];
			}
			else
			{
				_name = data[PARTNER_FULLNAME];
				_elo = data[PARTNER_ELO];
				_fullName = data[PARTNER_FULLNAME];
			}
			_timeReserved = data[TIME_RESERVED];
			_tournament = data[TOURNAMENT];
			
			_partner = partner;
		}

		public function get partner():PlayerRegistration
		{
			return _partner;
		}

		public function get elo():Number
		{
			return _elo;
		}
		
		public function set elo(value:Number):void
		{
			_elo = value;
		}

		public function get name():String
		{
			return _name ? _name : _fullName ? _fullName : "Unknown";
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function isValid():Boolean
		{
			return !isNaN(_elo);
		}
		
		public function clone():PlayerRegistration
		{
			return new PlayerRegistration(_data);
		}

	}
}