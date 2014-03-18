/* Copyright (c) 2013 Sunag Entertainment
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE. */

package sunag.player
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	public class MouseLockButton extends Sprite
	{
		private var _color:uint = 0x101212;
		private var _mouseLock:Boolean = false;
		private var _enabled:Boolean = true;
		private var _over:Boolean = false;
		
		private var _bg:Sprite = new Sprite();
		private var _sprite:Sprite = new Sprite();
		
		public function MouseLockButton()
		{
			addChild(_bg);
			addChild(_sprite);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onInvalidateMouse);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			draw();						
		}
		
		private function onInvalidateMouse(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (!_enabled) return;
			stage.mouseLock = _mouseLock = true;			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onExitMouseLock);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE)
			{
				_mouseLock = false;								
				exitMouseLock();
			}
		}
		
		private function onExitMouseLock(e:MouseEvent):void
		{
			var stage:Stage = e.currentTarget as Stage;
						
			_mouseLock = false;
			if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				stage.mouseLock  = false;
						
			exitMouseLock();			
		}
		
		private function exitMouseLock():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onExitMouseLock);						
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onExitMouseLock);
			
			update();
		}
		
		private function update():void
		{
			if (_over) onMouseOver();
			else onMouseOut();
		}
				
		private function onMouseOver(e:MouseEvent=null):void
		{
			_over = true;
			_color = _enabled ? 0x0077FF : 0xFF7700;
			draw();
		}
		
		private function onMouseOut(e:MouseEvent=null):void
		{
			_over = false;
			_color = _mouseLock ? 0x0077FF : 0x101212;
			draw();
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value) return;			
			_enabled = value;			
			if (!_enabled) _mouseLock = false;
			update();
		}
		
		private function draw():void
		{
			_bg.graphics.clear();						
			_bg.graphics.beginFill(_color, .8);
			_bg.graphics.drawRoundRect(0, 0, 50, 50, 5);			
			
			_sprite.graphics.clear();
			
			_sprite.x = _sprite.y = 25;
			_sprite.graphics.beginFill(0xCCCCCC,.8);
			_sprite.graphics.drawCircle(0,0,15);
			_sprite.graphics.drawCircle(0,0,17);
			_sprite.graphics.drawCircle(0,0,5);
		}
	}
}