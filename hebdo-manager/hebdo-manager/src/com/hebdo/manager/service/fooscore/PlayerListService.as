package com.hebdo.manager.service.fooscore
{
	import com.hebdo.manager.service.FoosCoreServices;
	import com.hebdo.manager.service.IService;
	import com.hebdo.manager.service.JsonService;
	import com.hebdo.manager.service.ServiceDefinition;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.vo.Player;

	public class PlayerListService
	{
		private var _config:Config;
		
		private var _resultCallBack:Function;
		private var _errorCallBack:Function;
		
		public function PlayerListService(config:Config, resultCallBack:Function, errorCallBack:Function)
		{
			_config = config;
			_resultCallBack = resultCallBack;
			_errorCallBack = errorCallBack;
		}
		
		public function call(hebdoName:String):void
		{
			const definition:ServiceDefinition = FoosCoreServices.PLAYER_LIST;
			
			const service:JsonService = new JsonService(_config.gateway);
			service.definition = definition;
			service.data = definition.buildServiceParams(hebdoName);
			service.resultCallback = onResult;
			service.errorCallback = onError;
			service.call();
		}
		
		private function onResult(service:IService, result:Object):void
		{
			const results:Vector.<Player> = parseResult(result);
			_resultCallBack(results);
		}
		
		private function parseResult(result:Object):Vector.<Player>
		{
			const results:Vector.<Player> = new Vector.<Player>();
			const players:Array = result as Array;
			if (players)
			{
				var i:int;
				for (i; i<players.length; ++i)
				{
					results.push(new Player(players[i]));
				}
			}
			
			return results;
		}
		
		private function onError(service:IService, error:Object):void
		{
			trace("error", error);
			_errorCallBack(error);
		}
	}
}