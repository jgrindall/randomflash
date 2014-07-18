class Surface {
	public var vertices:Array;
	public var faces:Array;
	public var edges:Array;
	public var trun:Array;
	public var lightFill:Array;
	public var darkFill:Array;
	public var rot:Matrix;
	private var mc:MovieClip;
	public var radius:Number;
	private var normals:Array;
	private var midpoints:Array;
	private var longestMP:Number;
	public var faceindex:Array;
	private var nay:Array;
	public var filled:Boolean;
	//
	public function Surface(v:Array, f:Array, t:Array, lf:Array, df:Array, mc:MovieClip, radius:Number) {
		vertices = new Array();
		faces = new Array();
		trun = new Array();
		edges = new Array();
		lightFill = lf;
		darkFill = df;
		this.mc = mc;
		this.radius = radius;
		rot = new Matrix();
		normals = new Array();
		midpoints = new Array();
		faceindex = new Array();
		makeMessageBox();
		filled = true;
		setVF(v, f, t);
	}
	public function getV():Array {
		return vertices;
	}
	public function getF():Array {
		return faces;
	}
	public function getE():Array {
		return edges;
	}
	public function getT():Array {
		return trun;
	}
	public function makeMessageBox():Void {
		mc.createTextField("messTF", 1, 0, 0, 10, 10);
		mc.messTF.autoSize = true;
		mc.messTF.border = true;
		mc.messTF.background = true;
		mc.messTF.backgroundColor = 0xF3EC96;
		mc.messTF.text = "Drawing...";
	}
	public function setVF(v:Array, f:Array, t:Array) {
		showMessage();
		vertices = v;
		faces = f;
		trun = t;
		nay = getNay();
		setNormals();
		sortFaces();
		edges = new Array();
		setEdges();
		drawMe();
	}
	public function setEdges():Void {
		var fill:Number = 0;
		var i, j:Number;
		var v0, v1:Number;
		var done:Array = new Array();
		for (i=0; i<=vertices.length-1; i++) {
			done[i] = new Array();
			for (j=0; j<=vertices.length-1; j++) {
				done[i][j] = false;
			}
		}
		for (i=0; i<=faces.length-1; i++) {
			for (j=0; j<=faces[i].length-1; j++) {
				if (j == faces[i].length-1) {
					v0 = faces[i][j];
					v1 = faces[i][0];
				}
				else {
					v0 = faces[i][j];
					v1 = faces[i][j+1];
				}
				if (!done[v0][v1] && !done[v1][v0]) {
					edges[fill] = new Object();
					edges[fill].ver0 = Math.min(v0, v1);
					edges[fill].ver1 = Math.max(v0, v1);
										fill++;
					done[v0][v1] = true;
				}
			}
		}
	}
	public function setColor(l:Array, d:Array):Void {
		lightFill = l;
		darkFill = d;
		drawMe();
	}
	public function setFilled(f:Boolean):Void {
		filled = f;
		drawMe();
	}
	public function colr(i:Number):Number {
		//get colour depending on inclination
		var z:Number = (rot.image(normals[i])).getZ();
		//goes from light to dark
		var r:Number = darkFill[0]+((lightFill[0]-darkFill[0])*Math.abs(z));
		var g:Number = darkFill[1]+((lightFill[1]-darkFill[1])*Math.abs(z));
		var b:Number = darkFill[2]+((lightFill[2]-darkFill[2])*Math.abs(z));
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
	public function getFacesToDraw():Array {
		var i:Number;
		var fill:Number = 0;
		var facesToDraw:Array = new Array();
		for (i=0; i<=faces.length-1; i++) {
			if (isSeen(i)) {
				facesToDraw[fill] = new Array();
				facesToDraw[fill] = faces[i];
				faceindex[fill] = i;
				fill++;
			}
		}
		var facesToDraw2 = orderFaces(facesToDraw);
		return facesToDraw2;
	}
	public function setR(r:Matrix):Void {
		rot = r;
	}
	public function orderFaces(f:Array):Array {
		return f.sort(sortz)
		//this is to order them to be drawn in the right z order
		
		
	}
	function sortz(p:,q;){
		
		
	}
	
	public function isSeen(i:Number):Boolean {
		//is the face i pointing towards you?
		var n2:Vector = normals[i];
		var normal:Vector = rot.image(n2);
		if (normal.getZ()<0) {
			return false;
		}
		else {
			return true;
		}
	}
	public function setNormals():Void {
		var i:Number;
		longestMP = -1;
		for (i=0; i<=faces.length-1; i++) {
			//find normal for face i
			var v0:Vector = vertices[faces[i][0]];
			var v1:Vector = vertices[faces[i][1]];
			var v2:Vector = vertices[faces[i][faces[i].length-1]];
			//three adjacent vertices
			var e1:Vector = new Vector(v0.getX()-v1.getX(), v0.getY()-v1.getY(), v0.getZ()-v1.getZ());
			var e2:Vector = new Vector(v0.getX()-v2.getX(), v0.getY()-v2.getY(), v0.getZ()-v2.getZ());
			//edges of triangle to find normal
			midpoints[i] = getMidpoint(i);
			if (midpoints[i].getMod()>longestMP) {
				longestMP = midpoints[i].getMod();
			}
			//midpoint of that face
			var n:Vector = e1.cross(e2);
			//normal
			if (n.dot(midpoints[i])<0) {
				n.multme(-1);
			}
			n.multme(1/n.getMod());
			//make it a unit vector pointing outward
			normals[i] = n;
		}
	}
	public function getMidpoint(i):Vector {
		var j:Number;
		var mxc:Number = 0;
		var myc:Number = 0;
		var mzc:Number = 0;
		for (j=0; j<=faces[i].length-1; j++) {
			mxc += vertices[faces[i][j]].getX();
			myc += vertices[faces[i][j]].getY();
			mzc += vertices[faces[i][j]].getZ();
		}
		var mp:Vector = new Vector(mxc/(faces[i].length), myc/(faces[i].length), mzc/(faces[i].length));
		return mp;
	}
	public function conv(v:Vector):Vector {
		//convert vector v to flash position under the rotation matrix
		var rotpos = rot.image(v);
		var ret:Vector = new Vector(rotpos.x*radius, -rotpos.y*radius, rotpos.z*radius);
		return ret;
	}
	public function drawMe():Void {
		mc.clear();
		var f:Array;
		var i, j:Number;
		var point:Vector;
		if (filled) {
			mc.lineStyle(1, 0x000000, 100);
			f = getFacesToDraw();
			for (i=0; i<=f.length-1; i++) {
				point = conv(vertices[f[i][0]]);
				mc.moveTo(point.getX(), point.getY());
				mc.beginFill(colr(faceindex[i]), 100);
				for (j=1; j<=f[i].length-1; j++) {
					point = conv(vertices[f[i][j]]);
					mc.lineTo(point.getX(), point.getY());
				}
				point = conv(vertices[f[i][0]]);
				mc.lineTo(point.getX(), point.getY());
				mc.endFill();
			}
		}
		else {
			//grey
			f = faces;
			mc.lineStyle(1, 0xCCCCCC, 100);
			for (i=0; i<=f.length-1; i++) {
				if (!isSeen(i)) {
					mc.lineStyle(1, 0xCCCCCC, 50);
					point = conv(vertices[f[i][0]]);
					mc.moveTo(point.getX(), point.getY());
					for (j=1; j<=f[i].length-1; j++) {
						point = conv(vertices[f[i][j]]);
						mc.lineTo(point.getX(), point.getY());
					}
					point = conv(vertices[f[i][0]]);
					mc.lineTo(point.getX(), point.getY());
				}
			}
			mc.lineStyle(1, 0x000000, 100);
			for (i=0; i<=f.length-1; i++) {
				if (isSeen(i)) {
					point = conv(vertices[f[i][0]]);
					mc.moveTo(point.getX(), point.getY());
					for (j=1; j<=f[i].length-1; j++) {
						point = conv(vertices[f[i][j]]);
						mc.lineTo(point.getX(), point.getY());
					}
					point = conv(vertices[f[i][0]]);
					mc.lineTo(point.getX(), point.getY());
				}
			}
		}
		hideMessage();
	}
	public function truncate(slice:Number):Void {
		//slice is the index for the array how much we are slicing off.
		showMessage();
		//for each vertex go through the neighours
		var fill:Number = 0;
		var newVertices:Array = new Array();
		//new vertices
		var links:Array = new Array();
		var i, j, k:Number;
		var changeFaces:Array = new Array();
		var extraFaces:Array = new Array();
		if (trun[slice] != 0.5) {
			for (i=0; i<=vertices.length-1; i++) {
				links[i] = new Array();
				for (j=0; j<=nay[i].length-1; j++) {
					//links replace a vertex in an old face with the new ones
					//eg. links 12 is the new vertex between 1 and 2 closer to 1
					links[i][nay[i][j]] = fill;
					//new vertices are newv
					newVertices[fill] = new Vector();
					newVertices[fill] = vertices[i].movet(vertices[nay[i][j]], trun[slice]);
					fill++;
				}
			}
			//
			for (i=0; i<=faces.length-1; i++) {
				changeFaces[i] = new Array();
				for (j=0; j<=faces[i].length-1; j++) {
					//replace f[i][j] by links i,j and links ji
					if (j != faces[i].length-1) {
						changeFaces[i].push(links[faces[i][j]][faces[i][j+1]], links[faces[i][j+1]][faces[i][j]]);
					}
					else {
						changeFaces[i].push(links[faces[i][j]][faces[i][0]], links[faces[i][0]][faces[i][j]]);
					}
				}
			}
			// we have added each of the old faces perturbed a bit
			// they will be in the right order going round.
			// now add the new faces that correspond to the vertices!
			for (i=0; i<=vertices.length-1; i++) {
				extraFaces[i] = new Array();
				for (j=0; j<=nay[i].length-1; j++) {
					extraFaces[i].push(links[i][nay[i][j]]);
				}
			}
			// they wont be in the right order but we sort them later;
			for (i=0; i<=extraFaces.length-1; i++) {
				changeFaces[faces.length+i] = new Array();
				changeFaces[faces.length+i] = extraFaces[i];
			}
		}
		else {
			//slice is 0.5 so we only need 1 new vertex for each edge
			for (i=0; i<=vertices.length-1; i++) {
				links[i] = new Array();
				//make all links arrays;
			}
			var a, b:Number;
			for (i=0; i<=vertices.length-1; i++) {
				for (j=0; j<=nay[i].length-1; j++) {
					a = Math.min(i, nay[i][j]);
					b = Math.max(i, nay[i][j]);
					if (links[a][b] == undefined) {
						links[a][b] = fill;
						newVertices[fill] = new Vector();
						newVertices[fill] = vertices[i].movet(vertices[nay[i][j]], 0.5);
						fill++;
					}
				}
			}
			//
			for (i=0; i<=faces.length-1; i++) {
				changeFaces[i] = new Array();
				for (j=0; j<=faces[i].length-1; j++) {
					if (j != faces[i].length-1) {
						a = Math.min(faces[i][j], faces[i][j+1]);
						b = Math.max(faces[i][j], faces[i][j+1]);
						changeFaces[i].push(links[a][b]);
					}
					else {
						a = Math.min(faces[i][0], faces[i][j]);
						b = Math.max(faces[i][0], faces[i][j]);
						changeFaces[i].push(links[a][b]);
					}
				}
			}
			for (i=0; i<=vertices.length-1; i++) {
				extraFaces[i] = new Array();
				for (j=0; j<=nay[i].length-1; j++) {
					a = Math.min(i, nay[i][j]);
					b = Math.max(i, nay[i][j]);
					extraFaces[i].push(links[a][b]);
				}
			}
			for (i=0; i<=extraFaces.length-1; i++) {
				changeFaces[faces.length+i] = new Array();
				changeFaces[faces.length+i] = extraFaces[i];
			}
		}
		setVF(newVertices, changeFaces, trun);
		return;
	}
	public function getNay():Array {
		var adj:Array = new Array();
		var done:Array = new Array();
		//returns the neighbours of each vertex in order
		var i, j:Number;
		var prevv, nextv:Number;
		for (i=0; i<=vertices.length-1; i++) {
			adj[i] = new Array();
			done[i] = new Array();
		}
		for (i=0; i<=faces.length-1; i++) {
			//face i
			for (j=0; j<=faces[i].length-1; j++) {
				if (j == 0) {
					prevv = faces[i].length-1;
					nextv = 1;
				}
				else if (j == faces[i].length-1) {
					prevv = faces[i].length-2;
					nextv = 0;
				}
				else {
					prevv = j-1;
					nextv = j+1;
				}
				if (done[faces[i][j]][faces[i][prevv]] != true) {
					adj[faces[i][j]].push(faces[i][prevv]);
					done[faces[i][j]][faces[i][prevv]] = true;
				}
				if (done[faces[i][j]][faces[i][nextv]] != true) {
					adj[faces[i][j]].push(faces[i][nextv]);
					done[faces[i][j]][faces[i][nextv]] = true;
				}
			}
		}
		return adj;
	}
	function sortAFace(i:Number):Void {
		//sorts face i and makes sure they come in cyclic order
		var mid:Vector = getMidpoint(i);
		var k:Number;
		var temp:Array = new Array();
		var r:Number;
		var cr:Vector;
		var sin, cos, tan:Number;
		var vec1, vec2:Vector;
		//var vec1:Vector = new Vector(vertices[faces[i][0]].getX()-mid.getX(), vertices[faces[i][0]].getY()-mid.getY(), vertices[faces[i][0]].getZ()-mid.getZ());
		//var vec2:Vector = new Vector(vertices[faces[i][1]].getX()-mid.getX(), vertices[faces[i][1]].getY()-mid.getY(), vertices[faces[i][1]].getZ()-mid.getZ());
		//var prin:Vector = vec1.cross(vec2);
		var prin:Vector = normals[i];
		//		
		//we need a principal normal to fix a direction
		for (k=0; k<=faces[i].length-1; k++) {
			vec1 = new Vector(vertices[faces[i][0]].getX()-mid.getX(), vertices[faces[i][0]].getY()-mid.getY(), vertices[faces[i][0]].getZ()-mid.getZ());
			vec2 = new Vector(vertices[faces[i][k]].getX()-mid.getX(), vertices[faces[i][k]].getY()-mid.getY(), vertices[faces[i][k]].getZ()-mid.getZ());
			cr = vec1.cross(vec2);
			sin = cr.getMod()/(vec1.getMod()*vec2.getMod());
			if (cr.dot(prin)<0) {
				sin *= -1;
			}
			cos = vec1.dot(vec2)/(vec1.getMod()*vec2.getMod());
			temp.push({index:faces[i][k], angle:invtan(sin, cos)});
		}
		temp.sortOn("angle");
		for (k=0; k<=temp.length-1; k++) {
			faces[i][k] = temp[k].index;
		}
	}
	function sortFaces() {
		var i:Number;
		for (i=0; i<=faces.length-1; i++) {
			sortAFace(i);
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
	function dual():Void {
		showMessage();
		var i, xdotn:Number;
		var n:Vector;
		var bigr:Number = vertices[0].getMod();
		var anedge:Vector = new Vector(vertices[faces[0][0]].getX()-vertices[faces[0][1]].getX(), vertices[faces[0][0]].getY()-vertices[faces[0][1]].getY(), vertices[faces[0][0]].getZ()-vertices[faces[0][1]].getZ());
		var alpha:Number = anedge.getMod();
		var rsquared:Number = bigr*bigr-(1/4)*(alpha*alpha);
		var newVertices:Array = new Array();
		var fin:Array = new Array();
		var newFaces:Array = new Array();
		var sf:Number = -1;
		//scale factor so it fits in original shape the sphere exactly.
		for (i=0; i<=faces.length-1; i++) {
			newVertices[i] = new Vector();
			n = normals[i];
			xdotn = n.dot(vertices[faces[i][0]]);
			newVertices[i] = n.mult(rsquared/(xdotn));
			if (newVertices[i].getMod()>sf) {
				sf = newVertices[i].getMod();
			}
		}
		for (i=0; i<=faces.length-1; i++) {
			newVertices[i].multme(1/sf);
		}
		for (i=0; i<=vertices.length-1; i++) {
			newFaces[i] = new Array();
			newFaces[i] = facesIn(i);
		}
		setVF(newVertices, newFaces, trun);
	}
	function facesIn(i:Number):Array {
		var j, k:Number;
		var fin:Array = new Array();
		for (j=0; j<=faces.length-1; j++) {
			for (k=0; k<=faces[j].length-1; k++) {
				if (faces[j][k] == i) {
					fin.push(j);
				}
			}
		}
		return fin;
	}
	public function showMessage():Void {
		mc.messTF._visible = true;
	}
	public function hideMessage():Void {
		mc.messTF._visible = false;
	}
	public function expand(facesToUse:Array):Void {
		var f:Array = faces;
		//use facesToUse
	}
	public function destroy():Void {
		delete vertices;
		delete faces;
		delete trun;
		mc.clear();
	}
}
