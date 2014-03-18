package sunag.sea3d.framework
{
	import away3d.materials.SkyBoxMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FogMethod;
	import away3d.primitives.SkyBox;
	
	import sunag.sea3dgp;
	import sunag.sea3d.core.IGameObject;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.engine.SEA3DGPEvent;

	use namespace sea3dgp;
	
	public class Game
	{
		sea3dgp static var environment:CubeMap;
		sea3dgp static var currentCamera:Camera3D;
		
		sea3dgp static var fog:FogMethod;
		sea3dgp static var skyBox:SkyBox;
		sea3dgp static var focus:IGameObject;
		sea3dgp static var lightPicker:StaticLightPicker = new StaticLightPicker([]);	
		sea3dgp static var shadowLight:DirectionalLight; 
		
		public static function setCamera(camera:Camera3D):void
		{
			if (currentCamera = camera)
			{
				SEA3DGP.view3d.camera = currentCamera.camera;
			}
			else
			{
				SEA3DGP.view3d.camera = Camera3D.NULL;
			}
		}
		
		public static function getCamera():Camera3D
		{
			return currentCamera;
		}
		
		public static function setFocus(object:IGameObject):void
		{
			focus = object;
		}
		
		public static function getFocus():IGameObject
		{
			return focus;
		}
		
		public static function setFog(color:*):void
		{
			if (color == null) 
			{
				if (fog)
				{
					fog.dispose();
					fog = null;
					
					SEA3DGP.events.dispatchEvent(new SEA3DGPEvent(SEA3DGPEvent.INVALIDATE_MATERIAL));
				}
			}
			else if (!fog) 
			{
				fog = new FogMethod(100, 1000, color);
				
				SEA3DGP.events.dispatchEvent(new SEA3DGPEvent(SEA3DGPEvent.INVALIDATE_MATERIAL));
			}
			else fog.fogColor = color;
		}
		
		public static function getFog():*
		{
			return fog != null;
		}
		
		public static function setFogMin(min:Number):void
		{
			fog.minDistance = min;
		}
		
		public static function getFogMin():Number
		{
			return fog.minDistance;
		}
		
		public static function setFogMax(min:Number):void
		{
			fog.maxDistance = min;
		}
		
		public static function getFogMax():Number
		{
			return fog.maxDistance;
		}
		
		public static function setEnvironment(cube:CubeMap):void
		{
			if (environment = cube)
			{
				if (!skyBox) 
				{
					skyBox = new SkyBox( cube.scope );
					SEA3DGP.scene.addChild( skyBox );
				}
				else SkyBoxMaterial(skyBox.material).cubeMap = cube.scope;
			}
			else if (skyBox)
			{
				skyBox.dispose();
				skyBox = null;				
			}
		}
		
		public static function getEnvironment():CubeMap
		{
			return environment;
		}
		
		public static function setEnvironmentColor(color:Number):void
		{
			SEA3DGP.view3d.backgroundColor = color;
		}
		
		public static function getEnvironmentColor():Number
		{
			return SEA3DGP.view3d.backgroundColor;
		}
	}
}