package sunag.sea3d.core.assets
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import sunag.sea3dgp;
	import sunag.sea3d.engine.SEA3DGP;
	import sunag.sea3d.engine.TopLevel;
	import sunag.sea3d.events.Event;
	import sunag.sea3d.events.EventDispatcher;
	import sunag.sea3d.objects.SEAObject;
	import sunag.sea3d.core.IGameObject;
	import sunag.sea3d.core.script.Scripter;
	import sunag.sea3d.core.script.ScripterABC;

	use namespace sea3dgp;
	
	public class ABC extends Script
	{
		public static const RUN:uint = 0;
		public static const EVENT:uint = 1;
		public static const SINGLE_EVENT:uint = 2;
		
		public static function getAsset(name:String):ABC
		{
			return Script.getAsset(name) as ABC;
		}
				
		sea3dgp var loader:Loader;		
		sea3dgp var script:Object;
		sea3dgp var waiting:Vector.<ScripterABC>;
		
		sea3dgp var worker:Worker;
		sea3dgp var sender:MessageChannel;
		sea3dgp var receiver:MessageChannel;
		
		public function loadBytes(bytes:ByteArray):void
		{
			if (SEA3DGP.config.worker)
			{				
				worker = WorkerDomain.current.createWorker(bytes, true);
				
				worker.setSharedProperty("INCOMING", sender = Worker.current.createMessageChannel(worker));
				worker.setSharedProperty("OUTGOING", receiver = worker.createMessageChannel(Worker.current));
								
				worker.start();				
			}
			else
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoaderComplete);
				loader.loadBytes(bytes, new LoaderContext(false, new ApplicationDomain()));	
			}				
		}
		
		protected function onLoaderComplete(e:flash.events.Event):void
		{
			script = loader.contentLoaderInfo.applicationDomain.getDefinition("$SCRIPT")(TopLevel);			
			
			for each(var scripter:ScripterABC in waiting)
			{
				run( scripter );
			}
			
			waiting = null;
			
			dispatchEvent(new ScriptEvent(ScriptEvent.COMPLETE));
		}
		
		override public function event(objects:Vector.<IGameObject>, e:sunag.sea3d.events.Event):void
		{
			if (sender)
			{
				sender.send({
					type : EVENT,					
					scope : objects,
					event : e					
				});
			}
			else
			{
				for each(var obj:EventDispatcher in objects)	
				{
					obj.dispatchEvent( e );
				}
			}
		}
		
		override public function run(scripter:Scripter):void
		{
			var abc:ScripterABC = scripter as ScripterABC;
			
			if (sender)
			{
				// MESSAGE CURRENTLY DOES NOT SHADER OBJECT, COPY WITH AMF ONLY
				sender.send({
					type : RUN,
					method : abc.method,
					reference : SEA3DGP.REFERENCE,
					global : SEA3DGP.GLOBAL,
					local : LOCAL,
					scope : abc.scope,
					params : abc.params					
				});
			}
			else if (script)
			{
				script[abc.method](SEA3DGP.REFERENCE, SEA3DGP.GLOBAL, LOCAL, abc.scope, abc.params);				
			}
			else
			{
				waiting ||= new Vector.<ScripterABC>();
				waiting.push( abc );
			}
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	ABC
			//
			
			loadBytes(sea.data);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if (worker)
			{
				worker.terminate();
				worker = null;
				
				sender = receiver = null;
			}			
			else if (loader)
			{
				loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoaderComplete);
				loader.unloadAndStop(false);
				loader = null;
			}		
		}
	}
}