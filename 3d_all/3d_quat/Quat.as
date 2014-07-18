class Quat {
	private var n:Number;
	private var x:Number;
	private var y:Number;
	private var z:Number;
	public function Quat() {
		setQn(0);
		setQx(0);
		setQy(0);
		setQz(1);
	}
	public function setQn(newn:Number) {
		n = newn;
	}
	public function setQx(newx:Number) {
		x = newx;
	}
	public function setQy(newy:Number) {
		y = newy;
	}
	public function setQz(newz:Number) {
		z = newz;
	}
	public function getQn():Number {
		return n;
	}
	public function getQx():Number {
		return x;
	}
	public function getQy():Number {
		return y;
	}
	public function getQz():Number {
		return z;
	}
	public function mult(a:Quat):Quat {
		var r:Quat = new Quat();
		r.setQn(n*a.getQn()-x*a.getQx()-y*a.getQy()-z*a.getQz());
		r.setQx(n*a.getQx()+x*a.getQn()+y*a.getQz()-z*a.getQy());
		r.setQy(n*a.getQy()-x*a.getQz()-y*a.getQn()+z*a.getQx());
		r.setQz(n*a.getQz()-x*a.getQy()-y*a.getQx()-z*a.getQn());
		return r;
	}
	public function image(v:Vector):Vector {
		var q1:Quat = new Quat();
		q1.setQn(0);
		q1.setQx(v.getX());
		q1.setQy(v.getY());
		q1.setQz(v.getZ());
		var q:Quat = mult(q1).mult(getConj());
		var r:Vector = new Vector(q.getQx(), q.getQy(), q.getQz());
		return r;
	}
	public function getConj():Quat {
		var r:Quat = new Quat();
		r.setQn(n);
		r.setQx(-x);
		r.setQy(-y);
		r.setQz(-z);
		return r;
	}
}
