class Line {
	public var n0, n1:Node;
	public var mymc:MovieClip;
	private var natL:Number;
	private var parind:Number;
	private var ind:Number;
	private static var lambda:Number = 0.02;
	function Line(mymc:MovieClip, n0:Node, n1:Node, ind:Number, parind:Number) {
		var t:Line = this;
		this.parind = parind;
		this.ind = ind;
		this.n0 = n0;
		this.n1 = n1;
		this.mymc = mymc;
		natL = 50;
		//natL = Mathfn.getdist(n0.mymc, n1.mymc);
		drawme();
		mymc.onPress = function() {
			if (_root.mode == 3) {
				_root.delete_edge(t.parind, t.ind);
			}
		};
	}
	public function drawme() {
		mymc.clear();
		mymc.lineStyle(4, 0xffffff, 0);
		mymc.moveTo(n0.x, n0.y);
		mymc.lineTo(n1.x, n1.y);
		mymc.lineStyle(1.5, 0x000000, 100);
		mymc.moveTo(n0.x, n0.y);
		mymc.lineTo(n1.x, n1.y);
		/*
		var gap:Number = 1.5;
		var theta:Number = Mathfn.gettheta(n0.mymc, n1.mymc);
		mymc.lineStyle(0.25, 0x000000, 100);
		mymc.moveTo(n0.x+gap*Math.cos(theta+Math.PI/2), n0.y+gap*Math.sin(theta+Math.PI/2));
		mymc.lineTo(n1.x+gap*Math.cos(theta+Math.PI/2), n1.y+gap*Math.sin(theta+Math.PI/2));
		mymc.lineStyle(0.25, 0x000000, 100);
		mymc.moveTo(n0.x+gap*Math.cos(theta+3*Math.PI/2), n0.y+gap*Math.sin(3*theta+Math.PI/2));
		mymc.lineTo(n1.x+gap*Math.cos(theta+3*Math.PI/2), n1.y+gap*Math.sin(3*theta+Math.PI/2));
		*/
	}
	public function gettension():Number {
		var L:Number = Mathfn.getdist(n0.mymc, n1.mymc);
		var extension:Number = L-natL;
		var t:Number = lambda*extension;
		return t;
	}
}
