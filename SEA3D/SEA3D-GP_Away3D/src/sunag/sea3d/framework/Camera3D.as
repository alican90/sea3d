package sunag.sea3d.framework
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.sea3d.animation.CameraAnimation;
	
	import sunag.sea3dgp;
	import sunag.sea3d.objects.SEACamera;
	import sunag.sea3d.objects.SEAObject;
	
	use namespace sea3dgp;
	
	public class Camera3D extends Object3D
	{				
		public static function getAsset(name:String):sunag.sea3d.framework.Camera3D
		{
			return Object3D.getAsset(name) as sunag.sea3d.framework.Camera3D;
		}
		
		sea3dgp static const NULL:away3d.cameras.Camera3D = new away3d.cameras.Camera3D();
		
		sea3dgp var camera:away3d.cameras.Camera3D;
		sea3dgp var lens:PerspectiveLens;
		
		public function Camera3D()
		{
			super(camera = new away3d.cameras.Camera3D(lens = new PerspectiveLens()), CameraAnimation);
			lens.near = 1;
			lens.far = 6000;
		}
		
		public function setFov(fov:Number):void
		{
			lens.fieldOfView = fov;
		}
		
		public function getFov():Number
		{
			return lens.fieldOfView;
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	CAMERA
			//
			
			var cam:SEACamera = sea as SEACamera;
			
			camera.transform = cam.transform;
			
			lens.fieldOfView = cam.fov;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if (Game.currentCamera == this)
			{
				Game.setCamera( null );
			}
		}
	}
}