package com.hebdo.manager.component.renderer
{
	import com.hebdo.manager.component.PlayerRegistrationActionButton;
	import com.hebdo.manager.vo.PlayerRegistration;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class RegistrationListItemRenderer extends DefaultListItemRenderer
	{
		public static var DEFAULT_ELO:int = 800;
		
		private var _swipeGesture:SwipeGesture;
		
		private var _btnDelete:Button;
		
		/**
		 * Action button displayed when player registration is invalid (NaN)
		 */
		private var _btnAction:PlayerRegistrationActionButton;
		
		public function RegistrationListItemRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_swipeGesture = new SwipeGesture(this);
			_swipeGesture.direction = SwipeGestureDirection.HORIZONTAL;
			_swipeGesture.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipeGesture);
		}
		
		override protected function commitData():void
		{
			super.commitData();
			
			refreshActionButton();
			refreshDeleteButton();
		}
		
		private function refreshActionButton():void
		{
			const playerRegistration:PlayerRegistration = PlayerRegistration(data);
			
			if (!playerRegistration.isValid())
			{
				if (!_btnAction)
				{
					_btnAction = new PlayerRegistrationActionButton();
					_btnAction.addEventListener(PlayerRegistrationActionButton.SELECT_PLAYER, onSelectPlayer);
					_btnAction.addEventListener(PlayerRegistrationActionButton.SET_DEFAULT_ELO, onSetDefaultElo);
				}
				
				if (!_btnAction.stage)
					addChild(_btnAction);
				
				if (accessory)
					accessory.visible = false;
				
				layoutActionButton();
			}
			else if (_btnAction && _btnAction.stage)
			{
				removeChild(_btnAction);
				
				if (accessory)
					accessory.visible = true;
			}
			
		}
		
		private function onSetDefaultElo(event:Event):void
		{
			dispatchEventWith(event.type, true, {elo:DEFAULT_ELO, registration:data});
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private function onSelectPlayer(event:Event):void
		{
			dispatchEventWith(event.type, true, data);
		}
		
		private function refreshDeleteButton(useEffect:Boolean = false):void
		{
			var tween:Tween;
			
			const isEditMode:Boolean = PlayerRegistration(data).isEditMode;
			const showActionBtn:Boolean = !PlayerRegistration(data).isValid();
			
			if (isEditMode)	
			{
				
				//remove action button if displayed
				if (_btnAction && _btnAction.stage)
					removeChild(_btnAction);
					
				if (accessory)
					accessory.visible = false;
				
				if (!_btnDelete)
				{
					_btnDelete = new Button();
					_btnDelete.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
					_btnDelete.label = "Delete";
					_btnDelete.addEventListener(Event.TRIGGERED, onBtnDeleteTriggered);
				}
				addChild(_btnDelete);
				
				layoutEditMode();
				
				if (useEffect)
				{
					_btnDelete.alpha = 0;
					tween = new Tween(_btnDelete, 0.5);
					tween.fadeTo(1);
					Starling.juggler.add(tween);
				}
				else
				{
					_btnDelete.alpha = 1;
				}
				
			}
			else
			{
				if (_btnDelete && _btnDelete.stage)
				{
					if (useEffect)
					{
						tween = new Tween(_btnDelete, 0.2);
						tween.fadeTo(0);
						tween.onComplete = onHideTweenComplete;
						Starling.juggler.add(tween);
					}
					else
					{
						onHideTweenComplete();	
					}
				}
				
				//put back action button
				if (showActionBtn && _btnAction)
					addChild(_btnAction);
			}
		}
		
		private function onHideTweenComplete():void
		{
			if (_btnDelete.stage)
				removeChild(_btnDelete);
			
			if (accessory)
				accessory.visible = true;
		}
		
		private function onBtnDeleteTriggered():void
		{
			owner.dispatchEventWith("delete", true, data);
		}
		
		protected function onSwipeGesture(event:GestureEvent):void
		{
			if (!data)
				return;
			
			PlayerRegistration(data).isEditMode = !PlayerRegistration(data).isEditMode;
			refreshDeleteButton(true);
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override protected function layoutContent():void
		{
			super.layoutContent();
			
			layoutEditMode();
			layoutActionButton();
		}
		
		private function layoutEditMode():void
		{
			if (!_btnDelete || !_btnDelete.stage)
				return;
			
			_btnDelete.validate();
			_btnDelete.y = (actualHeight * 0.5) - (_btnDelete.height * 0.5);
			_btnDelete.x = actualWidth - _btnDelete.width - (actualWidth * 0.01);
		}
		
		private function layoutActionButton():void
		{
			if (!_btnAction || !_btnAction.stage)
				return;
			
			_btnAction.validate();
			_btnAction.y = (actualHeight * 0.5) - (_btnAction.height * 0.5);
			_btnAction.x = actualWidth - _btnAction.width - (actualWidth * 0.01);
		}
	}
}