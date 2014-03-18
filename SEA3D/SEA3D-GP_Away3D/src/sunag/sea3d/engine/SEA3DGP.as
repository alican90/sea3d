package sunag.sea3d.engine
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.pick.PickingType;
	
	import sunag.sea3dgp;
	import sunag.events.SEAEvent;
	import sunag.sea3d.core.IGameObject;
	import sunag.sea3d.core.assets.ABC;
	import sunag.sea3d.core.assets.Actions;
	import sunag.sea3d.core.assets.Script;
	import sunag.sea3d.easing.Motion;
	import sunag.sea3d.events.Event;
	import sunag.sea3d.framework.ATFTexture;
	import sunag.sea3d.framework.AnimationStandard;
	import sunag.sea3d.framework.Asset;
	import sunag.sea3d.framework.Camera3D;
	import sunag.sea3d.framework.CubeMapFile;
	import sunag.sea3d.framework.DirectionalLight;
	import sunag.sea3d.framework.Dummy;
	import sunag.sea3d.framework.Game;
	import sunag.sea3d.framework.Geometry;
	import sunag.sea3d.framework.JointObject;
	import sunag.sea3d.framework.Mesh;
	import sunag.sea3d.framework.PointLight;
	import sunag.sea3d.framework.Skeleton;
	import sunag.sea3d.framework.SkeletonAnimation;
	import sunag.sea3d.framework.StandardMaterial;
	import sunag.sea3d.framework.TextureFile;
	import sunag.sea3d.input.Input;
	import sunag.sea3d.input.InputBase;
	import sunag.sea3d.input.KeyboardInput;
	import sunag.sea3d.loader.Loader;
	import sunag.sea3d.loader.LoaderManager;
	import sunag.sea3d.loader.SEA3DLoader;
	import sunag.sea3d.math.Vector3D;
	import sunag.sea3d.objects.SEAABC;
	import sunag.sea3d.objects.SEAATF;
	import sunag.sea3d.objects.SEAAction;
	import sunag.sea3d.objects.SEAAnimation;
	import sunag.sea3d.objects.SEACamera;
	import sunag.sea3d.objects.SEACubeMap;
	import sunag.sea3d.objects.SEADirectionalLight;
	import sunag.sea3d.objects.SEADummy;
	import sunag.sea3d.objects.SEAGIF;
	import sunag.sea3d.objects.SEAGeometry;
	import sunag.sea3d.objects.SEAGeometryDelta;
	import sunag.sea3d.objects.SEAJPEG;
	import sunag.sea3d.objects.SEAJPEGXR;
	import sunag.sea3d.objects.SEAJointObject;
	import sunag.sea3d.objects.SEAMaterial;
	import sunag.sea3d.objects.SEAMesh;
	import sunag.sea3d.objects.SEAObject;
	import sunag.sea3d.objects.SEAPNG;
	import sunag.sea3d.objects.SEAPointLight;
	import sunag.sea3d.objects.SEASkeleton;
	import sunag.sea3d.objects.SEASkeletonAnimation;
	import sunag.sea3d.utils.TimeStep;

	use namespace sea3dgp;
	
	public class SEA3DGP
	{	
		sea3dgp static const REFERENCE:Object = {};
		sea3dgp static const GLOBAL:Object = {};
		sea3dgp static const TYPE_CLASS:Object = {};			
		
		sea3dgp static var scripts:Vector.<Script> = new Vector.<Script>();
		sea3dgp static var objects:Vector.<IGameObject> = new Vector.<IGameObject>();		
		sea3dgp static var events:EventDispatcher;
		sea3dgp static var stage:Stage;
		sea3dgp static var container:DisplayObjectContainer;
		sea3dgp static var view3d:View3D;
		sea3dgp static var scene:Scene3D;
		sea3dgp static var stage3DManager:Stage3DManager;
		sea3dgp static var isPPAPI:Boolean;
		sea3dgp static var config:Config;
		sea3dgp static var loaderManager:LoaderManager;
						
		public static function init(container:DisplayObjectContainer, config:Config=null):void
		{						
			sea3dgp::container = container;
			
			stage = container.stage;
			stage.stageFocusRect = false;
			stage.showDefaultContextMenu = false;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void { });
			
			sea3dgp::config = config ||= new Config();
			
			stage3DManager = Stage3DManager.getInstance(stage);
			
			loaderManager = new LoaderManager();
			container.addChild( loaderManager );
									
			events = new EventDispatcher();
			
			//
			//	LOADER
			//
			
			TYPE_CLASS[SEAABC.TYPE] = ABC;
			
			TYPE_CLASS[SEAAction.TYPE] = Actions;		
			TYPE_CLASS[SEAMesh.TYPE] = Mesh;			
			TYPE_CLASS[SEAGeometry.TYPE] = Geometry;
			TYPE_CLASS[SEAGeometryDelta.TYPE] = Geometry;			
			TYPE_CLASS[SEASkeleton.TYPE] = Skeleton;
			TYPE_CLASS[SEASkeletonAnimation.TYPE] = SkeletonAnimation;
			TYPE_CLASS[SEACamera.TYPE] = Camera3D;		
			TYPE_CLASS[SEAMaterial.TYPE] = StandardMaterial;
			TYPE_CLASS[SEAAnimation.TYPE] = AnimationStandard;
			TYPE_CLASS[SEAPointLight.TYPE] = PointLight;
			TYPE_CLASS[SEADirectionalLight.TYPE] = DirectionalLight;
			TYPE_CLASS[SEAJointObject.TYPE] = JointObject;
			TYPE_CLASS[SEADummy.TYPE] = Dummy;
			TYPE_CLASS[SEACubeMap.TYPE] = CubeMapFile;
			
			TYPE_CLASS[SEAJPEG.TYPE] = TextureFile;
			TYPE_CLASS[SEAJPEGXR.TYPE] = TextureFile;
			TYPE_CLASS[SEAPNG.TYPE] = TextureFile;
			TYPE_CLASS[SEAGIF.TYPE] = TextureFile;
			TYPE_CLASS[SEAATF.TYPE] = ATFTexture;
			
			//
			//	PROXY CLASS ( PREVENT NOT-INCLUSION BY THE COMPILER )
			//
			
			Vector3D;
			
			//
			//	FRAMEWORK
			//											
			
			var names:Vector.<String> = ApplicationDomain.currentDomain.getQualifiedDefinitionNames();
			
			var reserved:Object = {
				'sunag.sea3d.events::' : 'events.',
				'sunag.sea3d.framework::' : 'sea3d.',
				'sunag.sea3d.input::' : 'input.',
				'sunag.sea3d.math::' : 'math.',
				'sunag.sea3d.utils::' : 'utils.',
				'sunag.sea3d.easing::' : 'easing.'
			}
			
			for each(var name:String in names)
			{
				for(var ns:String in reserved)
				{
					if (name.indexOf(ns) == 0)
					{
						var CLASS:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
						var NS:String = reserved[ns] + name.substring(ns.length);
						
						REFERENCE[NS] = CLASS['PROXY'] || CLASS;																	
					}
				}
			}
			
			//			
			//	MODULES
			//
						
			Input.init(stage);
			KeyboardInput.init(stage);
			
			TimeStep.init(stage);						
			
			//
			//	AWAY3D CONFIG
			//
			
			scene = new Scene3D();
			
			view3d = new View3D(scene);	
			view3d.stage3DProxy = stage3DManager.getFreeStage3DProxy(false, config.profile);
			view3d.backgroundColor = stage.color;
			view3d.antiAlias = config.antiAlias;
			view3d.rightClickMenuEnabled = false;
			view3d.mousePicker = config.shaderPicker ? PickingType.SHADER : PickingType.RAYCAST_BEST_HIT;
			
			container.addChild(view3d);	
			
			//
			//	CROSS BROWSER
			//
			
			var jsCodeIsPPAPI:String = "function(){var type='application/x-shockwave-flash';var mimeTypes=navigator.mimeTypes;var endsWith=function(str,suffix){return str.indexOf(suffix,str.length-suffix.length)!==-1;};return(mimeTypes&&mimeTypes[type]&&mimeTypes[type].enabledPlugin&&(mimeTypes[type].enabledPlugin.filename=='pepflashplayer.dll'||mimeTypes[type].enabledPlugin.filename=='libpepflashplayer.so'||endsWith(mimeTypes[type].enabledPlugin.filename,'Chrome.plugin')));}";
			
			if (ExternalInterface.available)
			{										
				view3d.stage3DProxy.enableErrorChecking = isPPAPI = ExternalInterface.call(jsCodeIsPPAPI);
			}
			
			//
			//	EVENTS
			//
						
			if (config.autoPlay)
			{
				stage.addEventListener(flash.events.Event.ENTER_FRAME, onUpdate);
			}
			
			stage.addEventListener(flash.events.Event.RESIZE, onResize);
								
			onResize();		
		}
		
		//
		//	INPUT
		//
		
		public static function addPlayer(name:String, player:InputBase):void
		{		
			Input.players[name] = player;
		}
		
		public static function removePlayer(name:String):void
		{
			delete Input.players[name];
		}
		
		public static function getPlayer(name:String):InputBase
		{
			return Input.players[name];
		}
		
		//
		//	LOADERS
		//
		
		private static function onCompleteObject(e:SEAEvent):void
		{
			var sea:SEAObject = e.object;
			
			if (TYPE_CLASS[sea.type])
			{								
				new TYPE_CLASS[sea.type]().load( sea );												
			}
			else
			{
				trace("asset", sea.type, "not mapped");
			}
		}
		
		public static function addLoader(loader:Loader):void
		{
			if (loader is SEA3DLoader)
			{
				SEA3DLoader(loader).sea3d.addEventListener(SEAEvent.COMPLETE_OBJECT, onCompleteObject, false, 0, true);
			}
			
			loaderManager.addLoader( loader );
		}

		public static function unload():void
		{
			for each(var asset:Asset in Asset.LIBRARY)
			{
				asset.dispose();
			}
			
			Game.setFog( null );
			Game.setEnvironmentColor( stage.color );
		}
		
		//
		//	PUBLIC METHODS
		//
		
		private static function dispatchEnterFrame():void
		{
			var enterFrame:sunag.sea3d.events.Event = 
				new sunag.sea3d.events.Event(sunag.sea3d.events.Event.UPDATE);
			
			for each(var script:Script in scripts)
			{
				script.event( objects, enterFrame );
			}
		}
		
		public static function update():void
		{
			//
			//	NETWORK-RECEIVE
			//
			
			//
			//	INPUT
			//
			
			Input.update();						
			
			//
			//	MOTION
			//
			
			Motion.update();
			
			//
			//	PHYSICS
			//
			
			//
			//	GAME STATE
			//
			
			dispatchEnterFrame();
						
			//
			//	NETWORK-SEND
			//
			
			//
			//	TIMER
			//
			
			TimeStep.updateTime();						
		}
		
		public static function render():void
		{
			//
			//	RENDER
			//
			
			view3d.render();
		}
		
		//
		//	INTERNAL
		//
		
		private static function onUpdate(e:flash.events.Event=null):void
		{
			update();
			render();
		}
		
		private static function onResize(e:flash.events.Event=null):void
		{
			var w:int = stage.stageWidth,
				h:int = stage.stageHeight;
			
			loaderManager.width = w;
			loaderManager.height = h;
			
			view3d.width = w;
			view3d.height = h;
		}
	}
}