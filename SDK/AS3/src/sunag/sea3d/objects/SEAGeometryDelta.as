/*
*
* Copyright (c) 2013 Sunag Entertainment
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in
* the Software without restriction, including without limitation the rights to
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
* the Software, and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;
	
	public class SEAGeometryDelta extends SEAGeometryBase 
	{
		public static const TYPE:String = "geDL";				
								
		public static var JOINT_STRIDE:uint = 3;
		
		public function SEAGeometryDelta(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}			
		
		protected function readInteger():uint
		{
			var v:int = data.readUnsignedByte(),
				r:int = v & 0x7F;
			
			if ((v & 0x80) != 0)
			{
				v = data.readUnsignedByte();
				r |= (v & 0x7F) << 7;
				
				if ((v & 0x80) != 0)
				{
					v = data.readUnsignedByte();
					r |= (v & 0x7F) << 13;
				}
			}
			
			return r;
		}
		
		override public function load():void
		{
			attrib = data.readUnsignedShort();
			
			numVertex = readInteger();
			
			var i:int, j:int, len:uint = numVertex*3, vec:Vector.<Number>,
				readNumber:Function,  delta:Number, numDiv:Number;
						
			if (attrib & 1)
			{
				readNumber = data.readByte;
				numDiv = 0xFF / 2; // compiler optimize this
			}
			else
			{
				readNumber = data.readShort;
				numDiv = 0xFFFF / 2; // compiler optimize this
			}
			
			// NORMAL
			if (attrib & 4)
			{
				delta = data.readFloat();				
				normal = new Vector.<Number>(len);										
				
				i = 0;
				while (i < len) 			
					normal[i++] = (readNumber() / numDiv) * delta;	
			}
			
			// TANGENT
			if (attrib & 8)
			{
				delta = data.readFloat();		
				tangent = new Vector.<Number>(len);
				
				i = 0;
				while (i < len) 			
					tangent[i++] = (readNumber() / numDiv) * delta;
			}
			
			// UVS
			if (attrib & 32)
			{				
				uv = [];
				uv.length = data.readUnsignedByte();
				
				i = 0;
				while ( i < uv.length )
				{
					// UV_VERTEX
					delta = data.readFloat();					
					uv[i++] = vec = new Vector.<Number>(numVertex * 2);
					
					j = 0; 
					while(j < vec.length) 
						vec[j++] = (readNumber() / numDiv) * delta;		
				}
			}						
			
			// JOINT_INDEXES | WEIGHTS
			if (attrib & 64)
			{
				jointPerVertex = data.readUnsignedByte();
				
				var jntLen:uint = numVertex * jointPerVertex;
				
				joint = new Vector.<Number>(jntLen);
				weight = new Vector.<Number>(jntLen);
				
				i = 0;
				while (i < jntLen) 		
					joint[i++] = readInteger() * JOINT_STRIDE;
				
				i = 0;
				while (i < jntLen) 		
					weight[i++] = (readNumber() / numDiv) * 1; 
			}						
			
			// VERTEX_COLOR
			if (attrib & 128)
			{
				var colorAttrib:int = data.readUnsignedByte(),
					numColor:int = (((colorAttrib & 64) >> 6) | ((colorAttrib & 128) >> 6)) + 1,
					colorCount:int = numVertex * 4;					
				
				color = [];
				color.length = colorAttrib & 15;
				
				for(i = 0; i < color.length; i++)
				{								
					var vColor:Vector.<Number> = new Vector.<Number>(colorCount);
					
					switch(numColor)
					{
						case 1:
							j = 0;					
							while (j < colorCount)
							{
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = 0;
								vColor[j++] = 0;
								vColor[j++] = 1;
							}
							break;
						
						case 2:
							j = 0;					
							while (j < colorCount)
							{
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = 0;
								vColor[j++] = 1;
							}
							break;
						
						case 3:
							j = 0;					
							while (j < colorCount)
							{
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = 1;
							}
							break;
						
						case 4:
							j = 0;					
							while (j < colorCount)
							{
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = data.readUnsignedByte() / 0xFF;
								vColor[j++] = data.readUnsignedByte() / 0xFF;
							}
							break;
					}										
					
					color[i] = vColor;
				}
			}
							
			// VERTEX
			delta = data.readFloat();	
			
			vertex = new Vector.<Number>(len);
			
			i = 0; 
			while(i < vertex.length) 
				vertex[i++] = (readNumber() / numDiv) * delta;
			
			indexes = [];
			indexes.length = data.readUnsignedByte();			
			
			var vecUint:Vector.<uint>;
			
			// INDEXES
			if (attrib & 2)
			{
				// POLYGON
				
				for (i=0;i<indexes.length;i++)
				{
					var polyCount:uint = readInteger();
					
					indexes[i] = vecUint = new Vector.<uint>();
										
					for(j = 0; j < polyCount; j++) 
					{
						var a:int = readInteger(),
							b:int = readInteger(),
							c:int = readInteger(),
							d:int = readInteger();
						
						
						vecUint.push(a);
						vecUint.push(b);
						vecUint.push(c);
						
						if (d > 0)
						{
							vecUint.push(c);
							vecUint.push(d + 1);
							vecUint.push(a);																		
						}
						else continue;							
					}
				}	
			}
			else
			{
				// TRIANGLE
				
				for (i=0;i<indexes.length;i++)
				{
					indexes[i] = vecUint = new Vector.<uint>(readInteger() * 3);	
					j = 0; 
					while(j < vecUint.length) 
						vecUint[j++] = readInteger();			
				}
			}
		}			
	}
}
