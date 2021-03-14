package mini_c;

import java.util.Iterator;
import java.util.LinkedList;

class ToERTL implements RTLVisitor {

	private ERTLfile file = new ERTLfile();
	private ERTLfun  lastFun;
	private Label    lastEntry;
	
	public ERTLfile getFile() {
		if (file == null) {
			String msg = "ERTL interpretation of this file not yet done";
			throw new Error(msg);
		}
		return file;
	}
	
	@Override
	public void visit(Rconst o) { lastFun.body.put(lastEntry, new ERconst(o.i, o.r, o.l)); }
	@Override
	public void visit(Rload o) { lastFun.body.put(lastEntry, new ERload(o.r1, o.i, o.r2, o.l)); }
	@Override
	public void visit(Rstore o) { lastFun.body.put(lastEntry, new ERstore(o.r1, o.r2, o.i, o.l)); }
	@Override
	public void visit(Rmubranch o) { lastFun.body.put(lastEntry, new ERmubranch(o.m, o.r, o.l1, o.l2)); }
	@Override
	public void visit(Rmbbranch o) { lastFun.body.put(lastEntry, new ERmbbranch(o.m, o.r1, o.r2, o.l1, o.l2)); }
	@Override
	public void visit(Rgoto o) { lastFun.body.put(lastEntry, new ERgoto(o.l)); }
	@Override
	public void visit(Rmunop o) { lastFun.body.put(lastEntry, new ERmunop(o.m, o.r, o.l)); }
	@Override
	public void visit(Rmbinop o) {
		if (o.m == Mbinop.Mdiv) {
			Label addedEntry = o.l;
			addedEntry = lastFun.body.add(new ERmbinop(Mbinop.Mmov, Register.rax, o.r2, addedEntry));
			addedEntry = lastFun.body.add(new ERmbinop(Mbinop.Mdiv, o.r1, Register.rax, addedEntry));
			ERmbinop addedInst = new ERmbinop(Mbinop.Mmov, o.r2, Register.rax, addedEntry);
			lastFun.body.put(lastEntry, addedInst);
		} else {
			lastFun.body.put(lastEntry, new ERmbinop(o.m, o.r1, o.r2, o.l));
		}
	}

	@Override
	public void visit(Rcall o) {
		Label addedEntry = o.l;
		
		int toUseInCall = o.rl.size();
		int toUnstack = toUseInCall - 6;
		if (toUnstack > 0) {
			addedEntry = lastFun.body.add(new ERmunop(new Maddi(8*toUnstack), Register.rsp, addedEntry));
			toUseInCall = 6;
		}
		
		if (!o.r.equals(Register.tmp2)) {
			addedEntry = lastFun.body.add(new ERmbinop(Mbinop.Mmov, Register.rax, o.r, addedEntry));
		}
		
		addedEntry = lastFun.body.add(new ERcall(o.s, toUseInCall, addedEntry));
		
		Iterator<Register> itParams = Register.parameters.iterator();
		for (Register r : o.rl) {
			if (itParams.hasNext()) {
				addedEntry = lastFun.body.add(new ERmbinop(Mbinop.Mmov, r, itParams.next(), addedEntry));
			} else {
				addedEntry = lastFun.body.add(new ERpush_param(r, addedEntry));
			}
		}
		lastFun.body.put(lastEntry, lastFun.body.graph.remove(addedEntry));
	}

	@Override
	public void visit(RTLfun o) {
		
		lastFun = new ERTLfun(o.name, o.formals.size() < 6 ? o.formals.size() : 6);
		lastFun.body = new ERTLgraph();
		
		lastEntry = o.entry;
		
		Iterator<Register> itParams = Register.parameters.iterator();
		int i = 2;
		for (Register r : o.formals) {
			if (itParams.hasNext()) {
				lastEntry = lastFun.body.add(new ERmbinop(Mbinop.Mmov, itParams.next(), r, lastEntry));
			} else {
				lastEntry = lastFun.body.add(new ERget_param(8*(i++), r, lastEntry));
			}
		}
		
		for (Register r : o.locals) {
			lastFun.locals.add(r);
		}
		
		LinkedList<Register> calleeSavedRegs = new LinkedList<Register>();
		for (Register r : Register.callee_saved) {
			Register nextLocal = new Register();
			lastEntry = lastFun.body.add(new ERmbinop(Mbinop.Mmov, r, nextLocal, lastEntry));
			lastFun.locals.add(nextLocal);
			calleeSavedRegs.addLast(nextLocal);
		}
		
		lastEntry = lastFun.body.add(new ERalloc_frame(lastEntry));
		lastFun.entry = lastEntry;
		
		o.body.graph.forEach((label, instruction) -> { lastEntry = label; instruction.accept(this); });	
				
		lastEntry = lastFun.body.add(new ERreturn());
		lastEntry = lastFun.body.add(new ERdelete_frame(lastEntry));
		for (Register r : Register.callee_saved) {
			lastEntry = lastFun.body.add(new ERmbinop(Mbinop.Mmov, calleeSavedRegs.pop(), r, lastEntry));
		}
		
		ERmbinop putResultToRax = new ERmbinop(Mbinop.Mmov, o.result, Register.rax, lastEntry);
		lastFun.body.put(o.exit, putResultToRax);
	}

	@Override
	public void visit(RTLfile o) {
		for (RTLfun f : o.funs) {
			f.accept(this);
			file.funs.add(lastFun);
		}
	}
}