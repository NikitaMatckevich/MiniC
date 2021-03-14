package mini_c;

import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Set;
import java.util.Stack;

class StackVertex {
	Register r;
	Arcs a = new Arcs();
	Optional<Register> coloredFrom = Optional.empty();
	
	StackVertex(Register r, Arcs a, Optional<Register> o) {
		this.r = r;
		this.a = a;
		this.coloredFrom = o;
	}
}

class Coloring {
	Map<Register, Operand> colors = new HashMap<>();
	Stack<StackVertex> todo = new Stack<>();
	int numLocals = 0;
	
	private boolean findGeorge(Map<Register, Arcs> graph, Register other, Register self) {
		Arcs a = graph.get(self );
		Arcs b = graph.get(other);
		
		int card = Register.allocatable.size();
		
		return b.intfs.stream()
			.noneMatch(v -> !a.contains(v) && (graph.get(v).degree() >= card || (v.isHW() ^ self.isHW())))
			&& b.prefs.stream()
			.noneMatch(v -> !a.contains(v) && (graph.get(v).degree() >= card || (v.isHW() ^ self.isHW())));
	}
	
	private Operand findFreeColor(StackVertex v) {
		Set<Operand> forbidden = new HashSet<>();
		for (Register r : v.a.intfs)
			forbidden.add(colors.get(r));
		
		Optional<Operand> opReg = colors.values().stream()
		.filter(o -> o instanceof Reg && !forbidden.contains(o))
		.findAny();
		
		if (opReg.isPresent()) {
			return opReg.get();
		} else {
			Optional<Operand> opStack = colors.values().stream()
				.filter(o -> !forbidden.contains(o))
				.findAny();
			if (opStack.isPresent()) {
				return opStack.get();
			} else {
				return new Spilled(-8*(++numLocals));
			}
		}
	}
	
	private void select(Interference graph, Entry<Register, Arcs> e) {
		todo.push(new StackVertex(e.getKey(), e.getValue(), Optional.empty()));
		graph.remove(e.getKey());
	}
	
	private void doGeorgeAppel(Interference graph) {	
		
		int card = Register.allocatable.size();
		
		while (!graph.graph.isEmpty()) {
			
			/* SIMPLIFY */
			Optional<Entry<Register, Arcs>> vS = graph.graph.entrySet().stream()
				.filter(e -> {
					Arcs a = e.getValue();
					return e.getKey().isPseudo()
						&& a.prefs.isEmpty()
						&& (a.degree() < card);
					})
				.min(Comparator.comparingInt(e -> e.getValue().degree()));
			if (vS.isPresent()) {
				select(graph, vS.get());
				continue;
			}
			
			/* COALESCE */
			Iterator<Register> it = graph.graph.keySet().iterator();
			while (it.hasNext()) {
				Register r1 = it.next();
				Optional<Register> vC = graph.graph.get(r1).prefs.stream()
				    .filter(rn -> rn.isPseudo() && findGeorge(graph.graph, rn, r1))
				    .findAny();
				if (vC.isPresent()) {
					Register r2 = vC.get();
					todo.push(new StackVertex(r2, graph.graph.get(r2), Optional.of(r1)));
					graph.merge(r1, r2);
					break;
				}
			}
			if (it.hasNext()) {
				continue;
			}
			
			/* FREEZE */
			Optional<Entry<Register, Arcs>> vF = graph.graph.entrySet().stream()
				.filter(e -> e.getKey().isPseudo() && (e.getValue().degree() < card))
				.min(Comparator.comparingInt(e -> e.getValue().degree()));
			if (vF.isPresent()) {
				Register reg = vF.get().getKey();
				Arcs     arc = vF.get().getValue();
				for (Register other : arc.prefs) {
					graph.graph.get(other).prefs.remove(reg);
				}
				arc.prefs.clear();
				continue;
			}
			
			/* SPILL */
			Optional<Entry<Register, Arcs>> vO = graph.graph.entrySet().stream()
				.filter(e -> e.getKey().isPseudo())
				.min(Comparator.comparingInt(e -> { Arcs a = e.getValue(); return a.uses / a.degree(); }));
			if (vO.isPresent()) {
				select(graph, vO.get());
			} else {
				return;
			}
		}
	}
	
	private void assignColors() {
		Register.allocatable.forEach(r -> colors.put(r, new Reg(r)));	
		while (!todo.isEmpty()) {
			StackVertex v = todo.pop();	
			if (v.coloredFrom.isPresent()) {
				colors.put(v.r, colors.get(v.coloredFrom.get()));
			} else {
				colors.put(v.r, findFreeColor(v));
			}
		}
	}
	
	Coloring(Interference ig) {
		doGeorgeAppel(ig);
		assignColors();
	}
	
	public void print() {
	    System.out.println("coloring output:");
	    for (Register r: colors.keySet()) {
	    	Operand o = colors.get(r);
	    	System.out.println("  " + r + " --> " + o);
	    }
	}
}