package sunag.sea3d.engine
{
	import flash.display3D.Context3DProfile;
	
	import sunag.sea3dgp;

	use namespace sea3dgp;
	
	public class Config
	{
		sea3dgp var autoPlay:Boolean; 		
		sea3dgp var antiAlias:int;
		sea3dgp var profile:String;
		sea3dgp var shaderPicker:Boolean;
		
		sea3dgp var worker:Boolean;
		
		public function Config(autoPlay:Boolean=true, antiAlias:int=4, profile:String=Context3DProfile.BASELINE_EXTENDED, shaderPicker:Boolean=false)
		{
			sea3dgp::autoPlay = autoPlay;
			sea3dgp::antiAlias = antiAlias;
			sea3dgp::profile = profile; 
			sea3dgp::shaderPicker = shaderPicker;
		}
	}
}