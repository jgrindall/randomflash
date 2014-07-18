class Surface {
	public var v:Array;
	public var j:Array;
	public var d:Array;
	public var rot:Matrix;
	private var mc:MovieClip;
	private var radius:Number;
	private var thick, clr:Array;
	public function Surface(v:Array, j:Array, d:Array, mc:MovieClip, radius:Number) {
		this.v = v;
		this.j = j;
		this.d = d;
		this.mc = mc;
		this.radius = radius;
		thick = new Array(3, 3, 2, 1);
		clr = new Array(0x44522E, 0x325728, 0x1F612C, 0x136C40);
		rot = new Matrix();
		drawMe();
	}
	public function clearall():Void {
		mc.clear();
		delete mc;
	}
	public function getV():Array {
		return v;
	}
	public function setR(r:Matrix):Void {
		rot = r;
	}
	public function conv(v:Vector):Vector {
		//convert vector v to flash position under the rotation matrix
		var rotpos = rot.image(v);
		var ret:Vector = new Vector(rotpos.x*radius, -rotpos.y*radius, rotpos.z*radius);
		return ret;
	}
	public function drawMe():Void {
		mc.clear();
		var i:Number;
		var point:Vector;
		point = conv(v[0]);
		mc.moveTo(point.getX(), point.getY());
		for (i=1; i<=v.length-1; i++) {
			if (d[i]<=3) {
				mc.lineStyle(thick[d[i]], clr[d[i]], 100);
			}
			else {
				mc.lineStyle(0.5, 0x136C40, 75);
			}
			point = conv(v[i]);
			if (j[i] == 1) {
				mc.lineTo(point.getX(), point.getY());
			}
			else {
				mc.moveTo(point.getX(), point.getY());
			}
		}
	}
	function invtan(s:Number, c:Number):Number {
		var tantheta, theta;
		if (c<0) {
			theta = Math.atan(s/c)+Math.PI;
		}
		else if (c>=0) {
			theta = Math.atan(s/c);
		}
		if (theta<0) {
			theta += 2*Math.PI;
		}
		return theta;
	}
	public function destroy():Void {
		delete v;
		delete j;
		mc.clear();
	}
}
