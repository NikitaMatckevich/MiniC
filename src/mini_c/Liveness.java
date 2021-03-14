package mini_c;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

class LiveInfo {
           ERTL instr;
        Label[] succ;   						// successeurs
     Set<Label> pred = new HashSet<Label>();    // prédécesseurs
  Set<Register> defs = new HashSet<Register>(); // définitions
  Set<Register> uses = new HashSet<Register>(); // utilisations
  Set<Register> ins  = new HashSet<Register>(); // variables vivantes en entrée
  Set<Register> outs = new HashSet<Register>(); // variables vivantes en sortie
  
  private static String joinSetInString(Set<Register> s) {
	  LinkedList<String> words = new LinkedList<String>();
	  for (Register reg : s) {
		  words.push(reg.toString());
	  }
	  return String.join(", ", words);
  }
  
  @Override
  public String toString() {
    String msg = this.instr.toString()
    		   + ",   d={" + joinSetInString(this.defs)
    		   + "},  u={" + joinSetInString(this.uses)
    		   + "},  i={" + joinSetInString(this.ins )
    		   + "},  o={" + joinSetInString(this.outs)
    		   + "}";
    return msg;
  }
}

class Liveness {
	Map<Label, LiveInfo> info;
	
	private void print(Set<Label> visited, Label l) {
	    if (visited.contains(l))
	    	return;
	    visited.add(l);
	    LiveInfo li = this.info.get(l);
	    System.out.println("  " + String.format("%3s", l) + ": " + li.toString());
	    for (Label s: li.succ) {
	    	print(visited, s);
	    }
	}

	public void print(Label entry) {
	    print(new HashSet<Label>(), entry);
	}
	
	Liveness(ERTLgraph g) {
		
		this.info = new HashMap<Label, LiveInfo>();
		
		g.graph.forEach(
			(label, instruction) -> {
				LiveInfo i = new LiveInfo();
				i.defs.addAll(instruction.def());
				i.uses.addAll(instruction.use());
				i.succ = instruction.succ();
				i.instr = instruction;
				this.info.put(label, i);
			}
		);
		
		this.info.forEach(
			(curr, i) -> {
				for (Label next : i.succ) {
					this.info.get(next).pred.add(curr);
				}
			}		
		);
		
		Set<Label> setKildall = new HashSet<Label>();
		setKildall.addAll(this.info.keySet());
		
		while (!setKildall.isEmpty()) {
			Set<Register> insOld = new HashSet<Register>();
			Label any = setKildall.iterator().next();
			setKildall.remove(any);
			LiveInfo i = this.info.get(any);
			insOld.addAll(i.ins);
			for (Label next : i.succ) {
				i.outs.addAll(this.info.get(next).ins);
			}
			i.ins.clear();
			i.ins.addAll(i.outs);
			i.ins.removeAll(i.defs);
			i.ins.addAll(i.uses);
			if (!insOld.containsAll(i.ins)) {
				setKildall.addAll(i.pred);
			}
		}
	}
}