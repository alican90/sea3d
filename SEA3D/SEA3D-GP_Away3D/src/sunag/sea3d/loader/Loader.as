package sunag.sea3d.loader
{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import sunag.sea3dgp;
	
	use namespace sea3dgp;
	
	public class Loader extends EventDispatcher
	{
		sea3dgp var _description:String;
		
		sea3dgp var request:URLRequest;
		sea3dgp var data:ByteArray;
		
		public var tag:*;
		
		public function Loader(description:String)
		{
			_description = description;
		}
		
		public function get streaming():Boolean
		{
			return true;
		}
		
		public function get bytesLoaded():Number
		{
			return 0;
		}
		
		public function get bytesTotal():Number
		{
			return 0;
		}
		
		public function get description():String
		{
			return _description;
		}
		
		protected function dispatchProgress():void
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS));
		}
		
		protected function dispatchComplete():void
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE));
		}
		
		sea3dgp function onLoad():void
		{
		}
		
		public function load(request:URLRequest):void
		{
			this.request = request;
		}
		
		public function loadBytes(data:ByteArray):void
		{
			this.data = data;
		}
	}
}