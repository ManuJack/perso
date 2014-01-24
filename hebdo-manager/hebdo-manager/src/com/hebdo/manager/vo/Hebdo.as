package com.hebdo.manager.vo
{
	public class Hebdo
	{
		private var _name:String;
		private var _label:String;
		
		public function Hebdo(name:String, label:String)
		{
			_name = name;
			_label = label;
		}

		public function get name():String
		{
			return _name;
		}
		
		public function get label():String
		{
			return _label;
		}

	}
}