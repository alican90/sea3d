package sunag.sea3d.framework
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.SimpleShadowMapMethodBase;
	import away3d.sea3d.animation.DirectionalLightAnimation;
	
	import sunag.sea3dgp;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.engine.SEA3DGPEvent;
	import sunag.sea3d.objects.SEADirectionalLight;
	import sunag.sea3d.objects.SEAObject;
	
	use namespace sea3dgp;
	
	public class DirectionalLight extends Light
	{
		public static function getAsset(name:String):DirectionalLight
		{
			return Object3D.getAsset(name) as DirectionalLight;
		}
		
		sea3dgp var dirLight:away3d.lights.DirectionalLight;
		
		sea3dgp var shadowMapper:ShadowMapperBase;
		sea3dgp var shadowMap:SimpleShadowMapMethodBase;
		sea3dgp var shadowMapMethod:ShadowMapMethodBase;
		
		public function DirectionalLight(color:Number=0xFFFFFF, intensity:Number=1)
		{
			super(dirLight = new away3d.lights.DirectionalLight(), DirectionalLightAnimation);
			
			dirLight.color = color;
			dirLight.diffuse = intensity;
			dirLight.ambient = 1;
		}
		
		protected function disposeShadow():void
		{
			shadowMap.dispose();
			shadowMapMethod.dispose();
			dirLight.shadowMapper.dispose();
			
			shadowMap = null;
			shadowMapMethod = null;												
			dirLight.shadowMapper = null;
			
			Game.shadowLight = null;
		}
		
		protected function createShadow():void
		{
			dirLight.shadowMapper = new NearDirectionalShadowMapper(.3);
			
			shadowMap = new FilteredShadowMapMethod(dirLight);			
			shadowMapMethod = new NearShadowMapMethod(shadowMap, .1);
			
			Game.shadowLight = this;
		}
		
		override public function setShadow(enabled:Boolean):void
		{
			if (enabled == getShadow()) return;
			
			if (dirLight.shadowMapper)
				disposeShadow();
			
			if (enabled)			
				createShadow();								
			
			SEA3DGP.events.dispatchEvent(new SEA3DGPEvent(SEA3DGPEvent.INVALIDATE_MATERIAL));	
		}
		
		override public function getShadow():Boolean
		{
			return dirLight.shadowMapper != null;
		}
		
		public function setShadowAlpha(alpha:Number):void
		{
			shadowMapMethod.alpha = alpha;
		}
		
		public function getShadowAlpha():Number
		{
			return shadowMapMethod.alpha;
		}
		
		public function setColor(color:Number):void
		{
			dirLight.color = color;
		}
		
		public function getColor():Number
		{
			return dirLight.color;
		}
		
		public function setIntensity(intensity:Number):void
		{
			dirLight.specular = dirLight.diffuse = intensity;
		}
		
		public function getIntensity():Number
		{
			return dirLight.diffuse;
		}
				
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	DIRECTIONAL LIGHT
			//
			
			var dir:SEADirectionalLight = sea as SEADirectionalLight;
			
			dirLight.transform = dir.transform;
			
			dirLight.color = dir.color;
			dirLight.specular = dirLight.diffuse = dir.intensity;	
			
			if (dir.shadow)
			{
				setShadow(true);
				setShadowAlpha( dir.shadow.opacity );				
			}
		}
		
		override public function dispose():void
		{
			if (dirLight.shadowMapper)
				disposeShadow();
			
			super.dispose();
		}
	}
}