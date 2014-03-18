package sunag.sea3d.framework
{
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	import sunag.sea3dgp;
	import sunag.animation.Animation;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.events.Object3DEvent;
	import sunag.sea3d.objects.SEAABC;
	import sunag.sea3d.objects.SEAAnimation;
	import sunag.sea3d.objects.SEAObject;
	import sunag.sea3d.objects.SEAObject3D;
	import sunag.sea3d.core.IGameObject;
	import sunag.sea3d.core.assets.ABC;
	import sunag.sea3d.core.script.Scripter;
	import sunag.sea3d.core.script.ScripterABC;
	
	use namespace sea3dgp;
	
	public class Object3D extends Asset implements IGameObject
	{				
		private static const TYPE:String = 'Object3D/';
		
		public static function getAsset(name:String):Object3D
		{
			return Asset.getAsset(TYPE+name) as Object3D;
		}
		
		sea3dgp var scope:ObjectContainer3D;	
		sea3dgp var scopeLocal:Object = {};
		
		sea3dgp var animation:sunag.sea3d.framework.AnimationStandard;
		sea3dgp var animator:sunag.animation.Animation;
		sea3dgp var animatorClass:Class;
		
		function Object3D(scope:ObjectContainer3D, animatorClass:Class=null)
		{
			this.scope = scope;
			this.animatorClass = animatorClass;
			
			SEA3DGP.objects.push( this );
			
			super(TYPE);						
		}
		
		//
		//	ANIMATION
		//
		
		public function setAnimation(animation:sunag.sea3d.framework.AnimationStandard, relative:Boolean=true):void
		{
			if (animator)
			{
				animator.stop();
				animator = null;
			}
			
			if (animatorClass && (this.animation = animation))
			{
				animator = new animatorClass(animation.scope, scope);
				animator.relative = relative;
			}
		}
		
		public function getAnimation():sunag.sea3d.framework.AnimationStandard
		{
			return animation;
		}
		
		public function playAnimation(name:String, blendSpeed:Number=0, offset:Number=NaN):void
		{
			animator.play(name, blendSpeed, offset);
		}
		
		public function stopAnimation():void
		{
			animator.stop();			
		}
		
		public function setTimeScale(scale:Number):void
		{
			animator.timeScale = scale;
		}
		
		public function getTimeScale():Number
		{
			return animator.timeScale;
		}
		
		public function setAnimationBlendMode(blendMode:String):void
		{
			animator.blendMethod = AnimationBlendMode.BLEND_MODE[blendMode];
		}
		
		public function getAnimationBlendMode():String
		{
			return AnimationBlendMode.BLEND_MODE[animator.blendMethod];
		}
		
		public function getCurrentAnimation():String
		{
			return animator.currentAnimation;
		}
		
		public function playing():Boolean
		{
			return animator.playing;
		}

		//
		//	TRANSFORM
		//
		
		public function setPosition(val:Vector3D):void
		{
			scope.position = val;			
			dispatchTransform();
		}
		
		public function getPosition():Vector3D
		{
			return scope.position;
		}
		
		public function setRotation(val:Vector3D):void
		{
			scope.rotation = val;			
			dispatchTransform();
		}
		
		public function getRotation():Vector3D
		{
			return scope.rotation;
		}
		
		public function setScale(val:Vector3D):void
		{
			scope.scale = val;
			dispatchTransform();
		}
		
		public function getScale():Vector3D
		{			
			return scope.scale;
		}
		
		public function getGlobalPosition():Vector3D
		{
			return scope.scenePosition;
		}
		
		public function lookAt(target:Vector3D, upAxis:Vector3D=null):void
		{
			scope.lookAt(target, upAxis);
		}
		
		public function translateLocal(axis:Vector3D, distance:Number):void
		{
			scope.translateLocal(axis, distance);
		}
		
		public function rotate(axis:Vector3D, angle:Number):void
		{
			scope.rotate(axis, angle);
		}
		
		protected function dispatchTransform():void
		{						
			dispatchEvent( new Object3DEvent( Object3DEvent.TRANSFORM ) );
		}
		
		//
		//	HIERARCHY
		//
		
		protected function setParent(obj3d:Object3D):void
		{
			if (obj3d)
			{
				obj3d.scope.addChild( scope );
			}
			else
			{
				SEA3DGP.view3d.scene.addChild( scope );
			}
		}
		
		public function get local():Object
		{
			return scopeLocal;
		}
						
		public function addChild(child:Object3D):void
		{
			scope.addChild(child.scope);
		}
		
		public function removeChild(child:Object3D):void
		{
			scope.removeChild(child.scope);
		}
		
		public function contains(child:Object3D):Boolean
		{
			return scope.contains(child.scope);
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	OBJECT3D
			//
			
			var obj3d:SEAObject3D = sea as SEAObject3D,
				scripter:Scripter;
			
			setParent( obj3d.parent ? obj3d.parent.tag : null );
			
			for each(var anm:Object in obj3d.animations)
			{
				if (anm.tag.type == SEAAnimation.TYPE)
				{
					setAnimation( SEAAnimation(anm.tag).tag, anm.relative );
				}
			}
			
			for each(var src:Object in obj3d.scripts)
			{
				if (src.tag is SEAABC && src.method)
				{
					scripter = new ScripterABC(this, src.method, src.params)
					
					ABC(src.tag.tag).run( scripter );							
				}
			}
		}
		
		override public function dispose():void
		{
			SEA3DGP.objects.splice( SEA3DGP.objects.indexOf(this), 1 );
			
			scope.dispose();
			
			super.dispose();						
		}
	}
}