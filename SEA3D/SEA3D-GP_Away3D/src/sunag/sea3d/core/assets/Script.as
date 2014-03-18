package sunag.sea3d.core.assets
{
	import sunag.sea3dgp;
	import sunag.sea3d.framework.Asset;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.events.Event;
	import sunag.sea3d.core.IGameObject;
	import sunag.sea3d.core.script.Scripter;

	use namespace sea3dgp;
	
	public class Script extends Asset		
	{
		public static const TYPE:String = 'Script/'; 
		
		public static function getAsset(name:String):Script
		{
			return Asset.getAsset(name) as Script;
		}
		
		sea3dgp var LOCAL:Object = {};
		
		public function Script()
		{
			super(TYPE);
			
			SEA3DGP.scripts.push( this );
		}
		
		public function get local():Object
		{
			return LOCAL;
		}
		
		public function run(scripter:Scripter):void
		{			
		}
		
		public function event(objects:Vector.<IGameObject>, e:Event):void
		{
			
		}
		
		override public function dispose():void
		{
			SEA3DGP.scripts.splice( SEA3DGP.scripts.indexOf(this), 1 );
			
			super.dispose();
		}
	}
}