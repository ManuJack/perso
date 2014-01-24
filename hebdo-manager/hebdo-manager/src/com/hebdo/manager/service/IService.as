package com.hebdo.manager.service
{
	public interface IService
	{
		function call():IService;
		function get action():String;
		function set definition(value:ServiceDefinition):void;
		function get definition():ServiceDefinition;
		function set data(value:Object):void;
		function get data():Object;
		function set resultCallback(value:Function):void;
		function set errorCallback(value:Function):void;
	}
}