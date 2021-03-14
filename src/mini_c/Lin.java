package mini_c;

import java.util.HashSet;

class Lin implements LTLVisitor {
	private LTLgraph cfg; // graphe en cours de traduction
	private X86_64 asm = new X86_64(); // code en cours de construction
	private HashSet<Label> visited = new HashSet<Label>(); // instructions déjà traduites
	
	private void lin(Label l) {
	    if (visited.contains(l)) {
	    	asm.needLabel(l);
	    	asm.jmp(l.name);
	    } else {
	    	visited.add(l);
	    	asm.label(l);
	    	cfg.graph.get(l).accept(this);
	    }
	}

	@Override
	public void visit(Lload o) {
		asm.movq("" + o.i + "(" + o.r1.toString() + ")", o.r2.toString());
		lin(o.l);
	}

	@Override
	public void visit(Lstore o) {
		asm.movq(o.r1.toString(), "" + o.i + "(" + o.r2.toString() + ")");
		lin(o.l);
	}

	@Override
	public void visit(Lmubranch o) {
		asm.needLabel(o.l2);
		if (o.m instanceof Mjz) {
			asm.testq(o.r.toString(), o.r.toString()).jnz(o.l2.toString());
		} else if (o.m instanceof Mjnz) {
			asm.testq(o.r.toString(), o.r.toString()).jz(o.l2.toString());
		} else if (o.m instanceof Mjlei) {
			int n = ((Mjlei)o.m).n;
			if (n == 0) {
				asm.testq(o.r.toString(), o.r.toString()).jg(o.l2.toString());
			} else {
				asm.cmpq(n, o.r.toString()).jg(o.l2.toString());
			}
		} else if (o.m instanceof Mjgi) {
			int n = ((Mjgi)o.m).n;
			if (n == 0) {
				asm.testq(o.r.toString(), o.r.toString()).jle(o.l2.toString());
			} else {
				asm.cmpq(n, o.r.toString()).jle(o.l2.toString());
			}
		} else {
			String msg = "unknown unary branch type";
			throw new Error(msg);
		}
		lin(o.l1);
		lin(o.l2);
	}

	@Override
	public void visit(Lmbbranch o) {
		asm.needLabel(o.l2);
		asm.cmpq(o.r1.toString(), o.r2.toString());
		switch (o.m) {
		case Mjl:  asm.jge(o.l2.toString()); break;
		case Mjle: asm.jg (o.l2.toString()); break;
		default:
			String msg = "unknown binary branch type";
			throw new Error(msg);
		}
		lin(o.l1);
		lin(o.l2);
	}

	@Override
	public void visit(Lgoto o) {
		lin(o.l);
	}

	@Override
	public void visit(Lreturn o) {
		asm.ret();
	}

	@Override
	public void visit(Lconst o) {
		asm.movq(o.i, o.o.toString());
		lin(o.l);
	}

	@Override
	public void visit(Lmunop o) {
		if (o.m instanceof Maddi) {
			int n = ((Maddi)o.m).n;
			if (n == 1) {
				asm.incq(o.o.toString());
			} else if (n == -1) {
				asm.decq(o.o.toString());
			} else {
				asm.addq("$" + n, o.o.toString());
			}
		} else if (o.m instanceof Msetei) {
			String tmp = Register.tmp2.toString() + "b";
			asm.cmpq(((Msetei)o.m).n, o.o.toString()).sete(tmp).movzbq(tmp, o.o.toString());
		} else if (o.m instanceof Msetnei) {
			String tmp = Register.tmp2.toString() + "b";
			asm.cmpq(((Msetnei)o.m).n, o.o.toString()).setne(tmp).movzbq(tmp, o.o.toString());
		} else {
			String msg = "unknown unary operation type";
			throw new Error(msg);
		}
		lin(o.l);
	}

	@Override
	public void visit(Lmbinop o) {
		String tmp = Register.tmp2.toString();
		switch(o.m) {
		case Mmov:   asm.movq (o.o1.toString(), o.o2.toString()); break;
		case Madd:   asm.addq (o.o1.toString(), o.o2.toString()); break;
		case Msub:   asm.subq (o.o1.toString(), o.o2.toString()); break;
		case Mmul:   asm.imulq(o.o1.toString(), o.o2.toString()); break;
		case Mdiv:	 String msb = Register.rdx.toString(); asm.movq(msb, tmp).cqto().idivq(o.o1.toString()).movq(tmp, msb); break;
		case Msete:  tmp +="b"; asm.cmpq(o.o1.toString(), o.o2.toString()).sete (tmp).movzbq(tmp, o.o2.toString()); break;
		case Msetne: tmp +="b"; asm.cmpq(o.o1.toString(), o.o2.toString()).setne(tmp).movzbq(tmp, o.o2.toString()); break;
		case Msetl:  tmp +="b"; asm.cmpq(o.o1.toString(), o.o2.toString()).setl (tmp).movzbq(tmp, o.o2.toString()); break;
		case Msetle: tmp +="b"; asm.cmpq(o.o1.toString(), o.o2.toString()).setle(tmp).movzbq(tmp, o.o2.toString()); break;
		case Msetg:  tmp +="b"; asm.cmpq(o.o1.toString(), o.o2.toString()).setg (tmp).movzbq(tmp, o.o2.toString()); break;
		case Msetge: tmp +="b"; asm.cmpq(o.o1.toString(), o.o2.toString()).setge(tmp).movzbq(tmp, o.o2.toString()); break;
		default:
			String msg = "unknown binary operation type";
			throw new Error(msg);
		}
		lin(o.l);
	}

	@Override
	public void visit(Lpush o) {
		asm.pushq(o.o.toString());
		lin(o.l);
	}

	@Override
	public void visit(Lpop o) {
		asm.popq(o.r.toString());
		lin(o.l);
	}

	@Override
	public void visit(Lcall o) {
		asm.call(o.s);
		lin(o.l);
	}

	@Override
	public void visit(LTLfun o) {
		cfg = o.body;
	    asm.label(o.name);
	    lin(o.entry);
	}

	@Override
	public void visit(LTLfile o) {
		asm.globl("main");
		for (LTLfun f : o.funs) {
			f.accept(this);
		}
	}
	
	public void print(String filename) {
		asm.printToFile(filename);
	} 
}