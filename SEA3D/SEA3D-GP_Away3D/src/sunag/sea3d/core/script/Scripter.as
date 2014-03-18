package sunag.sea3d.core.script
{
	import sunag.sea3dgp;
	import sunag.sea3d.core.IGameObject;

	use namespace sea3dgp;
	
	public class Scripter
	{
		sea3dgp var scope:IGameObject;		
				
		public function Scripter(scope:IGameObject)
		{
			sea3dgp::scope = scope;
		}
	}
}