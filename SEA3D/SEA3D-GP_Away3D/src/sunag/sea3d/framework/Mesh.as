package sunag.sea3d.framework
{
	import away3d.animator.IMorphAnimator;
	import away3d.animator.MorphAnimator;
	import away3d.animator.MorphGeometry;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimator;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.events.AnimationStateEvent;
	import away3d.events.MouseEvent3D;
	import away3d.sea3d.animation.MorphAnimation;
	import away3d.tools.SkeletonTools;
	
	import sunag.sea3dgp;
	import sunag.sea3d.engine.TopLevel;
	import sunag.sea3d.events.AnimationEvent;
	import sunag.sea3d.events.TouchEvent;
	import sunag.sea3d.objects.IAnimator;
	import sunag.sea3d.objects.SEAMaterialBase;
	import sunag.sea3d.objects.SEAMesh;
	import sunag.sea3d.objects.SEAModifier;
	import sunag.sea3d.objects.SEAMorph;
	import sunag.sea3d.objects.SEAObject;
	import sunag.sea3d.objects.SEASkeleton;
	import sunag.sea3d.objects.SEASkeletonAnimation;

	use namespace sea3dgp;
	
	public class Mesh extends Object3D		
	{				
		public static function getAsset(name:String):sunag.sea3d.framework.Mesh
		{
			return Object3D.getAsset(name) as sunag.sea3d.framework.Mesh;
		}
		
		sea3dgp static var MouseDict:Object = 
			{
				click3d : TouchEvent.CLICK,
				doubleClick3d : TouchEvent.DOUBLE_CLICK,
				mouseDown3d : TouchEvent.TOUCH_DOWN,
				mouseMove3d : TouchEvent.TOUCH_MOVE,
				mouseOut3d : TouchEvent.TOUCH_OUT,
				mouseOver3d : TouchEvent.TOUCH_OVER,
				mouseUp3d : TouchEvent.TOUCH_UP,
				mouseWheel3d : TouchEvent.WHELL
			}
		
		sea3dgp var usesVertexCPU:Boolean = true;
		sea3dgp var usesSkeletonCPU:Boolean = true;
		sea3dgp var usesMorphCPU:Boolean = true;
		
		sea3dgp var mesh:away3d.entities.Mesh;
		
		sea3dgp var multiMaterial:Array;
		sea3dgp var material:Material;
		
		sea3dgp var skeleton:Skeleton;
		sea3dgp var skeletonAnm:SkeletonAnimation;
		sea3dgp var sklAnimator:SkeletonAnimator;		
		
		sea3dgp var geometry:Geometry;
		
		sea3dgp var vertexAnm:VertexAnimation; 
		sea3dgp var vertexAnimator:VertexAnimator;
		
		sea3dgp var morphAnm:sunag.sea3d.framework.MorphAnimation;
		sea3dgp var morphAnimator:away3d.sea3d.animation.MorphAnimation;
		
		sea3dgp var morph:Morph;		
		sea3dgp var morpher:IMorphAnimator;
		
		public function Mesh(geometry:Geometry=null, material:Material=null)
		{
			super(mesh = new away3d.entities.Mesh( Geometry.NULL ));
			
			setGeometry(geometry);
			setMaterial(material);
		}
		
		//
		//	SKELETON ANIMATION
		//
		
		public function setSkeleton(skl:Skeleton, usesCPU:Boolean=false):void
		{
			skeleton = skl;
			usesSkeletonCPU = usesCPU;
			updateAnimation();
		}
		
		public function getSkeleton():Skeleton
		{
			return skeleton;
		}
		
		public function setSkeletonAnimation(animation:SkeletonAnimation):void
		{
			skeletonAnm = animation;				
			updateAnimation();
		}
		
		public function getSkeletonAnimation():SkeletonAnimation
		{
			return skeletonAnm;
		}
		
		public function playSkeletonAnimation(name:String, blendSpeed:Number=0, offset:Number=NaN):void
		{
			sklAnimator.play(name, new CrossfadeTransition(blendSpeed), offset);
			sklAnimator.activeAnimation.addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onSklAnmComplete);
		}
		
		public function stopSkeletonAnimation():void
		{
			sklAnimator.activeAnimation.removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onSklAnmComplete);
			sklAnimator.stop();			
		}
		
		public function setSkeletonBlendMode(blendMode:String):void
		{
			TopLevel.warn('Unavailable: Mesh.setSkeletonBlendMode');
		}
		
		public function getSkeletonBlendMode():String
		{
			return AnimationBlendMode.LINEAR;
		}
		
		public function setSkeletonTimeScale(scale:Number):void
		{
			sklAnimator.playbackSpeed = scale;
		}
		
		public function getSkeletonTimeScale():Number
		{
			return sklAnimator.playbackSpeed;
		}
		
		protected function onSklAnmComplete(e:AnimationStateEvent):void
		{
			dispatchEvent( new AnimationEvent(AnimationEvent.COMPLETE, skeletonAnm, e.animationNode.name) );			
		}
		
		protected function updateSkeletonAnimation():void
		{
			if (sklAnimator)
			{								
				sklAnimator.stop();
				sklAnimator = null;
			}
			
			if (skeleton && skeletonAnm && geometry && geometry.jointPerVertex > 0)
			{
				sklAnimator = new SkeletonAnimator(skeletonAnm.creatAnimationSet(geometry.jointPerVertex), skeleton.scope, usesSkeletonCPU);
				
				SkeletonTools.poseFromSkeleton(sklAnimator.globalPose, skeleton.scope);
			}
			
			mesh.animator = sklAnimator;
		}
		
		public function getCurrentSkeletonAnimation():String
		{
			return sklAnimator.activeAnimationName;
		}
		
		public function playingSkeletonAnimation():Boolean
		{
			return sklAnimator.activeAnimationName != null;
		}
		
		//
		//	MORPHER
		//
		
		public function setMorph(morph:Morph, usesCPU:Boolean=false):void
		{
			this.morph = morph;
			usesMorphCPU = usesCPU;
			updateAnimation();
		}
		
		public function getMorph():Morph
		{
			return morph;
		}
		
		public function setMorphWeight(name:String, weight:Number):void
		{
			morpher.setWeight(name, weight);
		}
		
		public function getMorphWeight(name:String):Number
		{
			return morpher.getWeight(name);
		}
				
		protected function updateMorpher():void
		{
			if (morpher)
			{
				if (morpher is MorphGeometry)
					MorphGeometry(morpher).dispose();
				else if (morph is MorphAnimator)
					mesh.animator = null;
				
				morpher = null;
			}
			
			if (morph && geometry && morph.numVertex == geometry.numVertex)
			{
				if (usesMorphCPU || mesh.animator)
				{
					morpher = new MorphGeometry(morph.scope, geometry.scope);
				}
				else
				{
					morpher = new MorphAnimator(morph.scope);
					mesh.animator = morpher as MorphAnimator;
				}
			}
		}
			
		//
		//	MORPH ANIMATION
		//
		
		public function setMorphAnimation(morphAnm:sunag.sea3d.framework.MorphAnimation):void
		{			
			this.morphAnm = morphAnm;
			updateAnimation();
		}
		
		public function getMorphAnimation():sunag.sea3d.framework.MorphAnimation
		{
			return morphAnm;
		}
				
		public function playMorphAnimation(name:String, blendSpeed:Number=0, offset:Number=NaN):void
		{
			morphAnimator.play(name, blendSpeed, offset);			
		}
		
		public function stopMorphAnimation():void
		{
			morphAnimator.stop();			
		}
		
		public function setMorphAnimationBlendMode(blendMode:String):void
		{
			morphAnimator.blendMethod = AnimationBlendMode.BLEND_MODE[blendMode];
		}
		
		public function getMorphAnimationBlendMode():String
		{
			return AnimationBlendMode.BLEND_MODE[morphAnimator.blendMethod];
		}
		
		public function setMorphTimeScale(scale:Number):void
		{
			morphAnimator.timeScale = scale;
		}
		
		public function getMorphTimeScale():Number
		{
			return morphAnimator.timeScale;
		}
		
		protected function updateMorphAnimation():void
		{
			if (morphAnimator)
			{
				morphAnimator.stop();
				morphAnimator = null;
			}
			
			if (morphAnm && morpher)
			{
				morphAnimator = new away3d.sea3d.animation.MorphAnimation(morphAnm.scope, morpher);
			}
		}
		
		//
		//	VERTEX ANIMATION
		//
		
		public function setVertexAnimation(vertex:VertexAnimation, usesCPU:Boolean=false):void
		{			
			vertexAnm = vertex;
			usesVertexCPU = usesCPU;
			updateAnimation();
		}
		
		public function getVertexAnimation():VertexAnimation
		{
			return vertexAnm;
		}
		
		public function playVertexAnimation(name:String, blendSpeed:Number=0, offset:Number=NaN):void
		{
			vertexAnimator.play(name, new CrossfadeTransition(blendSpeed), offset);
		}
		
		public function stopVertexAnimation():void
		{
			vertexAnimator.stop();			
		}
		
		public function setVertexTimeScale(scale:Number):void
		{
			vertexAnimator.playbackSpeed = scale;
		}
		
		public function getVertexTimeScale():Number
		{
			return vertexAnimator.playbackSpeed;
		}
		
		public function setVertexAnimationBlendMode(blendMode:String):void
		{
			TopLevel.warn('Unavailable: Mesh.setVertexAnimationBlendMode');
		}
		
		public function getVertexAnimationBlendMode():String
		{
			return AnimationBlendMode.LINEAR;
		}
		
		protected function updateVertexAnimation():void
		{
			if (vertexAnimator)
			{
				vertexAnimator.stop();
				vertexAnimator = null;
			}
			
			if (vertexAnm && geometry && geometry.numVertex == vertexAnm.numVertex && !mesh.animator)
			{
				vertexAnimator = new VertexAnimator( vertexAnm.creatAnimationSet(geometry.scope) );
				mesh.animator = vertexAnimator;
			}						
		}
		
		//
		//	TOUCH
		//
		
		protected function onMouseEvent(e:MouseEvent3D):void
		{
			var type:String = MouseDict[e.type];
			
			if (hasEvent(type))
			{
				dispatchEvent( new TouchEvent(type, e.scenePosition, e.sceneNormal, e.delta) );
			}
		}
		
		public function setTouch(enabled:Boolean):void
		{
			mesh.mouseEnabled = mesh.mouseChildren = enabled;
			
			if (enabled)
			{
				mesh.addEventListener(MouseEvent3D.CLICK, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.DOUBLE_CLICK, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.MOUSE_UP, onMouseEvent);
				mesh.addEventListener(MouseEvent3D.MOUSE_WHEEL, onMouseEvent);
			}
			else
			{
				mesh.removeEventListener(MouseEvent3D.CLICK, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.DOUBLE_CLICK, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.MOUSE_OUT, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.MOUSE_OVER, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.MOUSE_UP, onMouseEvent);
				mesh.removeEventListener(MouseEvent3D.MOUSE_WHEEL, onMouseEvent);
			}						
		}
		
		public function getTouch():Boolean
		{
			return mesh.mouseEnabled;
		}
		
		//
		//	ANIMATION
		//

		protected function updateAnimation():void
		{			
			updateSkeletonAnimation();
			updateVertexAnimation();
			updateMorpher();
			updateMorphAnimation();
		}
		
		//
		//	GEOMETRY
		//
		
		public function setGeometry(geometry:Geometry):void
		{
			if (this.geometry = geometry)
			{
				mesh.geometry = geometry.scope;
			}
			else mesh.geometry = Geometry.NULL;
			
			updateAnimation();
		}
		
		public function getGeometry():Geometry
		{
			return geometry;
		}
		
		//
		//	MATERIAL
		//
		
		public function setMaterial(material:Material):void
		{
			if (multiMaterial)
			{
				for each(var subMesh:SubMesh in mesh)
					subMesh.material = null;
					
				multiMaterial = null;
			}
			
			mesh.material = (this.material = material) ? material.scope : null;
		}
		
		public function getMaterial():Material
		{
			return material;
		}
		
		public function setMultiMaterial(materials:Array):void
		{
			if (!multiMaterial)
				mesh.material = null;
			
			multiMaterial = materials;
			
			var subMeshes:Vector.<SubMesh> = mesh.subMeshes;
			for(var i:int = 0; i < subMeshes.length; i++)
			{
				subMeshes[i].material = materials[i] ? materials[i].scope : null;
			}						
		}
		
		public function getMultiMaterial():Array
		{
			return multiMaterial;
		}			
		
		public function isNumMaterial():Boolean
		{
			return multiMaterial != null;
		}
		
		public function getNumMaterial():uint
		{
			return multiMaterial ? multiMaterial.length : material ? 1 : 0;
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	MESH
			//
			
			var mesh:SEAMesh = sea as SEAMesh;
			
			scope.transform = mesh.transform;
			
			setGeometry( mesh.geometry.tag );
			
			if (mesh.material)
			{
				if (mesh.material.length == 1)
				{
					setMaterial( mesh.material[0].tag );
				}
				else
				{
					var mats:Array = [];
					
					for each(var m:SEAMaterialBase in mesh.material)
					{
						mats.push( m.tag );
					}
					
					setMultiMaterial( mats );
				}
			}
			
			for each(var mod:SEAModifier in mesh.modifiers)
			{
				if (mod is SEASkeleton)
				{
					setSkeleton( mod.tag );
				}
				else if (mod is SEAMorph)
				{
					setMorph( mod.tag );
				}
			}
			
			for each(var anm:Object in mesh.animations)
			{
				var tag:IAnimator = anm.tag;
				
				if (tag is SEASkeletonAnimation)
				{
					setSkeletonAnimation( SEASkeletonAnimation(tag).tag );
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}