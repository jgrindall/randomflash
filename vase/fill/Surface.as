class Surface {
	public var wireframetf:Boolean;
	public var vertices:Array;
	public var faces:Array;
	public var normals:Array;
	public var midpoints:Array;
	public var light, dark:Array;
	public var rot:Matrix;
	private var mc:MovieClip;
	private var radius:Number;
	public function Surface(v:Array, mc:MovieClip, radius:Number) {
		wireframetf = false;
		faces = new Array();
		normals = new Array();
		midpoints = new Array();
		this.mc = mc;
		this.radius = radius;
		rot = new Matrix();
		setV(v);
	}
	public function setcolors(l:Array, d:Array) {
		light = l;
		dark = d;
		drawMe();
	}
	public function setV(v:Array):Void {
		vertices = v;
		//trace(vertices.length)
		getFaces();
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
	public function getFaces():Void {
		faces = new Array();
		faces.clear();
		var i, j:Number;
		var v1, v2:Vector;
		var nexti, nextj:Number;
		for (i=0; i<=vertices.length-1; i++) {
			if (i != vertices.length-1) {
				nexti = i+1;
			}
			else {
				nexti = 0;
			}
			faces[i] = new Array();
			normals[i] = new Array();
			midpoints[i] = new Array();
			for (j=0; j<=vertices[0].length-2; j++) {
				nextj = j+1;
				faces[i][j] = new Array();
				faces[i][j][0] = vertices[i][j];
				faces[i][j][1] = vertices[i][nextj];
				faces[i][j][2] = vertices[nexti][nextj];
				faces[i][j][3] = vertices[nexti][j];
				v1 = new Vector(faces[i][j][1].getX()-faces[i][j][0].getX(), faces[i][j][1].getY()-faces[i][j][0].getY(), faces[i][j][1].getZ()-faces[i][j][0].getZ());
				v2 = new Vector(faces[i][j][3].getX()-faces[i][j][0].getX(), faces[i][j][3].getY()-faces[i][j][0].getY(), faces[i][j][3].getZ()-faces[i][j][0].getZ());
				normals[i][j] = (v1.cross(v2));
				normals[i][j].normalizeMe();
				midpoints[i][j] = new Vector((faces[i][j][0].getX()+faces[i][j][1].getX()+faces[i][j][2].getX()+faces[i][j][3].getX())/4, (faces[i][j][0].getY()+faces[i][j][1].getY()+faces[i][j][2].getY()+faces[i][j][3].getY())/4, (faces[i][j][0].getZ()+faces[i][j][1].getZ()+faces[i][j][2].getZ()+faces[i][j][3].getZ())/4);
			}
		}
	}
	public function drawMe():Void {
		if (wireframetf) {
			drawMeWireframe();
		}
		else {
			drawMeFill();
		}
	}
	public function drawMeFill():Void {
		var faceslist:Array = new Array();
		var i, j, c:Number;
		for (i=0; i<=faces.length-1; i++) {
			for (j=0; j<=faces[0].length-1; j++) {
				faceslist.push({faces:faces[i][j], mpz:conv(midpoints[i][j]).getZ()/radius, normal:normals[i][j]});
			}
		}
		faceslist.sortOn("mpz", Array.NUMERIC);
		mc.clear();
		var point1, point2, point3, point4:Vector;
		mc.lineStyle(1, 0x000000, 100);
		for (i=0; i<=faceslist.length-1; i++) {
			//trace("z: "+faceslist[i].mpz);
			point1 = conv(faceslist[i].faces[0]);
			point2 = conv(faceslist[i].faces[1]);
			point3 = conv(faceslist[i].faces[2]);
			point4 = conv(faceslist[i].faces[3]);
			c = conv(faceslist[i].normal).getZ()/radius;
			mc.beginFill(colr(c), 100);
			mc.moveTo(point1.getX(), point1.getY());
			mc.lineTo(point2.getX(), point2.getY());
			mc.lineTo(point3.getX(), point3.getY());
			mc.lineTo(point4.getX(), point4.getY());
			mc.lineTo(point1.getX(), point1.getY());
			mc.endFill();
		}
	}
	public function drawMeWireframe():Void {
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
	public function colr(z:Number):Number {
		//trace("colr: "+z);
		//get colour depending on inclination
		var darkfactor:Number = 0.1;
		if (z>0) {
			z *= darkfactor;
		}
		var r:Number = dark[0]+((light[0]-dark[0])*Math.abs(z));
		var g:Number = dark[1]+((light[1]-dark[1])*Math.abs(z));
		var b:Number = dark[2]+((light[2]-dark[2])*Math.abs(z));
		var rgb:String = "0x"+hex(r)+hex(g)+hex(b);
		return Number(rgb);
	}
	function hex(g:Number):String {
		var r = g.toString(16);
		if (r.length == 1) {
			r = "0"+r;
		}
		return r;
	}
	public function invtan(s:Number, c:Number):Number {
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
	public function setWF(tf:Boolean):Void {
		wireframetf = tf;
	}
}
