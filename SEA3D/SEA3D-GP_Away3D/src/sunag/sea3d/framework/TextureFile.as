package sunag.sea3d.framework
{
	import away3d.textures.AsynBitmapTexture;
	
	import sunag.sea3dgp;
	import sunag.sea3d.objects.SEAObject;
	
	use namespace sea3dgp;
	
	public class TextureFile extends Texture
	{
		sea3dgp var bitmapTex:AsynBitmapTexture;		
		
		public static function getAsset(name:String):TextureFile
		{
			return Texture.getAsset(name) as TextureFile;
		}
		
		public function TextureFile()
		{
			super(bitmapTex = new AsynBitmapTexture());			
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	TEXTURE FILE
			//
			
			bitmapTex.load(sea.data);			
		}
		
		//
		//	PUBLIC
		//
		
		public function loadURL(url:String):void
		{
			bitmapTex.load(url);
		}
	}
}