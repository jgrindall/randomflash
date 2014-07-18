import mx.controls.*;
class PolyView {
	public var target_mc:MovieClip;
	private static var ballDepth:Number = 1;
	private static var polyDepth:Number = 2;
	private static var ballAlpha:Number = 70;
	public var rot:Matrix;
	public var startpos:Vector;
	public var newpos:Vector;
	public var radius:Number;
	public var init:Matrix;
	public var dragging:Boolean;
	public var poly;
	public function PolyView(radius:Number, target_mc:MovieClip, depth:Number, x:Number, y:Number) {
		this.radius = radius;
		this.target_mc = target_mc;
		target_mc.createEmptyMovieClip("container_mc", depth);
		target_mc.container_mc.createEmptyMovieClip("ball_mc", ballDepth);
		target_mc.container_mc.createEmptyMovieClip("poly_mc", polyDepth);
		target_mc.container_mc.ball_mc._x = x;
		target_mc.container_mc.ball_mc._y = y;
		target_mc.container_mc.poly_mc._x = x;
		target_mc.container_mc.poly_mc._y = y;
		init = new Matrix();
		rot = new Matrix();
		startpos = new Vector(0, 0, 0);
		newpos = new Vector(0, 0, 0);
		Mouse.addListener(this);
		makeBall();
		makeSurf();
	}
	public function makeSurf():Void {
		var p1:Vector = new Vector(0, 0, 0);
		var p2:Vector = new Vector(0.4, 0.4, 0.4);
		var p3:Vector = new Vector(-0.4, -0.4, 0);
		var v:Array = new Array(p1, p2, p3);
		poly = new Surface(v, target_mc.container_mc.poly_mc, radius);
	}
	public function makeBall():Void {
		target_mc.container_mc.ball_mc.clear();
		target_mc.container_mc.ball_mc.lineStyle(0.25, 0x999999, ballAlpha);
		var theta:Number = 0;
		var maxsteps:Number = 500;
		var n:Number;
		target_mc.container_mc.ball_mc.moveTo(this.radius, 0);
		target_mc.container_mc.ball_mc.beginFill(0xCCCCCC, 0);
		for (n=0; n<=maxsteps; n++) {
			theta = (n/maxsteps)*2*Math.PI;
			target_mc.container_mc.ball_mc.lineTo(this.radius*Math.cos(theta), this.radius*Math.sin(theta));
		}
		target_mc.container_mc.ball_mc.endFill();
	}
	public function coord(fx:Number, fy:Number):Vector {
		var a:Number = (fx-target_mc.container_mc.ball_mc._x)/radius;
		var b:Number = (target_mc.container_mc.ball_mc._y-fy)/radius;
		var c:Number;
		var sz2:Number = 1-a*a-b*b;
		if (sz2>=0) {
			c = Math.sqrt(sz2);
		}
		else {
			c = 0;
		}
		var ret:Vector = new Vector(a, b, c);
		return ret;
	}
	public function onMouseDown():Void {
		if (target_mc.container_mc.ball_mc.hitTest(_xmouse, _ymouse)) {
			startpos = coord(_xmouse, _ymouse);
			dragging = true;
		}
	}
	public function onMouseMove():Void {
		if (dragging) {
			if (insideball(_xmouse, _ymouse)) {
				newpos = coord(_xmouse, _ymouse);
				adjustmat(startpos, newpos);
				update();
			}
			else {
				notallowed();
			}
		}
	}
	public function insideball(fx:Number, fy:Number):Boolean {
		var x = (fx-target_mc.container_mc.ball_mc._x)/radius;
		var y = (target_mc.container_mc.ball_mc._y-fy)/radius;
		if (x*x+y*y<=1) {
			return true;
		}
		else {
			return false;
		}
	}
	private function adjustmat(p1:Vector, p2:Vector):Void {
		var axisangle:Array = new Array();
		axisangle = axis(p1, p2);
		rot = rmat(axisangle[0], axisangle[1]).mult(init);
	}
	private function adjustmatfinal(p1:Vector, p2:Vector):Void {
		var axisangle = axis(p1, p2);
		rot = rmat(axisangle[0], axisangle[1]).mult(init);
		init = rot;
	}
	private function axis(p1:Vector, p2:Vector):Array {
		var ret = new Array();
		var c:Vector = p1.cross(p2);
		var d:Number = p1.dot(p2);
		var tantheta:Number = c.getMod()/d;
		var theta:Number = Math.atan(tantheta);
		var theaxis:Vector = new Vector(0, 0, 0);
		if (theta<0) {
			theta += Math.PI;
		}
		if (Math.sin(theta) != 0) {
			theaxis = c.mult(1/Math.sin(theta));
		}
		else {
			theaxis = c.mult(1000);
		}
		ret[0] = theaxis;
		ret[1] = theta;
		return ret;
	}
	private function update() {
		poly.setR(rot);
		poly.drawMe();
	}
	public function onMouseUp():Void {
		if (dragging) {
			if (insideball(_xmouse, _ymouse)) {
				newpos = coord(_xmouse, _ymouse);
				adjustmatfinal(startpos, newpos);
				dragging = false;
				update();
			}
		}
	}
	private function rmat(axis:Vector, angle:Number):Matrix {
		var i:Number;
		var c:Number = Math.cos(angle);
		var s:Number = Math.sin(angle);
		var r:Array = new Array(2);
		for (i=0; i<=2; i++) {
			r[i] = new Array(2);
		}
		r[0][0] = c*1+(1-c)*axis.getX()*axis.getX()+s*0;
		r[0][1] = c*0+(1-c)*axis.getX()*axis.getY()+s*(-axis.getZ());
		r[0][2] = c*0+(1-c)*axis.getX()*axis.getZ()+s*(axis.getY());
		r[1][0] = c*0+(1-c)*axis.getY()*axis.getX()+s*(axis.getZ());
		r[1][1] = c*1+(1-c)*axis.getY()*axis.getY()+s*(0);
		r[1][2] = c*0+(1-c)*axis.getY()*axis.getZ()+s*(-axis.getX());
		r[2][0] = c*0+(1-c)*axis.getZ()*axis.getX()+s*(-axis.getY());
		r[2][1] = c*0+(1-c)*axis.getZ()*axis.getY()+s*(axis.getX());
		r[2][2] = c*1+(1-c)*axis.getZ()*axis.getZ()+s*(0);
		var ret:Matrix = new Matrix();
		ret.setM(r);
		return ret;
	}
	private function notallowed():Void {
		adjustmatfinal(startpos, newpos);
		dragging = false;
		update();
	}
}
