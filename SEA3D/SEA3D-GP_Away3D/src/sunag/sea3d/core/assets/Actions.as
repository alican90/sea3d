package sunag.sea3d.core.assets
{
	import sunag.sea3dgp;
	import sunag.sea3d.framework.Asset;
	import sunag.sea3d.framework.Game;
	import sunag.sea3d.objects.SEAAction;
	import sunag.sea3d.objects.SEAObject;
	
	use namespace sea3dgp;
	
	public class Actions extends Asset
	{
		public static const TYPE:String = 'Actions/'; 
		
		public static function getAsset(name:String):Actions
		{
			return Asset.getAsset(name) as Actions;
		}
		
		public function Actions()
		{
			super(TYPE);
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	ABC
			//
			
			for each(var act:Object in SEAAction(sea).action)
			{
				switch (act.kind)
				{					
					case SEAAction.LOOK_AT:
						//act.source.tag.controller = new LookAtController(act.target.tag);		
						break;
					
					case SEAAction.RTT_TARGET:				
						//act.source.tag.target = act.target.tag;						
						break;
					
					case SEAAction.FOG:			
						Game.setFog( act.color );
						Game.setFogMin( act.min );
						Game.setFogMax( act.max ); 					
						break;
					
					case SEAAction.ENVIRONMENT:
						Game.setEnvironment( act.texture.tag );												
						break;
					
					case SEAAction.ENVIRONMENT_COLOR:
						Game.setEnvironmentColor( act.color );		
						break;
					
					case SEAAction.CAMERA:
						Game.setCamera( act.camera.tag );	
						break;
				}
			}
		}
	}
}