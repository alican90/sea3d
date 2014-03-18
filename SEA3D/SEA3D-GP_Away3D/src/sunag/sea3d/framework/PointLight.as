package sunag.sea3d.framework
{
	import away3d.lights.PointLight;
	import away3d.sea3d.animation.PointLightAnimation;
	
	import sunag.sea3dgp;
	import sunag.sea3d.objects.SEAObject;
	import sunag.sea3d.objects.SEAPointLight;
	
	use namespace sea3dgp;
	
	public class PointLight extends Light
	{
		public static function getAsset(name:String):PointLight
		{
			return Object3D.getAsset(name) as PointLight;
		}
		
		sea3dgp var pointLight:away3d.lights.PointLight;
		
		public function PointLight(color:Number=0xFFFFFF, intensity:Number=1)
		{
			super(pointLight = new away3d.lights.PointLight(), PointLightAnimation);
			
			pointLight.color = color;
			pointLight.diffuse = intensity;
			pointLight.ambient = 1;
		}
		
		public function setColor(color:Number):void
		{
			pointLight.color = color;
		}
		
		public function getColor():Number
		{
			return pointLight.color;
		}
		
		public function setIntensity(intensity:Number):void
		{
			pointLight.specular = pointLight.diffuse = intensity;
		}
		
		public function getIntensity():Number
		{
			return pointLight.diffuse;
		}
				
		public function setAttenuationEnabled(enabled:Boolean):void
		{
			if (enabled)
			{
				pointLight.radius = 100;
				pointLight.fallOff = 1000;
			}
			else
			{
				pointLight.radius = Number.MAX_VALUE;
				pointLight.fallOff = Number.MAX_VALUE;
			}
		}
		
		public function getAttenuationEnabled():Boolean
		{
			return pointLight.fallOff == Number.MAX_VALUE;
		}
		
		public function setAttenuationStart(radius:Number):void
		{
			pointLight.radius = radius;
		}
		
		public function getAttenuationStart():Number
		{
			return pointLight.radius;
		}
		
		public function setAttenuationEnd(end:Number):void
		{
			pointLight.fallOff = end;
		}
		
		public function getAttenuationEnd():Number
		{
			return pointLight.fallOff;
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	POINT LIGHT
			//
			
			var pnt:SEAPointLight = sea as SEAPointLight;
									
			pointLight.position = pnt.position;
			
			pointLight.color = pnt.color;
			pointLight.specular = pointLight.diffuse = pnt.intensity;						
		}
	}
}