package sunag.sea3d.core.script
{
	import sunag.sea3dgp;
	import sunag.sea3d.core.IGameObject;

	use namespace sea3dgp;
	
	public class ScripterABC extends Scripter
	{
		sea3dgp var method:String;
		sea3dgp var params:Object;
		
		public function ScripterABC(scope:IGameObject, method:String, params:Object=null)
		{
			super(scope);
			
			sea3dgp::method = method;
			sea3dgp::params = params;
		}				
	}
}