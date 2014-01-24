package
{
	import com.hebdo.manager.ManagerMain;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import feathers.system.DeviceCapabilities;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	[SWF(width="960", height="640", frameRate="60", backgroundColor="0x000000")]
	public class Main extends Sprite
	{
		public function Main()
		{
			if(this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			this.mouseEnabled = this.mouseChildren = false;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private var _starling:Starling;
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			const isTablet:Boolean = DeviceCapabilities.isTablet(stage);
			const forceIphoneRetina:Boolean = isTablet;
			if (forceIphoneRetina)
			{
				//pretends to be an iPhone Retina screen
				DeviceCapabilities.dpi = 326;
				DeviceCapabilities.screenPixelWidth = 960;
				DeviceCapabilities.screenPixelHeight = 640;
			}
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			this._starling = new Starling(ManagerMain, this.stage);
			this._starling.enableErrorChecking = false;
			_starling.showStats = false;
			//_starling.simulateMultitouch = true;
			this._starling.start();
			
			initGestouch();
			
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		
		private function initGestouch():void
		{
			Gestouch.inputAdapter = new NativeInputAdapter(stage);
			Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());	
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			this._starling.stage.stageWidth = this.stage.stageWidth;
			this._starling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}
		
		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}
	}
}