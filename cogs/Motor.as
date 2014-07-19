class Motor {
	private var drag:Boolean;
	public var mc:MovieClip;
	private var origx, origy:Number;
	function Motor(m:MovieClip, d:Number, x:Number, y:Number) {
		drag = false;
		mc = m.attachMovie("motormc", "motormc", d);
		mc._x = x;
		mc._y = y;
		origx = x;
		origy = y;
		pressfn();
	}
	private function pressfn():Void {
		var t:Motor = this;
		mc.onPress = function() {
			t.start_drag();
		};
		mc.onMouseUp = function() {
			t.stop_drag();
		};
	}
	public function reset():Void {
		mc._x = origx;
		mc._y = origy;
		large(true);
	}
	private function start_drag():Void {
		_root.showmsg(0);
		if (!_root.turning && _root.cogs.length>=1) {
			mx.behaviors.DepthControl.bringToFront(mc);
			mc.startDrag(true, -100, -100, 1000, 1000);
			drag = true;
			large(true);
		}
	}
	private function stop_drag():Void {
		if (drag) {
			drag = false;
			stopDrag();
			_root.snapmotor();
		}
	}
	public function large(b:Boolean):Void {
		if (b) {
			mc._xscale = 350;
			mc._yscale = 350;
		}
		else {
			mc._xscale = 100;
			mc._yscale = 100;
		}
	}
	public function setpos(x:Number, y:Number) {
		mc._x = x;
		mc._y = y;
	}
}
