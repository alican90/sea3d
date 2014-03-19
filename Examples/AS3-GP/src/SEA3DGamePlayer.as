package 
{
	import flash.display.Sprite;
	import flash.net.FileFilter;
	
	import sunag.player.PlayerEvent;
	import sunag.player.SEA3DLogo;
	import sunag.player.UploadButton;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.loader.SEA3DLoader;
	
	[SWF(width="1024", height="632", backgroundColor="0x333333", frameRate="60")]
	public class SEA3DGamePlayer extends Sprite
	{
		private var uploadButton:UploadButton;
		private var sea3dLogo:SEA3DLogo;
		
		public function SEA3DGamePlayer()
		{							
			SEA3DGP.init(this);
			
			addChild( uploadButton = new UploadButton() );
			uploadButton.x = uploadButton.y = 20;
			uploadButton.buttonMode = true;
			uploadButton.fileFilter = [new FileFilter("Sunag Entertainment Assets (*.sea)","*.sea")];
			uploadButton.addEventListener(PlayerEvent.UPLOAD, onUpload);
			
			addChild( sea3dLogo = new SEA3DLogo() );
		}
		
		private function onUpload(e:PlayerEvent):void
		{
			SEA3DGP.unload();
			
			if (sea3dLogo)
			{
				removeChild( sea3dLogo );
				sea3dLogo = null;
			}
			
			var sea3d:SEA3DLoader = new SEA3DLoader();
			sea3d.loadBytes( uploadButton.data );
			
			SEA3DGP.addLoader( sea3d );
		}
	}
}