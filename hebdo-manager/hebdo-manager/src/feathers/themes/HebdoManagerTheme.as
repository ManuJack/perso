package feathers.themes
{
	import com.hebdo.manager.component.PlayerRegistrationActionButton;
	import com.hebdo.manager.component.renderer.RegistrationListItemRenderer;
	import com.hebdo.manager.utils.Styles;
	
	import flash.display.Bitmap;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class HebdoManagerTheme extends MetalWorksMobileTheme
	{
		public static var THEME_SCALE:Number;
		
		[Embed(source="/../assets/images/icon_settings.png")]
		private static const SETTINGS_ICON:Class;
		
		private var _settingsIcon:Texture;
		
		public function HebdoManagerTheme(container:DisplayObjectContainer=null, scaleToDPI:Boolean=true)
		{
			super(container, scaleToDPI);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			THEME_SCALE = scale;
			
			_settingsIcon = Texture.fromBitmap(Bitmap(new SETTINGS_ICON()));
			
			setInitializerForClass(RegistrationListItemRenderer, itemRendererInitializer);
			setInitializerForClass(PlayerRegistrationActionButton, dangerButtonInitializer);
			setInitializerForClass(Button, settingsButtonInitializer, Styles.BUTTON_SETTTINGS);
		}
		
		private function settingsButtonInitializer(button:Button):void
		{
			buttonInitializer(button);
			
			const image:ImageLoader = new ImageLoader();
			image.source = _settingsIcon;
			image.textureScale = scale;
			
			button.defaultIcon = image;
		}
	}
}