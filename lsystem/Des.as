class Des {
	// (x, y, z, h, l, u)
	// h = heading
	// l = left
	// u = up
	public var pos:Vector;
	public var h:Vector;
	public var l:Vector;
	public var u:Vector;
	private var rotMU1:Matrix;
	private var rotMH1:Matrix;
	private var rotML1:Matrix;
	private var rotMU2:Matrix;
	private var rotMH2:Matrix;
	private var rotML2:Matrix;
	private var rotMH:Matrix;
	public function Des(p:Vector, h:Vector, l:Vector, u:Vector) {
		var mdata:Array = new Array();
		setall(p, h, l, u);
		//
		rotMU1 = new Matrix();
		mdata = new Array([Math.cos(_root.angle), -Math.sin(_root.angle), 0], [Math.sin(_root.angle), Math.cos(_root.angle), 0], [0, 0, 1]);
		rotMU1.setM(mdata);
		///
		rotMH1 = new Matrix();
		mdata = new Array([1, 0, 0], [0, Math.cos(_root.angle), -Math.sin(_root.angle)], [0, Math.sin(_root.angle), Math.cos(_root.angle)]);
		rotMH1.setM(mdata);
		//
		rotML1 = new Matrix();
		mdata = new Array([Math.cos(_root.angle), 0, -Math.sin(_root.angle)], [0, 1, 0], [Math.sin(_root.angle), 0, Math.cos(_root.angle)]);
		rotML1.setM(mdata);
		//
		rotMU2 = new Matrix();
		mdata = new Array([Math.cos(-_root.angle), -Math.sin(-_root.angle), 0], [Math.sin(-_root.angle), Math.cos(-_root.angle), 0], [0, 0, 1]);
		rotMU2.setM(mdata);
		///
		rotMH2 = new Matrix();
		mdata = new Array([1, 0, 0], [0, Math.cos(-_root.angle), -Math.sin(-_root.angle)], [0, Math.sin(-_root.angle), Math.cos(-_root.angle)]);
		rotMH2.setM(mdata);
		//
		rotML2 = new Matrix();
		mdata = new Array([Math.cos(-_root.angle), 0, -Math.sin(-_root.angle)], [0, 1, 0], [Math.sin(-_root.angle), 0, Math.cos(-_root.angle)]);
		rotML2.setM(mdata);
		//
		rotMH = new Matrix();
		mdata = new Array([1, 0, 0], [0, -1, 0], [0, 0, -1]);
		rotMH.setM(mdata);
	}
	public function update(lg:Number):Void {
		var newx1:Number = (pos.getX())+(h.getX()*lg);
		var newy1:Number = (pos.getY())+(h.getY()*lg);
		var newz1:Number = (pos.getZ())+(h.getZ()*lg);
		pos.setV(newx1, newy1, newz1);
	}
	public function setall(pt:Vector, ht:Vector, lt1:Vector, ut:Vector):Void {
		pos = pt;
		h = ht;
		l = lt1;
		u = ut;
	}
	public function getfullmatrix():Matrix {
		var m2:Matrix = new Matrix();
		var mdata:Array = new Array([h.getX(), h.getY(), h.getZ()], [l.getX(), l.getY(), l.getZ()], [u.getX(), u.getY(), u.getZ()]);
		m2.setM(mdata);
		return m2;
	}
	public function rotU1():Void {
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotMU1.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	public function rotL1():Void {
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotML1.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	//
	public function rotH2():Void {
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotMH2.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	public function rotH1():Void {
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotMH1.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	public function rotH():Void {
		//180 degrees
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotMH.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	public function rotU2():Void {
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotMU2.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	public function rotL2():Void {
		var m2:Matrix = getfullmatrix();
		var prod:Matrix = rotML2.mult(m2);
		h = prod.row(0);
		l = prod.row(1);
		u = prod.row(2);
	}
	public function traceme():Void {
		pos.traceit();
		h.traceit();
		l.traceit();
		u.traceit();
	}
}
