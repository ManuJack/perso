package com.hebdo.manager.service
{
	public class ServiceDefinition
	{
		private var _action:String;
		private var _params:Array;
		
		public function ServiceDefinition(action:String, params:Array)
		{
			_action = action;
			_params = params;
		}

		public function get action():String
		{
			return _action;
		}

		public function buildServiceParams(...parameters):Object
		{
			if (!_params || _params.length != parameters.length)
				throw new Error("buildServiceParams() parameters doesn't match the number of services params!");
				
			var serviceParams:Object = {};
			var paramValue:*;
			var index:int;
			var paramName:String;
			for each (paramValue in parameters)
			{
				paramName = _params[index] as String;
				serviceParams[paramName] = paramValue;
				++index;
			}
			return serviceParams;
		}
		
		public function toString():String
		{
			return "[ServiceDefinition " + _action + "]";
		}
		
	}
}