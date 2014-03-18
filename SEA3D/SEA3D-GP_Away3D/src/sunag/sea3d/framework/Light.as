package sunag.sea3d.framework
{
	import away3d.lights.LightBase;
	
	import sunag.sea3dgp;

	use namespace sea3dgp;
	
	public class Light extends Object3D
	{
		public static function getAsset(name:String):Light
		{
			return Object3D.getAsset(name) as Light;
		}		
		
		sea3dgp var light:LightBase;
		
		public function Light(scope:LightBase, animatorClass:Class=null)
		{
			super(light = scope, animatorClass);
			
			var lights:Array = Game.lightPicker.lights;
			lights.push( light );			
			Game.lightPicker.lights = lights;
		}
		
		public function setShadow(enabled:Boolean):void
		{			
				
		}
		
		public function getShadow():Boolean
		{
			return false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			var lights:Array = Game.lightPicker.lights;
			lights.splice( light, 1 );	
			
			Game.lightPicker.lights = lights;
		}
	}
}