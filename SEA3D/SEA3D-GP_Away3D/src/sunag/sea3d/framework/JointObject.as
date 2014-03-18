package sunag.sea3d.framework
{
	import away3d.entities.JointObject;
	
	import sunag.sea3dgp;
	import sunag.sea3d.objects.SEAJointObject;
	import sunag.sea3d.objects.SEAObject;
	
	use namespace sea3dgp;
	
	public class JointObject extends Object3D
	{
		sea3dgp var jointObj:away3d.entities.JointObject;
		
		sea3dgp var target:Mesh;
		
		public function JointObject()
		{
			super(jointObj = new away3d.entities.JointObject(null, 0, false));
		}
		
		public function setTarget(target:Mesh):void
		{
			if (this.target = target) 
			{
				jointObj.target = target.mesh;
			}
			
			jointObj.autoUpdate = target != null;
		}
		
		public function getTarget():Mesh
		{
			return target;
		}
		
		public function setJointIndex(index:Number):void
		{
			jointObj.jointIndex = index;
		}
		
		public function getJointIndex():Number
		{
			return jointObj.jointIndex;
		}
		
		public function setJointName(name:String):void
		{
			jointObj.jointName = name;
		}
		
		public function getJointName():String
		{
			return jointObj.jointName;
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	JOINT OBJECT
			//
			
			var jnt:SEAJointObject = sea as SEAJointObject;
			
			setTarget( jnt.target.tag );
			
			jointObj.jointIndex = jnt.joint;
		}
	}
}