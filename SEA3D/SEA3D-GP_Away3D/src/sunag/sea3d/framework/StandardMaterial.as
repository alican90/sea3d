package sunag.sea3d.framework
{
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.LightMapMethod;
	import away3d.materials.methods.RefractionEnvMapMethod;
	import away3d.materials.methods.RimLightMethod;
	
	import sunag.sea3dgp;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.engine.SEA3DGPEvent;
	import sunag.sea3d.objects.SEAMaterial;
	import sunag.sea3d.objects.SEAObject;
	import sunag.utils.BlendMode;

	use namespace sea3dgp;
	
	public class StandardMaterial extends Material
	{
		public static function getAsset(name:String):StandardMaterial
		{
			return Material.getAsset(name) as StandardMaterial;
		}
		
		sea3dgp var fog:Boolean = true;
		sea3dgp var shadow:Boolean = true;
		sea3dgp var material:TextureMaterial;
		
		sea3dgp var diffuseMap:Texture;
		sea3dgp var specularMap:Texture;
		sea3dgp var normalMap:Texture;
		sea3dgp var lightMap:Texture;
		sea3dgp var refractionMap:CubeMap;
		sea3dgp var reflectionMap:CubeMap;
		sea3dgp var fresnelReflectionMap:CubeMap;
		
		private var rimMethod:RimLightMethod;
		private var lightMapMethod:LightMapMethod;
		private var refractionMethod:*;
		private var reflectionMethod:*;
		
		function StandardMaterial()
		{
			super(material = new TextureMaterial(null, true, true, true));
			
			SEA3DGP.events.addEventListener(SEA3DGPEvent.INVALIDATE_MATERIAL, onInvalidate);			
		}
		
		//
		//	MATERIAL
		//
		
		public function setFog(val:Boolean):void
		{
			fog = val;
			onInvalidate();
		}
		
		public function getFog():Boolean
		{
			return fog;
		}
		
		public function setReceiveLights(val:Boolean):void
		{
			material.lightPicker = val ? Game.lightPicker : null;
		}
		
		public function getReceiveLights():Boolean
		{
			return material.lightPicker != null;
		}
		
		public function setReceiveShadows(val:Boolean):void
		{
			shadow = val;
			onInvalidate();
		}
		
		public function getReceiveShadows():Boolean
		{
			return shadow;
		}
		
		public function setDoubleSided(val:Boolean):void
		{
			material.bothSides = val;
		}
		
		public function getDoubleSided():Boolean
		{
			return material.bothSides;
		}
		
		public function setSmooth(val:Boolean):void
		{
			material.smooth = val;
		}
		
		public function getSmooth():Boolean
		{
			return material.smooth;
		}				
		
		public function setAlpha(val:Number):void
		{
			material.alpha = val;
		}
		
		public function getAlpha():Number
		{
			return material.alpha;
		}
		
		public function setBlendMode(val:String):void
		{
			material.blendMode = val;
		}
		
		public function getBlendMode():String
		{
			return material.blendMode;
		}
		
		//
		//	DEFAULT
		//
		
		public function setAmbientColor(color:Number):void
		{			
			material.ambientColor = color;
		}
		
		public function getAmbientColor():Number
		{
			return material.ambientColor;
		}
		
		public function setColor(color:Number):void
		{			
			material.color = color;
		}
		
		public function getColor():Number
		{
			return material.color;
		}
		
		public function setSpecularColor(color:Number):void
		{			
			material.specularColor = color;
		}
		
		public function getSpecularColor():Number
		{
			return material.specularColor;
		}
		
		public function setSpecular(intensity:Number):void
		{			
			material.specular = intensity;
		}
		
		public function getSpecular():Number
		{
			return material.specular;
		}
		
		public function setGloss(sheen:Number):void
		{			
			material.specular = sheen;
		}
		
		public function getGloss():Number
		{
			return material.specular;
		}
		
		//
		//	DIFFUSE MAP
		//
		
		public function setDiffuseMap(tex:Texture):void
		{			
			if (tex && tex.transparent)
			{
				material.alphaBlending = true;
				material.alphaThreshold = .5;
			}
			else
			{
				material.alphaBlending = false;
			}
			
			if (diffuseMap = tex)
			{
				material.texture = diffuseMap.scope;
			}
			else material.texture = null;
		}
		
		public function getDiffuseMap():Texture
		{
			return diffuseMap;
		}
		
		//
		//	SPECULAR MAP
		//
		
		public function setSpecularMap(tex:Texture):void
		{			
			if (specularMap = tex)
			{
				material.specularMap = specularMap.scope;
			}
			else material.specularMap = null;
		}
		
		public function getSpecularMap():Texture
		{
			return specularMap;
		}
		
		//
		//	RIM
		//
		
		public function setRimBlendMode(blendMode:String):void
		{			
			if (blendMode)
			{
				if (rimMethod)
				{
					rimMethod.blendMode = blendMode;
				}
				else
				{
					rimMethod = new RimLightMethod(0x999999, .5, 2, blendMode);					
					
					onInvalidate();
				}
			}
			else if (rimMethod)
			{
				material.removeMethod( rimMethod );
				
				rimMethod.dispose();
				rimMethod = null;
				
				onInvalidate();
			}			
		}
		
		public function getRimBlendMode():String
		{
			return rimMethod.blendMode;
		}
		
		public function setRimColor(color:Number):void
		{
			rimMethod.color = color;
		}
		
		public function getRimColor():Number
		{
			return rimMethod.color;
		}
		
		public function setRimStrength(strength:Number):void
		{
			rimMethod.strength = strength;
		}
		
		public function getRimStrength():Number
		{
			return rimMethod.strength;
		}
		
		public function setRimPower(power:Number):void
		{
			rimMethod.power = power;
		}
		
		public function getRimPower():Number
		{
			return rimMethod.power;
		}
		
		//
		//	NORMAL MAP
		//
		
		public function setNormalMap(tex:Texture):void
		{			
			if (normalMap = tex)
			{
				material.normalMap = normalMap.scope;
			}
			else material.normalMap = null;
		}
		
		public function getNormalMap():Texture
		{
			return normalMap;
		}
		
		//
		//	LIGHT MAP
		//
		
		public function setLightMap(tex:Texture):void
		{			
			if (lightMap = tex)
			{
				if (!lightMapMethod) 
				{
					lightMapMethod = new LightMapMethod(lightMap.scope, BlendMode.MULTIPLY, true);
				
					onInvalidate();
				}	
				else
				{
					lightMapMethod.texture = lightMap.scope;
				}
			}
			else if (lightMapMethod)
			{
				lightMapMethod.dispose();
				lightMapMethod = null;		
				
				onInvalidate();
			}			
		}
		
		public function getLightMap():Texture
		{
			return lightMap;
		}
		
		public function setLightMapChannel(channel:Number):void
		{
			lightMapMethod.useSecondaryUV = channel > 0;
		}
		
		public function getLightMapChannel():Number
		{
			return int(lightMapMethod.useSecondaryUV);
		}
			
		public function setLightMapBlendMode(blendMode:String):void
		{
			lightMapMethod.blendMode = blendMode;
		}
		
		public function getLightMapBlendMode():String
		{
			return lightMapMethod.blendMode;
		}
		
		//
		//	REFRACTION
		//
		
		public function setRefraction(cube:CubeMap):void
		{
			if (refractionMap = cube)
			{
				if (reflectionMethod && !(reflectionMethod is RefractionEnvMapMethod))
				{
					reflectionMethod.dispose();
					reflectionMethod = null;
				}
				
				if (!reflectionMethod) 
				{
					reflectionMethod = new RefractionEnvMapMethod(reflectionMap.scope, 1.333);
					reflectionMethod.alpha = .5;
					
					onInvalidate();
				}
				else
				{
					reflectionMethod.envMap = reflectionMap.scope;									
				}				
			}
			else if (refractionMap is RefractionEnvMapMethod)
			{
				reflectionMethod.dispose();
				reflectionMethod = null;		
				
				onInvalidate();
			}
		}
		
		public function getRefraction():CubeMap
		{
			return refractionMap;
		}
		
		public function setRefractionAlpha(alpha:Number):void
		{
			reflectionMethod.alpha = alpha;
		}
		
		public function getRefractionAlpha():Number
		{
			return reflectionMethod.alpha;
		}
		
		public function setRefractionIOR(ior:Number):void
		{
			reflectionMethod.refractionIndex = ior;
		}
		
		public function getRefractionIOR():Number
		{
			return reflectionMethod.refractionIndex;
		}
		
		//
		//	REFLECTION
		//
		
		public function setReflection(cube:CubeMap):void
		{
			if (reflectionMap = cube)
			{
				if (reflectionMethod && !(reflectionMethod is EnvMapMethod))
				{
					reflectionMethod.dispose();
					reflectionMethod = null;
				}
				
				if (!reflectionMethod) 
				{
					reflectionMethod = new EnvMapMethod(reflectionMap.scope, .5);
					
					onInvalidate();
				}
				else
				{
					reflectionMethod.envMap = reflectionMap.scope;									
				}				
			}
			else if (reflectionMethod is EnvMapMethod)
			{
				reflectionMethod.dispose();
				reflectionMethod = null;		
				
				onInvalidate();
			}
		}
		
		public function getReflection():CubeMap
		{
			return reflectionMap;
		}
		
		public function setFresnelReflection(cube:CubeMap):void
		{
			if (fresnelReflectionMap = cube)
			{
				if (reflectionMethod && !(reflectionMethod is FresnelEnvMapMethod))
				{
					reflectionMethod.dispose();
					reflectionMethod = null;
				}
				
				if (!reflectionMethod) 
				{
					reflectionMethod = new FresnelEnvMapMethod(fresnelReflectionMap.scope, .5);
					
					onInvalidate();
				}
				else
				{
					reflectionMethod.envMap = fresnelReflectionMap.scope;									
				}				
			}
			else if (reflectionMethod is FresnelEnvMapMethod)
			{
				reflectionMethod.dispose();
				reflectionMethod = null;		
				
				onInvalidate();
			}
		}
		
		public function getFresnelReflection():CubeMap
		{
			return fresnelReflectionMap;
		}
		
		public function setReflectionAlpha(alpha:Number):void
		{
			reflectionMethod.alpha = alpha;
		}
		
		public function getReflectionAlpha():Number
		{
			return reflectionMethod.alpha;
		}
		
		public function setReflectionPower(power:Number):void
		{
			reflectionMethod.fresnelPower = power;
		}
		
		public function getReflectionPower():Number
		{
			return reflectionMethod.fresnelPower;
		}
		
		public function setReflectionNormal(normal:Number):void
		{
			reflectionMethod.normalReflectance = normal;
		}
		
		public function getReflectionNormal():Number
		{
			return reflectionMethod.normalReflectance;
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	MATERIAL
			//
			
			var std:SEAMaterial = sea as SEAMaterial;
						
			fog = std.receiveFog;
			shadow = std.receiveShadows;			
			
			setDoubleSided( std.doubleSided );
			
			setReceiveLights( std.receiveLights );
			
			for each(var tech:Object in std.technique)
			{
				switch(tech.kind)
				{
					case SEAMaterial.DEFAULT:
						material.ambientColor = tech.ambientColor;
						material.diffuseMethod.diffuseColor = tech.diffuseColor;
						material.specularColor = tech.specularColor;
						
						material.gloss = tech.gloss;
						material.specular = tech.specular;
						break;
					
					case SEAMaterial.DIFFUSE_MAP:							
						setDiffuseMap( tech.texture.tag );
						break;
					
					case SEAMaterial.SPECULAR_MAP:							
						setSpecularMap( tech.texture.tag );
						break;
					
					case SEAMaterial.NORMAL_MAP:							
						setNormalMap( tech.texture.tag );
						break;
															
					case SEAMaterial.REFRACTION:	
						setRefraction( tech.texture.tag );
						setRefractionAlpha( tech.alpha );
						setRefractionIOR( tech.ior );
						break;
					
					case SEAMaterial.REFLECTION:
						setReflection( tech.texture.tag );
						setReflectionAlpha( tech.alpha );
						break;
					
					case SEAMaterial.FRESNEL_REFLECTION:
						setFresnelReflection( tech.texture.tag );
						setReflectionAlpha( tech.alpha );
						setReflectionPower( tech.power );
						setReflectionNormal( tech.normal );
						break;
					
					case SEAMaterial.RIM:							
						setRimBlendMode( tech.blendMode );
						setRimColor( tech.color );
						setRimStrength( tech.strength );
						setRimPower( tech.power  );
						break;
					
					case SEAMaterial.LIGHT_MAP:							
						setLightMap( tech.texture.tag );
						setLightMapChannel( tech.channel );
						setLightMapBlendMode( tech.blendMode );
						break;
				}
			}
			
			onInvalidate();
		}
		
		//
		//	UPDATE
		//
		
		protected function onInvalidate(e:SEA3DGPEvent=null):void
		{
			while ( material.numMethods ) 
				material.removeMethod( material.getMethodAt( 0 ) );
			
			if (shadow && !material.shadowMethod && Game.shadowLight)
				material.shadowMethod = Game.shadowLight.shadowMapMethod;
			else if (!shadow && material.shadowMethod)
				material.shadowMethod = null;
			
			if (reflectionMethod)
				material.addMethod(reflectionMethod);
			
			if (reflectionMethod)
				material.addMethod(reflectionMethod);
			
			if (lightMapMethod)
				material.addMethod(lightMapMethod);
			
			if (rimMethod)
				material.addMethod(rimMethod);
			
			if (fog && Game.fog)
				material.addMethod(Game.fog);
		}
		
		override public function dispose():void
		{
			SEA3DGP.events.removeEventListener(SEA3DGPEvent.INVALIDATE_MATERIAL, onInvalidate);
			
			super.dispose();
		}
	}
}