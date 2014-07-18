class Surface {
	public var vertices:Array;
	public var edges:Array;
	public var rot:Matrix;
	private var mc:MovieClip;
	private var radius:Number;
	public function Surface(v:Array, mc:MovieClip, radius:Number) {
		vertices = v;
		this.mc = mc;
		this.radius = radius;
		rot = new Matrix();
		drawMe()
	}
	public function getV():Array {
		return vertices;
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
		var i, j:Number;
		var point:Vector;
		mc.lineStyle(1, 0x000000, 100);
		point = conv(vertices[0]);
		mc.moveTo(point.getX(), point.getY());
		for (i=1; i<=vertices.length-1; i++) {
			point = conv(vertices[i]);
			mc.lineTo(point.getX(), point.getY());
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
		delete vertices;
		mc.clear();
	}
}
