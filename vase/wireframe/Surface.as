class Surface {
	public var vertices:Array;
	public var rot:Matrix;
	private var mc:MovieClip;
	private var radius:Number;
	public function Surface(v:Array, mc:MovieClip, radius:Number) {
		this.mc = mc;
		this.radius = radius;
		rot = new Matrix();
		setV(v);
	}
	public function setV(v:Array):Void {
		vertices = v;
		drawMe();
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
		for (i=0; i<=vertices.length-1; i++) {
			point = conv(vertices[i][0]);
			mc.moveTo(point.getX(), point.getY());
			for (j=0; j<=vertices[i].length-1; j++) {
				point = conv(vertices[i][j]);
				mc.lineTo(point.getX(), point.getY());
			}
		}
		for (i=0; i<=vertices[0].length-1; i++) {
			point = conv(vertices[0][i]);
			mc.moveTo(point.getX(), point.getY());
			for (j=0; j<=vertices.length-1; j++) {
				point = conv(vertices[j][i]);
				mc.lineTo(point.getX(), point.getY());
			}
			point = conv(vertices[0][i]);
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
