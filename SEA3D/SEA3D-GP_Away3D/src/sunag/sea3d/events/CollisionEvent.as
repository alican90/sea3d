package sunag.sea3d.events
{
	

	public class CollisionEvent extends Event
	{
		public static const COLLISION:String = "collision";
		
		public function CollisionEvent(type:String)
		{
			super(type);			
		}
	}
}