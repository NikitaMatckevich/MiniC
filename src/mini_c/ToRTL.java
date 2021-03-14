package mini_c;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;

class ToRTL implements Visitor {
	
	private RTLfile  file = new RTLfile();
	
	private LinkedList<HashMap<String, Register>> scopes = new LinkedList<HashMap<String, Register>>();
	private LinkedList<Label> condEntries = new LinkedList<Label>();
	private HashMap<String, Register> formals;
	
	private RTLfun   lastFun;
	private Label    lastEntry;
	private Register lastResult;
	static private Register unusedResult = Register.tmp2;
	
	private Register fetchVariableRegister(String id) {
		Register result = null;
		Iterator<HashMap<String, Register>> itLocals = scopes.iterator();
		while (result == null && itLocals.hasNext()) {
			result = itLocals.next().get(id);
		}
		if (result == null) {
			result = formals.get(id);
		}
		if (result == null) {
			String msg = "register not found for " + id;
			throw new Error(msg);
		}
		return result;
	}
	
	private boolean isLogical(Expr e) {
		if (e instanceof Econst) {
			Econst ec = (Econst)e;
			if (ec.i == 0 || ec.i == 1) {
				return true;
			}
		} else if (e instanceof Eunop && ((Eunop)e).u == Unop.Unot) {
			return true;
		} else if (e instanceof Ebinop) {
			switch (((Ebinop)e).b) {
			case Beq:
			case Bneq:
			case Blt:
			case Ble:
			case Bgt:
			case Bge:
				return true;
			default:
			}
		}
		return false;
	}
	
	private void logicalAndOrEval(Ebinop n) {
		
		boolean isLargestAndOr = false;
		if (condEntries.isEmpty()) {
			condEntries.push(lastEntry);
			condEntries.push(lastEntry);
			isLargestAndOr = true;
		}
		
		if (!isLogical(n.e2)) {
			lastEntry = lastFun.body.add(new Rmunop(new Msetnei(0), lastResult, lastEntry));
		}
		Register tmp = lastResult;
		n.e2.accept(this);
		lastResult = tmp;
		
		if (n.b == Binop.Band) {
			lastEntry = lastFun.body.add(new Rmubranch(new Mjz() , lastResult, condEntries.get(1), lastEntry));
		} else {
			lastEntry = lastFun.body.add(new Rmubranch(new Mjnz(), lastResult, condEntries.getFirst(), lastEntry));
		}
		
		if (!isLogical(n.e1)) {
			lastEntry = lastFun.body.add(new Rmunop(new Msetnei(0), lastResult, lastEntry));
		}
		n.e1.accept(this);
		
		if (isLargestAndOr) {
			condEntries.pop();
			condEntries.pop();
		}
	}
	
	private boolean logicalEqNeqEval(Ebinop n) {
		if (n.e1 instanceof Econst) {
			if (n.b == Binop.Beq) {
				lastEntry = lastFun.body.add(new Rmunop(new Msetei(((Econst)n.e1).i), lastResult, lastEntry));
			} else {
				lastEntry = lastFun.body.add(new Rmunop(new Msetnei(((Econst)n.e1).i), lastResult, lastEntry));
			}
			n.e2.accept(this);
		} else if (n.e2 instanceof Econst) {
			if (n.b == Binop.Beq) {
				lastEntry = lastFun.body.add(new Rmunop(new Msetei(((Econst)n.e2).i), lastResult, lastEntry));
			} else {
				lastEntry = lastFun.body.add(new Rmunop(new Msetnei(((Econst)n.e2).i), lastResult, lastEntry));
			}
			n.e1.accept(this);
		}	
		return false;
	}
	
	private void standardIfEval(Expr e) {
		lastEntry = lastFun.body.add(new Rmubranch(new Mjnz(), lastResult, condEntries.pop(), condEntries.pop()));
		e.accept(this);
	}
	
	private void swapLastCondcondEntries() {
		Label tEntry = condEntries.pop();
		Label fEntry = condEntries.pop();
		condEntries.push(tEntry);
		condEntries.push(fEntry);
	}
	
	public RTLfile getFile() {
		if (file == null) {
			String msg = "RTL interpretation of this file not yet done";
			throw new Error(msg);
		}
		return file;
	}

	@Override
	public void visit(Econst n) {
		lastEntry = lastFun.body.add(new Rconst(n.i, lastResult, lastEntry));
	}

	@Override
	public void visit(Eaccess_local n) {
		Register storingReg = fetchVariableRegister(n.i);
		if (lastResult != storingReg && lastResult != unusedResult) {
			lastEntry = lastFun.body.add(new Rmbinop(Mbinop.Mmov, storingReg, lastResult, lastEntry));
		}
	}

	@Override
	public void visit(Eassign_local n) {
		Register storingReg = fetchVariableRegister(n.i);
		if (lastResult != unusedResult) {
			lastEntry = lastFun.body.add(new Rmbinop(Mbinop.Mmov, storingReg, lastResult, lastEntry));
		}
		lastResult = storingReg;
		n.e.accept(this);
	}
	
	@Override
	public void visit(Eaccess_field n) {
		Structure s = ((Tstructp)n.e.typ).s;
		int fieldOffset = 8*s.fields.get(n.f.field_name).pos;
		Register output = lastResult;
		lastResult = new Register();
		lastEntry = lastFun.body.add(new Rload(lastResult, fieldOffset, output, lastEntry));
		n.e.accept(this);
	}

	@Override
	public void visit(Eassign_field n) {
		Structure s = ((Tstructp)n.e1.typ).s;
		int fieldOffset = 8*s.fields.get(n.f.field_name).pos;
		
		Register from = new Register();
		Register to = new Register();
		
		if (lastResult != unusedResult) {
			lastEntry = lastFun.body.add(new Rmbinop(Mbinop.Mmov, from, lastResult, lastEntry));
		}
		lastEntry = lastFun.body.add(new Rstore (from, to, fieldOffset, lastEntry));
	
		lastResult = from;
		n.e2.accept(this);
		
		lastResult = to;
		n.e1.accept(this);
	}

	@Override
	public void visit(Eunop n) {
		switch (n.u) {
		case Uneg:
			Register zero = new Register();
			if (lastResult != unusedResult) {
				lastEntry = lastFun.body.add(new Rmbinop(Mbinop.Mmov, zero, lastResult, lastEntry));
			}
			lastEntry = lastFun.body.add(new Rmbinop(Mbinop.Msub, lastResult, zero, lastEntry));
			lastEntry = lastFun.body.add(new Rconst(0, zero, lastEntry));
			break;
		case Unot:
			lastEntry = lastFun.body.add(new Rmunop(new Msetei(0), lastResult, lastEntry));
			break;
		default:
			String msg = "no RTL interpretation provided for unary operation " + n.u.toString();
			throw new Error(msg);
		}
		n.e.accept(this);
	}

	@Override
	public void visit(Ebinop n) {
		
		if (n.b == Binop.Bor || n.b == Binop.Band) {
			logicalAndOrEval(n);
			return;
		}
		if (n.b == Binop.Beq || n.b == Binop.Bneq) {
			if (logicalEqNeqEval(n)) {
				return;
			}
		}
		
		Mbinop binop;
		switch (n.b) {
		case Badd: binop = Mbinop.Madd;   break;
		case Bsub: binop = Mbinop.Msub;   break;
		case Bmul: binop = Mbinop.Mmul;   break;
		case Bdiv: binop = Mbinop.Mdiv;   break;
		case Beq : binop = Mbinop.Msete;  break;
		case Bneq: binop = Mbinop.Msetne; break;
		case Blt : binop = Mbinop.Msetl;  break;
		case Ble : binop = Mbinop.Msetle; break;
		case Bgt : binop = Mbinop.Msetg;  break;
		case Bge : binop = Mbinop.Msetge; break;
		default:
			String msg = "no RTL interpretation provided for binary operation " + n.b.toString();
			throw new Error(msg);
		}
		
		Register firstResult = lastResult;
		Register secondResult = new Register();
		lastEntry = lastFun.body.add(new Rmbinop(binop, secondResult, firstResult, lastEntry));
	
		lastResult = secondResult;
		n.e2.accept(this);
		
		lastResult = firstResult;
		n.e1.accept(this);
	}

	@Override
	public void visit(Ecall n) {
		Label toExit = lastEntry;
		Label toCall = lastEntry = lastFun.body.add(null);
		
		Register callResult = lastResult;
		
		LinkedList<Register> args = new LinkedList<Register>();
		Iterator<Expr> it = n.el.descendingIterator();
		while (it.hasNext()) {
			lastResult = new Register();
			args.addFirst(lastResult);
			it.next().accept(this);
		}	
		lastFun.body.graph.replace(toCall, new Rcall(callResult, n.i, args, toExit));
	}

	@Override
	public void visit(Esizeof n) {
		lastEntry = lastFun.body.add(new Rconst(8*n.s.fields.size(), lastResult, lastEntry));
	}

	@Override
	public void visit(Sskip n) {}

	@Override
	public void visit(Sexpr n) {
		lastResult = unusedResult;
		n.e.accept(this);
	}

	@Override
	public void visit(Sif n) {
		Label exitFromIf = lastEntry;
		
		n.s2.accept(this);
		condEntries.push(lastEntry);
		
		lastEntry = exitFromIf;
		n.s1.accept(this);
		condEntries.push(lastEntry);
		
		lastResult = new Register();
		if (n.e instanceof Ebinop) {
			Ebinop e = (Ebinop)n.e;
			Mbbranch branch;
			switch (e.b) {
			case Bge: swapLastCondcondEntries();
			case Blt: branch = Mbbranch.Mjl ; break;
			case Bgt: swapLastCondcondEntries();
			case Ble: branch = Mbbranch.Mjle; break;
			default: 
				standardIfEval(n.e);
				return;
			}
			
			Register fResult = new Register();
			Register sResult = new Register();
			lastEntry = lastFun.body.add(new Rmbbranch(branch, fResult, sResult, condEntries.pop(), condEntries.pop()));
			
			lastResult = fResult;
			e.e2.accept(this);
			
			lastResult = sResult;
			e.e1.accept(this);
			
		} else {
			standardIfEval(n.e);
			return;
		}
	}

	@Override
	public void visit(Swhile n) {
		Label endOfWhile = lastEntry;
		Label toGoto = lastEntry = lastFun.body.add(null);
		
		n.s.accept(this);
		Label toWhileBlock = lastEntry;
		
		lastResult = new Register();
		lastEntry = lastFun.body.add(new Rmubranch(new Mjnz(), lastResult, toWhileBlock, endOfWhile));
		n.e.accept(this);
		lastFun.body.graph.replace(toGoto, new Rgoto(lastEntry));
	}

	@Override
	public void visit(Sblock n) {
		HashMap<String, Register> scope = new HashMap<String, Register>();
		for (Decl_var v : n.dl) {
			Register reg = new Register();
			scope.put(v.name, reg);
			lastFun.locals.add(reg);
		}
		
		scopes.push(scope);
		Iterator<Stmt> it = n.sl.descendingIterator();
		while (it.hasNext()) {
			it.next().accept(this);
		}
		scopes.pop();
	}

	@Override
	public void visit(Sreturn n) {
		lastEntry = lastFun.exit;
		lastResult = lastFun.result;
		n.e.accept(this);
	}

	@Override
	public void visit(Decl_fun n) {
		lastFun = new RTLfun(n.fun_name);
		lastFun.body = new RTLgraph();
		lastFun.exit = new Label();
		lastFun.result = new Register();
		
		formals = new HashMap<String, Register>();
		for (Decl_var v : n.fun_formals) {
			Register reg = new Register();
			formals.put(v.name, reg);
			lastFun.formals.add(reg);
		}
		
		n.fun_body.accept(this);
		lastFun.entry = lastEntry;
	}

	@Override
	public void visit(File n) {
		for (Decl_fun fun : n.funs) {
			if (fun.fun_name != "sbrk" && fun.fun_name != "putchar") {
				fun.accept(this);
				file.funs.add(lastFun);
			}
		}
	}
	
	@Override
	public void visit(Unop n)      { assert false; }
	@Override
	public void visit(Binop n)     { assert false; }
	@Override
	public void visit(String n)    { assert false; }
	@Override
	public void visit(Tint n)      { assert false; }
	@Override
	public void visit(Tstructp n)  { assert false; }
	@Override
	public void visit(Tvoidstar n) { assert false; }
	@Override
	public void visit(Ttypenull n) { assert false; }
	@Override
	public void visit(Structure n) { assert false; }
	@Override
	public void visit(Field n)     { assert false; }
	@Override
	public void visit(Decl_var n)  { assert false; }
	@Override
	public void visit(Expr n)      { assert false; }
	
}