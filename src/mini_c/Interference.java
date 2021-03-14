package mini_c;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

class Arcs {
	int uses = 0;
	Set<Register> prefs = new HashSet<>();
	Set<Register> intfs = new HashSet<>();
	
	public int degree() {
		return this.prefs.size() + this.intfs.size();
	}
	
	public boolean contains(Register other) {
		return this.intfs.contains(other) || this.prefs.contains(other);
	}
}

class Interference {
	Map<Register, Arcs> graph = new HashMap<Register, Arcs>();
	
	Interference(Liveness lg) {
		
		lg.info.values()
			.stream()
			.filter(i -> {
				if (!(i.instr instanceof ERmbinop))
					return false;
				ERmbinop binop = (ERmbinop)i.instr;
				return (binop.m == Mbinop.Mmov) && (binop.r1 != binop.r2);
			})
			.forEach(i -> {
				ERmbinop binop = (ERmbinop)i.instr;
				this.graph.putIfAbsent(binop.r1, new Arcs());
				this.graph.putIfAbsent(binop.r2, new Arcs());
				this.graph.get(binop.r1).prefs.add(binop.r2);
				this.graph.get(binop.r2).prefs.add(binop.r1);
			});
		
		lg.info.values()
			.forEach(i -> {
				for (Register def : i.defs) {
					for (Register out : i.outs) {
						if (def != out) {
							this.graph.putIfAbsent(def, new Arcs());
							Arcs defArcs = this.graph.get(def);
							this.graph.putIfAbsent(out, new Arcs());
							Arcs outArcs = this.graph.get(out);
							defArcs.intfs.add(out);
							defArcs.prefs.remove(out);
							outArcs.intfs.add(def);
							outArcs.prefs.remove(def);
						}
					}
				}
			});
		
		lg.info.values()
			.forEach(i -> {
				for (Register use : i.uses) {
					this.graph.get(use).uses++;
				}
			});
	}
	
	public void print() {
	    System.out.println("interference:");
	    for (Register r: this.graph.keySet()) {
	    	Arcs a = this.graph.get(r);
	    	System.out.println("  " + r + " pref=" + a.prefs + " intf=" + a.intfs);
	    }
	}
	
	public boolean remove(Register reg) {
		for (Register v : this.graph.get(reg).intfs)
			this.graph.get(v).intfs.remove(reg);
		for (Register v : this.graph.get(reg).prefs)
			this.graph.get(v).prefs.remove(reg);
		return this.graph.remove(reg) != null;
	}
	
	public void merge(Register r1, Register r2) {
		
		Arcs a1 = this.graph.get(r1);
		Arcs a2 = this.graph.get(r2);
	
		for (Register rn : a2.prefs) {
			Arcs an = this.graph.get(rn);
			if (!an.intfs.contains(r1)) {
				an.prefs.add(r1);
			}
		}
		
		for (Register rn : a2.intfs) {
			Arcs an = this.graph.get(rn);
			an.prefs.remove(r1);
			an.intfs.add(r1);
		}
		
		a1.intfs.addAll(a2.intfs);
		a1.prefs.addAll(a2.prefs);
		a1.prefs.removeAll(a1.intfs);
		a1.prefs.remove(r1);
		
		this.remove(r2);
	}
}