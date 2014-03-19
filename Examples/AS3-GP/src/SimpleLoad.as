package 
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.loader.SEA3DLoader;
	
	[SWF(width="1024", height="632", backgroundColor="0x333333", frameRate="60")]
	public class SimpleLoad extends Sprite
	{
		public function SimpleLoad()
		{		
			SEA3DGP.init(this);
			
			var loader:SEA3DLoader = new SEA3DLoader("Simple Example");
			loader.load( new URLRequest("../assets/SimpleRun.sea") );
						
			SEA3DGP.addLoader( loader );
		}
	}
}