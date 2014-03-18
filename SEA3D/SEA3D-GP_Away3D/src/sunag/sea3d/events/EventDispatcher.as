package sunag.sea3d.events
{	
	import flash.events.EventDispatcher;
	
	import sunag.sea3dgp;

	use namespace sea3dgp;
	
	public class EventDispatcher
	{
		sea3dgp var deps:int = 0;
		
		sea3dgp static const PROXY:Class = flash.events.EventDispatcher;
		
		private var _eDict:Object = {};
		
		public function addEventListener(type:String, listener:Function):void
		{
			if (!_eDict[type]) _eDict[type] = [];
			
			if (_eDict[type].indexOf( listener) == -1)
			{				
				_eDict[type].push( listener );
				++deps;
			}
		}
		
		public function removeEventListener(type:String, listener:Function):void
		{
			var list:Array = _eDict[type];
			
			delete list.splice( list.indexOf( listener, 1 ) );
						
			if (list.length == 0)
			{
				delete _eDict[type];
				--deps;
			}
		}
		
		public function hasEvent(type:String):Boolean
		{
			return _eDict[type];
		}
		
		public function dispatchEvent(e:Event):Boolean
		{
			e.preventDefault = false;
			e.target = this; 
			
			var list:Array = _eDict[e.type];												
			
			if (list) 
			{							
				for each(var listener:Function in list.concat())
				{
					listener(e);
					
					if (e.preventDefault) return false;
				}				
			}
			
			return true;
		}
	}
}