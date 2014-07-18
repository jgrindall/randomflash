class Matrix {
	var m = new Array();
	public function Matrix() {
		var iddata = new Array([1, 0, 0], [0, 1, 0], [0, 0, 1]);
		setM(iddata);
	}
	public function setM(m1) {
		m = m1;
	}
	public function getM():Matrix {
		return m;
	}
	public function row(i):Vector {
		var v:Vector = new Vector(m[i][0], m[i][1], m[i][2]);
		return v;
	}
	public function mult(a:Matrix):Matrix {
		var i, j, k:Number;
		var r:Array = new Array();
		for (i=0; i<=2; i++) {
			r[i] = new Array();
			for (j=0; j<=2; j++) {
				r[i][j] = 0;
				for (k=0; k<=2; k++) {
					r[i][j] += m[i][k]*a.m[k][j];
				}
			}
		}
		var prod:Matrix = new Matrix();
		prod.setM(r);
		return prod;
	}
	public function traceit():Void {
		var i, j;
		for (i=0; i<=2; i++) {
			trace(m[i][0]+","+m[i][1]+","+m[i][2]);
		}
	}
	public function det(a:Matrix):Number {
		//expand along the 1st row
		var cf0 = a.m[1][1]*a.m[2][2]-a.m[1][2]*a.m[2][1];
		var cf1 = a.m[1][0]*a.m[2][2]-a.m[1][2]*a.m[2][0];
		var cf2 = a.m[1][0]*a.m[2][1]-a.m[2][0]*a.m[1][1];
		return (a.m[0][0]*cf0-a.m[0][1]*cf1+a.m[0][2]*cf2);
	}
	public function image(v:Vector):Vector {
		//find the image of v under rotation matrix m
		var a:Number = v.x*m[0][0]+v.y*m[0][1]+v.z*m[0][2];
		var b:Number = v.x*m[1][0]+v.y*m[1][1]+v.z*m[1][2];
		var c:Number = v.x*m[2][0]+v.y*m[2][1]+v.z*m[2][2];
		var r:Vector = new Vector(a, b, c);
		return r;
	}
}
