import mx.controls.*;
class PolyView {
	private var SD:ShapeData;
	public var target_mc:MovieClip;
	private static var ballDepth:Number = 1;
	private static var polyDepth:Number = 2;
	private static var poly2Depth:Number = 3;
	private static var listsDepth:Number = 4;
	private static var dataDepth:Number = 5;
	private static var ballAlpha:Number = 0;
	public var dualOn:Boolean;
	private static var listCompDepth:Number = 1;
	private static var dualButDepth:Number = 2;
	private static var colorButDepth:Number = 3;
	public var rot:Quat;
	public var startpos:Vector;
	public var newpos:Vector;
	public var radius:Number;
	public var init:Quat;
	public var dragging:Boolean;
	public var poly:Surface;
	public var poly2:Surface;
	private static var lightcolor:Array = new Array();
	private static var darkcolor:Array = new Array();
	public function PolyView(radius:Number, target_mc:MovieClip, depth:Number, x:Number, y:Number) {
		SD = new ShapeData();
		this.radius = radius;
		this.target_mc = target_mc;
		target_mc.createEmptyMovieClip("container_mc", depth);
		target_mc.container_mc.createEmptyMovieClip("ball_mc", ballDepth);
		target_mc.container_mc.createEmptyMovieClip("poly_mc", polyDepth);
		target_mc.container_mc.createEmptyMovieClip("poly2_mc", poly2Depth);
		target_mc.container_mc.createEmptyMovieClip("lists_mc", listsDepth);
		target_mc.container_mc.createEmptyMovieClip("data_mc", dataDepth);
		target_mc.container_mc.ball_mc._x = x;
		target_mc.container_mc.ball_mc._y = y;
		target_mc.container_mc.poly_mc._x = x;
		target_mc.container_mc.poly_mc._y = y;
		target_mc.container_mc.poly2_mc._x = x;
		target_mc.container_mc.poly2_mc._y = y;
		init = new Quat();
		rot = new Quat();
		startpos = new Vector(0, 0, 0);
		newpos = new Vector(0, 0, 0);
		Mouse.addListener(this);
		darkcolor[0] = new Array(111, 4, 4);
		lightcolor[0] = new Array(253, 202, 202);
		darkcolor[1] = new Array(130, 130, 2);
		lightcolor[1] = new Array(249, 253, 153);
		darkcolor[2] = new Array(4, 117, 35);
		lightcolor[2] = new Array(224, 254, 232);
		darkcolor[3] = new Array(4, 38, 117);
		lightcolor[3] = new Array(215, 227, 253);
		darkcolor[4] = new Array(117, 53, 100);
		lightcolor[4] = new Array(234, 208, 227);
		dualOn = false;
		makeBall();
		makeListBox(x, y);
		makeDualBut(x, y);
		makeColors(x, y);
		makeData(x, y);
		makeSurf();
	}
	public function makeData(x:Number, y:Number):Void {
		target_mc.container_mc.data_mc.createTextField("dataMess", 1, x+radius+10, y-radius, 100, 30);
		target_mc.container_mc.data_mc.dataMess.autoSize = true;
		target_mc.container_mc.data_mc.dataMess.text = "Vertices   Edges    Faces";
		//
		target_mc.container_mc.data_mc.createTextField("nameMess", 2, x+radius+10, y-radius-20, 100, 30);
		target_mc.container_mc.data_mc.nameMess.autoSize = true;
		target_mc.container_mc.data_mc.nameMess.text = "";
		//
		target_mc.container_mc.data_mc.createTextField("data2Mess", 3, x+radius+10, y-radius+20, 100, 30);
		target_mc.container_mc.data_mc.data2Mess.autoSize = true;
		target_mc.container_mc.data_mc.data2Mess.text = "";
	}
	public function makeListBox(x:Number, y:Number):Void {
		var thisP:PolyView = this;
		target_mc.container_mc.lists_mc.createClassObject(List, "listBox", listCompDepth);
		target_mc.container_mc.lists_mc.listBox.move(x-radius-190, y-radius);
		target_mc.container_mc.lists_mc.listBox.setSize(180, 300);
		target_mc.container_mc.lists_mc.listBox.dataProvider = ["PLATONIC SOLIDS", "tetrahedron", "cube", "octahedron", "dodecahedron", "icosahedron", "", "ARCHIMEDEAN SOLIDS", "truncated tetrahedron", "truncated cube", "cuboctahedron", "truncated octahedron", "truncated dodecahedron", "icosidodecahedron", "truncated icosahedron", "", "CATALAN SOLIDS", "triakis tetrahedron", "small triakis octahedron", "rhombic dodecahedron", "tetrakis hexahedron", "triakis icosahedron", "rhombic triacontahedron", "pentakis dodecahedron"];
		var listList:Object = new Object();
		listList.change = function(eventObject) {
			var s:String = String(eventObject.target.value);
			thisP.changeSurf(s);
		};
		target_mc.container_mc.lists_mc.listBox.addEventListener("change", listList);
	}
	public function makeDualBut(x:Number, y:Number):Void {
		var thisP:PolyView = this;
		target_mc.container_mc.lists_mc.createClassObject(Button, "dualBut", dualButDepth, {label:"Dual ON"});
		target_mc.container_mc.lists_mc.dualBut.move(x-radius-190, y-radius+40+300);
		target_mc.container_mc.lists_mc.dualBut.onPress = function() {
			var l:String = String(thisP.target_mc.container_mc.lists_mc.dualBut.label);
			if (l == "Dual ON") {
				thisP.target_mc.container_mc.lists_mc.dualBut.label = "Dual OFF";
				thisP.dualOn = true;
				thisP.makeDual();
			}
			else if (l == "Dual OFF") {
				thisP.target_mc.container_mc.lists_mc.dualBut.label = "Dual ON";
				thisP.dualOn = false;
				thisP.removeDual();
			}
		};
	}
	public function hex(g:Number):String {
		var r = g.toString(16);
		if (r.length == 1) {
			r = "0"+r;
		}
		return r;
	}
	public function makeDual() {
		poly2 = new Surface(poly.getV(), poly.getF(), poly.getT(), lightcolor[0], darkcolor[0], target_mc.container_mc.poly2_mc, radius);
		poly2.dual();
		poly2.setFilled(false);
		update();
	}
	function removeDual() {
		poly2.destroy();
		delete poly2;
	}
	public function makeColors(x:Number, y:Number):Void {
		var m:MovieClip;
		var thisP:PolyView = this;
		target_mc.container_mc.lists_mc.createTextField("colorMess", colorButDepth, x-radius-190, y-radius+10+300, 100, 30);
		target_mc.container_mc.lists_mc.colorMess.autoSize = true;
		target_mc.container_mc.lists_mc.colorMess.text = "Fill Colour:";
		var i:Number;
		var cl:String;
		var butSize:Number = 10;
		for (i=0; i<=lightcolor.length; i++) {
			thisP.target_mc.container_mc.lists_mc.createEmptyMovieClip("sqr_"+i, (colorButDepth+1+i));
			m = eval("thisP.target_mc.container_mc.lists_mc.sqr_"+i);
			m.ind = i;
			m._x = x-radius-115+(1.1*butSize*2)*i;
			m._y = y-radius+20+300;
			m.lineStyle(1, 0x000000, 100);
			m.moveTo(-butSize, -butSize);
			if (i == lightcolor.length) {
				cl = "0xffffff";
			}
			else {
				cl = "0x"+hex((lightcolor[i][0]+darkcolor[i][0])/2)+hex((lightcolor[i][1]+darkcolor[i][1])/2)+hex((lightcolor[i][2]+darkcolor[i][2])/2);
			}
			m.beginFill(Number(cl), 100);
			m.lineTo(butSize, -butSize);
			m.lineTo(butSize, butSize);
			m.lineTo(-butSize, butSize);
			m.lineTo(-butSize, -butSize);
			m.endFill();
			if (i == lightcolor.length) {
				m.lineStyle(2, 0xff0000, 100);
				var xfit:Number = 0.75;
				m.moveTo(xfit*butSize, xfit*butSize);
				m.lineTo(-xfit*butSize, -xfit*butSize);
				m.moveTo(xfit*butSize, -xfit*butSize);
				m.lineTo(-xfit*butSize, xfit*butSize);
			}
			m.onPress = function() {
				if (this.ind == lightcolor.length) {
					thisP.poly.setFilled(false);
				}
				else {
					thisP.poly.setFilled(true);
					thisP.poly.setColor(lightcolor[this.ind], darkcolor[this.ind]);
				}
			};
		}
	}
	public function setNameLabel(s:String):Void {
		target_mc.container_mc.data_mc.nameMess.text = s;
	}
	public function setVEF():Void {
		var e, v, f, echeck:Number;
		v = poly.getV().length;
		f = poly.getF().length;
		e = -2+f+v;
		echeck = poly.getE().length;
		target_mc.container_mc.data_mc.data2Mess.text = "     "+String(v);
		target_mc.container_mc.data_mc.data2Mess.text += "           "+String(e)+","+String(echeck);
		target_mc.container_mc.data_mc.data2Mess.text += "          "+String(f);
	}
	public function changeSurf(polyName:String):Void {
		setNameLabel(polyName);
		if (polyName == "tetrahedron") {
			poly.setVF(SD.tetra_vertices, SD.tetra_faces, SD.tetra_trun);
		}
		else if (polyName == "cube") {
			poly.setVF(SD.cube_vertices, SD.cube_faces, SD.cube_trun);
		}
		else if (polyName == "octahedron") {
			poly.setVF(SD.octa_vertices, SD.octa_faces, SD.octa_trun);
		}
		else if (polyName == "dodecahedron") {
			poly.setVF(SD.dodeca_vertices, SD.dodeca_faces, SD.dodeca_trun);
		}
		else if (polyName == "icosahedron") {
			poly.setVF(SD.icosa_vertices, SD.icosa_faces, SD.icosa_trun);
		}
		else if (polyName == "truncated tetrahedron") {
			poly.setVF(SD.tetra_vertices, SD.tetra_faces, SD.tetra_trun);
			poly.truncate(0);
		}
		else if (polyName == "triakis tetrahedron") {
			poly.setVF(SD.tetra_vertices, SD.tetra_faces, SD.tetra_trun);
			poly.truncate(0);
			poly.dual();
		}
		else if (polyName == "truncated cube") {
			poly.setVF(SD.cube_vertices, SD.cube_faces, SD.cube_trun);
			poly.truncate(0);
		}
		else if (polyName == "small triakis octahedron") {
			poly.setVF(SD.cube_vertices, SD.cube_faces, SD.cube_trun);
			poly.truncate(0);
			poly.dual();
		}
		else if (polyName == "cuboctahedron") {
			poly.setVF(SD.cube_vertices, SD.cube_faces, SD.cube_trun);
			poly.truncate(1);
		}
		else if (polyName == "rhombic dodecahedron") {
			poly.setVF(SD.cube_vertices, SD.cube_faces, SD.cube_trun);
			poly.truncate(1);
			poly.dual();
		}
		else if (polyName == "truncated octahedron") {
			poly.setVF(SD.octa_vertices, SD.octa_faces, SD.octa_trun);
			poly.truncate(0);
		}
		else if (polyName == "tetrakis hexahedron") {
			poly.setVF(SD.octa_vertices, SD.octa_faces, SD.octa_trun);
			poly.truncate(0);
			poly.dual();
		}
		else if (polyName == "truncated dodecahedron") {
			poly.setVF(SD.dodeca_vertices, SD.dodeca_faces, SD.dodeca_trun);
			poly.truncate(0);
		}
		else if (polyName == "triakis icosahedron") {
			poly.setVF(SD.dodeca_vertices, SD.dodeca_faces, SD.dodeca_trun);
			poly.truncate(0);
			poly.dual();
		}
		else if (polyName == "icosidodecahedron") {
			poly.setVF(SD.dodeca_vertices, SD.dodeca_faces, SD.dodeca_trun);
			poly.truncate(1);
		}
		else if (polyName == "rhombic triacontahedron") {
			poly.setVF(SD.dodeca_vertices, SD.dodeca_faces, SD.dodeca_trun);
			poly.truncate(1);
			poly.dual();
		}
		else if (polyName == "truncated icosahedron") {
			poly.setVF(SD.icosa_vertices, SD.icosa_faces, SD.icosa_trun);
			poly.truncate(0);
		}
		else if (polyName == "pentakis dodecahedron") {
			poly.setVF(SD.icosa_vertices, SD.icosa_faces, SD.icosa_trun);
			poly.truncate(0);
			poly.dual();
		}
		if (dualOn) {
			removeDual();
			makeDual();
		}
		setVEF();
	}
	public function makeSurf():Void {
		poly = new Surface(SD.tetra_vertices, SD.tetra_faces, SD.tetra_trun, lightcolor[0], darkcolor[0], target_mc.container_mc.poly_mc, radius);
		setNameLabel("tetrahedron");
		setVEF();
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
		rot = getNewQuat(p1, p2).mult(init);
	}
	public function getNewQuat(p1:Vector, p2:Vector):Quat {
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
		var newQuat:Quat = new Quat();
		newQuat.setQn(Math.cos(theta/2));
		var a:Vector=theaxis.mult(Math.sin(theta/2))
		newQuat.setQx(a.getX())
		newQuat.setQy(a.getY())
		newQuat.setQz(a.getZ())
		
		
		
		return newQuat;
	}
	private function adjustmatfinal(p1:Vector, p2:Vector):Void {
		rot = getNewQuat(p1, p2).mult(init);
		init = rot;
	}
	private function update() {
		poly.setR(rot);
		poly.drawMe();
		poly2.setR(rot);
		poly2.drawMe();
		//
		setVEF();
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
	private function notallowed():Void {
		adjustmatfinal(startpos, newpos);
		dragging = false;
		update();
	}
}
