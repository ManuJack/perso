package com.hebdo.manager.service.fooscore
{
	import com.hebdo.manager.event.RegistrationEvent;
	import com.hebdo.manager.service.FoosCoreServices;
	import com.hebdo.manager.service.IService;
	import com.hebdo.manager.service.JsonService;
	import com.hebdo.manager.service.ServiceDefinition;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import feathers.data.ListCollection;

	public class RegistrationListService
	{
		private var _config:Config;
		
		private var _resultCallBack:Function;
		private var _errorCallBack:Function;
		
		public function RegistrationListService(config:Config, resultCallBack:Function, errorCallBack:Function)
		{
			_config = config;
			_resultCallBack = resultCallBack;
			_errorCallBack = errorCallBack;
		}
		
		public function call(hebdoName:String):void
		{
			const definition:ServiceDefinition = FoosCoreServices.REGISTRATION_LIST;
			
			const service:JsonService = new JsonService(_config.gateway);
			service.definition = definition;
			service.data = definition.buildServiceParams(hebdoName);
			service.resultCallback = onResult;
			service.errorCallback = onError;
			service.call();
		}
		
		private function onResult(service:IService, result:Object):void
		{
			const registrations:Vector.<PlayerRegistration> = parseResult(result);
			_resultCallBack(registrations);
		}
		
		private function parseResult(result:Object):Vector.<PlayerRegistration>
		{
			const results:Vector.<PlayerRegistration> = new Vector.<PlayerRegistration>();
			const players:Array = result as Array;
			if (players)
			{
				var playerData:Object;
				var i:int;
				for (i; i<players.length; ++i)
				{
					playerData = players[i];
					//create another PlayerRegistration in case of a partner ( OPEN DOUBLE )
					if (playerData[PlayerRegistration.PARTNER_FULLNAME] != null && playerData[PlayerRegistration.PARTNER_FULLNAME] != "")
					{
						var partnerRegistration:PlayerRegistration = new PlayerRegistration(playerData, null, true);
						results.push(partnerRegistration);
						results.push(new PlayerRegistration(playerData, partnerRegistration));
					}
					else
					{
						results.push(new PlayerRegistration(playerData));
					}
				}
			}
			
			if (results.length == 0)
				results.push(new PlayerRegistration({name:"No players subscribed yet!", elo:1}));
			
			return results;
		}
		
		private function onError(service:IService, error:Object):void
		{
			trace("error", error);
			_errorCallBack(error);
		}
		
	}
}