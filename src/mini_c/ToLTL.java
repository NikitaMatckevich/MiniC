package mini_c;

class ToLTL implements ERTLVisitor {

	private LTLfile  file = new LTLfile();
	private LTLfun   lastFun;
	private Label    lastEntry;
	private Coloring lastColor;
	
	public LTLfile getFile() {
		if (file == null) {
			String msg = "LTL interpretation of this file not yet done";
			throw new Error(msg);
		}
		return file;
	}
	
	@Override
	public void visit(ERconst o) {
		lastFun.body.put(lastEntry, new Lconst(o.i, lastColor.colors.get(o.r), o.l));
	}

	@Override
	public void visit(ERload o) {
		Operand c1 = lastColor.colors.get(o.r1);
		Operand c2 = lastColor.colors.get(o.r2);
		
		Label addedEntry = o.l;
		Register toLoad;
		
		if (c2 instanceof Reg) {
			toLoad = ((Reg)c2).r;
		} else {
			toLoad = Register.tmp2;
			addedEntry = lastFun.body.add(new Lmbinop(Mbinop.Mmov, new Reg(toLoad), c2, addedEntry));
		}
		if (c1 instanceof Reg) {
			addedEntry = lastFun.body.add(new Lload(((Reg)c1).r, o.i, toLoad, addedEntry));
		} else {
			addedEntry = lastFun.body.add(new Lload(Register.tmp1, o.i, toLoad, addedEntry));
			addedEntry = lastFun.body.add(new Lmbinop(Mbinop.Mmov, c1, new Reg(Register.tmp1), addedEntry));
		}
		lastFun.body.put(lastEntry, lastFun.body.graph.remove(addedEntry));
	}

	@Override
	public void visit(ERstore o) {
		Operand c1 = lastColor.colors.get(o.r1);
		Operand c2 = lastColor.colors.get(o.r2);
		
		Label addedEntry = o.l;
		Register toLoad, toStore;
		
		if (c1 instanceof Reg) {
			toLoad = ((Reg)c1).r;
			if (c2 instanceof Reg) {
				toStore = ((Reg)c2).r;
				lastFun.body.put(lastEntry, new Lstore(toLoad, toStore, o.i, addedEntry));
			} else {
				toStore = Register.tmp2;
				addedEntry = lastFun.body.add(new Lstore(toLoad, toStore, o.i, addedEntry));
				lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, c2, new Reg(toStore), addedEntry));
			}
		} else {
			toLoad = Register.tmp1;
			if (c2 instanceof Reg) {
				toStore = ((Reg)c2).r;
				addedEntry = lastFun.body.add(new Lstore(toLoad, toStore, o.i, addedEntry));
				lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, c1, new Reg(toLoad), addedEntry));
			} else {
				toStore = Register.tmp2;
				addedEntry = lastFun.body.add(new Lstore(toLoad, toStore, o.i, addedEntry));
				addedEntry = lastFun.body.add(new Lmbinop(Mbinop.Mmov, c2, new Reg(toStore), addedEntry));
				lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, c1, new Reg(toLoad), addedEntry));
			}
		}
	}

	@Override
	public void visit(ERmunop o) {
		Operand c = lastColor.colors.getOrDefault(o.r, new Reg(Register.rsp));
		lastFun.body.put(lastEntry, new Lmunop(o.m, c, o.l));
	}

	@Override
	public void visit(ERmbinop o) {
		Operand c1 = lastColor.colors.get(o.r1);
		Operand c2 = lastColor.colors.get(o.r2);
		
		if ((o.m == Mbinop.Mmov) && (o.r2.equals(Register.tmp2) || c2.equals(c1))) {
			lastFun.body.put(lastEntry, new Lgoto(o.l));
			return;
		}
		
		if ((c1 instanceof Spilled || o.m == Mbinop.Mmul) && c2 instanceof Spilled) {
			Label addedEntry = o.l;
			Reg tmp = new Reg(Register.tmp1);
			if (o.m == Mbinop.Mmul) {
				addedEntry = lastFun.body.add(new Lmbinop(Mbinop.Mmov, tmp, c2, addedEntry));
				addedEntry = lastFun.body.add(new Lmbinop(o.m, c1, tmp, addedEntry));
				lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, c2, tmp, addedEntry));
			} else {
				addedEntry = lastFun.body.add(new Lmbinop(o.m, tmp, c2, addedEntry));
				lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, c1, tmp, addedEntry));
			}
		} else {
			lastFun.body.put(lastEntry, new Lmbinop(o.m, c1, c2, o.l));
		}
	}

	@Override
	public void visit(ERmubranch o) {
		lastFun.body.put(lastEntry, new Lmubranch(o.m, lastColor.colors.get(o.r), o.l1, o.l2));
	}

	@Override
	public void visit(ERmbbranch o) {
		Operand c1 = lastColor.colors.get(o.r1);
		Operand c2 = lastColor.colors.get(o.r2);	
		if (c1 instanceof Spilled && c2 instanceof Spilled) {
			Reg tmp = new Reg(Register.tmp1);
			Label addedEntry = lastFun.body.add(new Lmbbranch(o.m, tmp, c2, o.l1, o.l2));
			lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, c1, tmp, addedEntry));
		} else {
			lastFun.body.put(lastEntry, new Lmbbranch(o.m, c1, c2, o.l1, o.l2));
		}
	}

	@Override
	public void visit(ERgoto o) {
		lastFun.body.put(lastEntry, new Lgoto(o.l));
	}

	@Override
	public void visit(ERcall o) {
		lastFun.body.put(lastEntry, new Lcall(o.s, o.l));
	}

	@Override
	public void visit(ERalloc_frame o) {
		if (lastColor.numLocals == 0) {
			lastFun.body.put(lastEntry, new Lgoto(o.l));
		} else {
			Reg rbp = new Reg(Register.rbp);
			Reg rsp = new Reg(Register.rsp);
			Label addedEntry = lastFun.body.add(new Lmunop(new Maddi(-8*lastColor.numLocals), rsp, o.l));
			addedEntry = lastFun.body.add(new Lmbinop(Mbinop.Mmov, rsp, rbp, addedEntry));
			lastFun.body.put(lastEntry, new Lpush(rbp, addedEntry));
		}
	}

	@Override
	public void visit(ERdelete_frame o) {
		if (lastColor.numLocals == 0) {
			lastFun.body.put(lastEntry, new Lgoto(o.l));
		} else {
			Reg rbp = new Reg(Register.rbp);
			Reg rsp = new Reg(Register.rsp);
			Label addedEntry = lastFun.body.add(new Lpop(Register.rbp, o.l));
			lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, rbp, rsp, addedEntry));
		}
	}

	@Override
	public void visit(ERget_param o) {
		Operand c = lastColor.colors.get(o.r);
		Operand paramToGet = new Spilled(o.i);
		if (c instanceof Reg) {
			lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, paramToGet, lastColor.colors.get(o.r), o.l));
		} else {
			Reg tmp = new Reg(Register.tmp2);
			Label addedEntry = lastFun.body.add(new Lmbinop(Mbinop.Mmov, tmp, lastColor.colors.get(o.r), o.l));
			lastFun.body.put(lastEntry, new Lmbinop(Mbinop.Mmov, paramToGet, tmp, addedEntry));
		}
	}

	@Override
	public void visit(ERpush_param o) {
		lastFun.body.put(lastEntry, new Lpush(lastColor.colors.get(o.r), o.l));
	}

	@Override
	public void visit(ERreturn o) {
		lastFun.body.put(lastEntry, new Lreturn());
	}

	@Override
	public void visit(ERTLfun o) {
		lastFun = new LTLfun(o.name);
		lastFun.entry = o.entry;
		lastFun.body = new LTLgraph();
		lastColor = new Coloring(new Interference(new Liveness(o.body)));
		o.body.graph.forEach((label, instruction) -> { lastEntry = label; instruction.accept(this); });
	}

	@Override
	public void visit(ERTLfile o) {
		for (ERTLfun f : o.funs) {
			f.accept(this);
			file.funs.add(lastFun);
		}
	}	
}