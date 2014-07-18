class Node {
	public var x, y:Number;
	public var vx, vy:Number;
	public var prevx, prevy:Number = 0;
	private var accnx, accny:Number;
	public var fx, fy:Number;
	private var drag:Boolean;
	private var active:Boolean;
	public var mymc:MovieClip;
	public var ind, parind:Number;
	public static var gravity:Number = 0.6;
	private static var weight:Number = 0.15;
	private static var bounceFactor:Number = 0.7;
	private static var dampFactor:Number = 0.95;
	private static var friction:Number = 0.7;
	private static var g:Number;
	private static var left, right, top, bottom;
	function Node(mymc:MovieClip, x:Number, y:Number, ind:Number, parind:Number) {
		init();
		this.parind = parind;
		this.ind = ind;
		this.x = x;
		this.y = y;
		this.mymc = mymc;
		pressfn();
		setpos();
		g = mymc.ball._height/2;
		left = _root.block_2._x+g;
		right = _root.block_3._x-g;
		bottom = _root.block_0._y-g;
		top = _root.block_1._y+g;
	}
	private function init():Void {
		fx = 0;
		fy = 0;
		vx = 0;
		vy = 0;
		prevx = 0;
		prevy = 0;
		accnx = 0;
		accny = 0;
		drag = false;
		active = false;
	}
	public function startdrag():Void {
		if (_root.mode == 2) {
			mymc.ball.gotoAndStop(2);
			if (_root.sel) {
				_root.setsel(1, parind, ind);
				_root.link();
			}
			else {
				active = true;
				_root.setsel(0, parind, ind);
				_root.sel = true;
			}
		}
		else if (_root.mode == 1) {
			_root.clearsel();
			drag = true;
			mymc.startDrag(true, left, top, right, bottom);
			prevx = mymc._x;
			prevy = mymc._y;
		}
		else if (_root.mode == 3) {
			_root.setsel(0, parind, ind);
			_root.deletenode();
		}
		_root.ready = false;
	}
	private function pressfn():Void {
		var t:Node = this;
		mymc.onMouseUp = function() {
			if (t.drag) {
				t.drag = false;
				stopDrag();
			}
			if (t.active) {
			}
			_root.ready = true;
		};
	}
	private function setpos():Void {
		if (!drag) {
			mymc._x = x;
			mymc._y = y;
		}
	}
	public function adjust():Void {
		if (!drag) {
			accnx = fx/weight;
			accny = gravity+(fy/weight);
			vx += accnx;
			vy += accny;
			damp();
			bound();
			x += vx;
			y += vy;
			checkhit();
			setpos();
		}
		else {
			x = mymc._x;
			y = mymc._y;
		}
	}
	private function damp():Void {
		vx = dampIt(vx);
		vy = dampIt(vy);
	}
	private function dampIt(v:Number):Number {
		return v*dampFactor;
	}
	private function checkhit():Void {
		if (y>bottom) {
			y = bottom;
			vy *= -1*bounceFactor;
			vx *= friction;
		}
		if (y<top) {
			y = top;
			vy *= -1*bounceFactor;
			vx *= friction;
		}
		if (x<left) {
			x = left;
			vx *= -1*bounceFactor;
			vy *= friction;
		}
		if (x>right) {
			x = right;
			vx *= -1*bounceFactor;
			vy *= friction;
		}
	}
	private function bound():Void {
		vx = boundIt(vx);
		vy = boundIt(vy);
	}
	private function boundIt(v:Number):Number {
		var maxV:Number = 30;
		if (v>maxV) {
			v = maxV;
		}
		if (v<-maxV) {
			v = -maxV;
		}
		if (Math.abs(v)<0.001) {
			v = 0;
		}
		return v;
	}
	public function clearsel():Void {
		mymc.ball.gotoAndStop(1);
	}
}
