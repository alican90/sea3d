package sunag.sea3d.framework
{
	import sunag.sea3dgp;
	import sunag.sea3d.engine.IDisposable;
	import sunag.sea3d.events.AssetEvent;
	import sunag.sea3d.events.EventDispatcher;
	import sunag.sea3d.objects.SEAObject;

	use namespace sea3dgp;
	
	public class Asset extends EventDispatcher implements IDisposable
	{
		sea3dgp static var LIST:Vector.<Asset> = new Vector.<Asset>();
		sea3dgp static var LIBRARY:Object = {};		
		
		public static function getAsset(ns:String):Asset
		{
			return LIBRARY[ns];
		}
		
		public static function gc():void
		{
			var i:int = 0;
			while (i < LIST.length)
			{
				if (LIST[i].deps == 0)
				{
					LIST[i].dispose();
					continue;
				}
				++i;
			}			
		}
		
		sea3dgp static function gcLib():void
		{						
			LIB : do
			{			
				for each(var asset:Asset in LIBRARY)
				{
					if (asset.deps == 0)
					{
						asset.dispose();
						
						continue LIB;
					}
				}
			}
			while ( false );
		}
		
		//
		//	CLASS
		//
		
		sea3dgp var _name:String;		
		sea3dgp var _type:String;
		sea3dgp var _library:Object;
		
		public function Asset(type:String):void
		{
			_type = type;
			
			_library = LIBRARY; 
			
			LIST.push( this );
			
			setName('');
		}
		
		sea3dgp function load(sea:SEAObject):void
		{
			setName( sea.name );
			
			sea.tag = this;
		}
		
		public function setName(val:String):void
		{
			if (_name == val) return;
			
			delete _library[_type+_name];
			
			_name = val;
			
			if (_name)
			{
				// prevent repeat names [for many objects use particle or group]
				while (_library[_type+_name])
				{
					_name += '@';
				}
				
				_library[_type+_name] = this;
			}
									
			dispatchEvent(new AssetEvent(AssetEvent.RENAME));
		}
		
		public function getName():String
		{
			return _name;
		}
		
		public function dispose():void
		{
			delete _library[_type+_name];
			
			LIST.splice( LIST.indexOf(this), 1);
			
			_library = null;
		}
	}
}