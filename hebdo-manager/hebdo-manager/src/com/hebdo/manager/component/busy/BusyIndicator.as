package com.hebdo.manager.component.busy
{
	import flash.geom.Rectangle;
	
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.themes.HebdoManagerTheme;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class BusyIndicator extends FeathersControl
	{
		private var _busyIndicator:Quad;
		private var _busyCount:int;
		
		private var _lblLoading:Label;
		
		public function BusyIndicator()
		{
			super();
		}
		
		override protected function initialize():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			_busyIndicator = new Quad(250 * HebdoManagerTheme.THEME_SCALE, 20 * HebdoManagerTheme.THEME_SCALE, 0xFFFFFF )
			_busyIndicator.visible = false
			addChild(_busyIndicator);
			
			_lblLoading = new Label();
			_lblLoading.text = "Loading...";
			addChild(_lblLoading);
		}
		
		private function onRemovedFromStage():void
		{
			notBusy();
		}
		
		override protected function feathersControl_addedToStageHandler(event:Event):void
		{
			super.feathersControl_addedToStageHandler(event);
			
			busy();
		}
		
		override protected function draw():void
		{
			var sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			if (sizeInvalid)
				layoutContent();
		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				clipRect = new Rectangle(0, 0, explicitWidth, explicitHeight);
				return false;
			}
			
			_lblLoading.validate();
			
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = Math.max(_busyIndicator.width, _lblLoading.width);
			}
			
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = _busyIndicator.height + _lblLoading.height;
			}
			
			clipRect = new Rectangle(0, 0, newWidth, newHeight);
			
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		private function layoutContent():void
		{
			_lblLoading.x = (actualWidth * 0.5) - (_lblLoading.width * 0.5);
			_busyIndicator.width = actualWidth;
			_busyIndicator.y = _lblLoading.height;
			
			//trace("BusyIndicator :: layoutContent()");
		}

		public function clearBusy() : void
		{
			_busyCount = 0
			
			notBusy()
		}
		
		public function notBusy() : void
		{
			if( _busyCount > 0 )
				_busyCount--
			
			if( _busyCount != 0 )
				return
			
			Starling.juggler.removeTweens( _busyIndicator )
			
			_busyIndicator.visible = false;
			_busyIndicator.x = -_busyIndicator.width;
			_busyIndicator.alpha = 1;
		}
		
		public function busy() : void
		{
			_busyCount++
			
			if(_busyIndicator.visible)
				return
			
			_busyIndicator.visible = true;
			_busyIndicator.x = -_busyIndicator.width;
			
			Starling.juggler.tween( _busyIndicator, 1.3, {
				transition  : Transitions.EASE_IN_OUT,
				delay       : 0,
				repeatCount : 100000,
				x           : width,
				alpha       : 0
			} )
		}
	}
}