class Shape {
	private var ind:Number;
	private var mc, nodemc, linemc:MovieClip;
	public var nodes:Array;
	private var lines:Array;
	public var conn:Array;
	public var joins:Array;
	function Shape(cont:MovieClip, joins:Array, pos:Array, ind:Number) {
		this.joins = joins;
		this.ind = ind;
		conn = new Array();
		mc = cont.createEmptyMovieClip("mc_"+ind, ind);
		nodemc = mc.createEmptyMovieClip("nodemc", 1);
		linemc = mc.createEmptyMovieClip("linemc", 0);
		nodes = new Array(pos.length/2);
		lines = new Array(joins.length/2);
		var i:Number;
		var m:MovieClip;
		for (i=0; i<=nodes.length-1; i++) {
			conn[i] = new Array();
			nodemc.attachMovie("node", "node_"+i, i);
			m = nodemc["node_"+i];
			m.cacheAsBitmap = true;
			nodes[i] = new Node(m, pos[2*i], pos[(2*i)+1], i, ind);
		}
		if (lines.length>=2) {
			for (i=0; i<=lines.length-1; i++) {
				m = linemc.createEmptyMovieClip("line_"+i, i);
				m = linemc["line_"+i];
				conn[joins[2*i]][joins[(2*i)+1]] = true;
				conn[joins[(2*i)+1]][joins[2*i]] = true;
				lines[i] = new Line(m, nodes[joins[2*i]], nodes[joins[(2*i)+1]]);
			}
		}
	}
	public function getpos():Array {
		var r:Array = new Array();
		for (var i:Number = 0; i<=nodes.length-1; i++) {
			r.push(nodes[i].mymc._x);
			r.push(nodes[i].mymc._y);
		}
		return r;
	}
	public function moveme():Void {
		var tension:Number;
		var theta:Number;
		for (i=0; i<=nodes.length-1; i++) {
			nodes[i].fx = 0;
			nodes[i].fy = 0;
		}
		if (lines.length>=2) {
			for (var i:Number = 0; i<=lines.length-1; i++) {
				tension = lines[i].gettension();
				theta = Mathfn.gettheta(lines[i].n0.mymc, lines[i].n1.mymc);
				lines[i].n0.fx += tension*Math.cos(theta);
				lines[i].n0.fy += tension*Math.sin(theta);
				lines[i].n1.fx += -tension*Math.cos(theta);
				lines[i].n1.fy += -tension*Math.sin(theta);
			}
		}
		//now we have all the forces. adjust the nodes.               
		for (i=0; i<=nodes.length-1; i++) {
			nodes[i].adjust();
		}
		if (lines.length>=2) {
			for (var i:Number = 0; i<=lines.length-1; i++) {
				lines[i].drawme();
			}
		}
	}
	public function clearsel():Void {
		var i:Number;
		for (i=0; i<=nodes.length-1; i++) {
			nodes[i].clearsel();
		}
	}
	public function checkhit() {
		var i:Number;
		for (i=0; i<=nodes.length-1; i++) {
			if (nodes[i].mymc.hitTest(_xmouse, _ymouse) && _root.ready) {
				nodes[i].startdrag();
				_root.hit = true;
			}
		}
	}
	public function deleteme():Void {
		removeMovieClip(mc);
	}
}
