package com.hebdo.manager
{
	import com.hebdo.manager.component.HebdoRegistrationMenu;
	import com.hebdo.manager.model.HebdoModel;
	import com.hebdo.manager.model.PlayerModel;
	import com.hebdo.manager.model.RegistrationModel;
	import com.hebdo.manager.model.draw.DrawModel;
	import com.hebdo.manager.model.draw.impl.DYPPlayerDrawer;
	import com.hebdo.manager.screen.AddPlayerListScreen;
	import com.hebdo.manager.screen.AddPlayerScreen;
	import com.hebdo.manager.screen.BaseScreen;
	import com.hebdo.manager.screen.DrawScreen;
	import com.hebdo.manager.screen.HomeScreen;
	import com.hebdo.manager.screen.PoolScreen;
	import com.hebdo.manager.screen.RegistrationScreen;
	import com.hebdo.manager.utils.Config;
	import com.hebdo.manager.utils.Screens;
	import com.hebdo.manager.utils.SessionData;
	
	import feathers.controls.Drawers;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.OldFadeNewSlideTransitionManager;
	import feathers.themes.HebdoManagerTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ManagerMain extends Sprite
	{
		private var _sessionData:SessionData;
		
		/**
		 * TODO : Externalize config 
		 */
		private const _config:Config = new Config();
		
		private const _hebdoModel:HebdoModel = new HebdoModel(_config);
		private const _playerModel:PlayerModel = new PlayerModel(_config);
		private const _registrationModel:RegistrationModel = new RegistrationModel(_config);
		private const _drawModel:DrawModel = new DrawModel(_config);
		
		//private var _addPlayerListScreen:AddPlayerListScreen = new AddPlayerListScreen();
		
		private var _navigator:ScreenNavigator;
		private var _transitionManager:OldFadeNewSlideTransitionManager;
		
		private var _hebdoMenu:HebdoRegistrationMenu;

		private var _drawers:Drawers;
		
		public function ManagerMain()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, initializeHandler);
		}
		
		private function initializeHandler(event:Event):void
		{
			new HebdoManagerTheme();
			
			_navigator = new ScreenNavigator();
			
			initSessionData();
			intializeNavigatorScreens();
			initializeDrawer();
			
			_transitionManager = new OldFadeNewSlideTransitionManager(_navigator);
			
			_navigator.showScreen(Screens.HOME_SCREEN);
			
			_hebdoMenu.session = _sessionData;
			_hebdoMenu.registrationModel = _registrationModel;
		}
		
		private function initializeDrawer():void
		{
			_hebdoMenu = new HebdoRegistrationMenu();
			
			_drawers = new Drawers();
			_drawers.content = _navigator;
			_drawers.leftDrawer = _hebdoMenu;
			_drawers.leftDrawerToggleEventType = RegistrationScreen.OPEN_MENU;
			_drawers.leftDrawerDockMode = Drawers.DOCK_MODE_NONE;
			_drawers.openGesture = Drawers.OPEN_GESTURE_NONE;
			_drawers.autoSizeMode = Drawers.AUTO_SIZE_MODE_STAGE;
			addChild(_drawers);
		}
		
		private function intializeNavigatorScreens():void
		{
			_navigator.addScreen(Screens.HOME_SCREEN, createNavigatorItem(HomeScreen, null, Screens.PLAYER_SCREEN));
			
			const playerNavigatorItem:ScreenNavigatorItem = createNavigatorItem(RegistrationScreen, Screens.HOME_SCREEN, Screens.DRAW_SCREEN);
			playerNavigatorItem.events[RegistrationScreen.ADD_PLAYER] = Screens.ADD_PLAYER_SCREEN;
			playerNavigatorItem.events[AddPlayerScreen.GOTO_ADD_PLAYER_LIST] = Screens.ADD_PLAYER_LIST_SCREEN;
			_navigator.addScreen(Screens.PLAYER_SCREEN, playerNavigatorItem);

			_navigator.addScreen(Screens.DRAW_SCREEN, createNavigatorItem(DrawScreen, Screens.PLAYER_SCREEN, Screens.POOL_SCREEN));
			_navigator.addScreen(Screens.POOL_SCREEN, createNavigatorItem(PoolScreen, Screens.DRAW_SCREEN));
			
			const addPlayerItem:ScreenNavigatorItem = createNavigatorItem(AddPlayerScreen, Screens.PLAYER_SCREEN);
			addPlayerItem.events[AddPlayerScreen.GOTO_ADD_PLAYER_LIST] = Screens.ADD_PLAYER_LIST_SCREEN;
			_navigator.addScreen(Screens.ADD_PLAYER_SCREEN, addPlayerItem);
			
			//const addPlayerListItem:ScreenNavigatorItem = createNavigatorItem(_addPlayerListScreen, Screens.ADD_PLAYER_SCREEN);
			const addPlayerListItem:ScreenNavigatorItem = createNavigatorItem(AddPlayerListScreen, Screens.ADD_PLAYER_SCREEN);
			addPlayerListItem.events[AddPlayerListScreen.PLAYER_ADDED] = Screens.PLAYER_SCREEN;
			_navigator.addScreen(Screens.ADD_PLAYER_LIST_SCREEN, addPlayerListItem);
		}
		
		private function createNavigatorItem(screen:*, previousScreenName:String = null, nextScreenName:String = null):ScreenNavigatorItem
		{
			const events:Object = {};
			
			if (previousScreenName)
				events[BaseScreen.BACK] = previousScreenName;
			
			if (nextScreenName)
				events[BaseScreen.NEXT] = nextScreenName;
			
			const properties:Object = {sessionData: _sessionData, hebdoModel:_hebdoModel, playerModel:_playerModel, drawModel:_drawModel, registrationModel:_registrationModel};
			
			return new ScreenNavigatorItem(screen, events, properties);
		}
		
		private function initSessionData():void
		{
			_sessionData = new SessionData();
			
			_sessionData.sharedObject.init();
		}

	}
}

