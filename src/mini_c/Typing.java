package mini_c;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.HashMap;

public class Typing implements Pvisitor {
	
	private File file;
	private HashMap<String, Structure> structs;
	private LinkedList<HashMap<String, Typ>> scopes;
	private Stmt lastStmt;
	private Expr lastExpr;
	
	private boolean equivalent(Typ t1, Typ t2) {
		if (t1.getClass() == t2.getClass())
		{
			return true;
		}
		if ((t1 instanceof Ttypenull && !(t2 instanceof Tvoidstar)) ||
			(t2 instanceof Ttypenull && !(t1 instanceof Tvoidstar)))
		{
			return true;
		}
		if ((t1 instanceof Tstructp && t2 instanceof Tvoidstar) ||
			(t2 instanceof Tstructp && t1 instanceof Tvoidstar))
		{
			return true;
		}
		return false;
	}
	
	private String printLoc(Loc loc) {
		String newline = System.getProperty("line.separator");
		return "in " + loc + ":" + newline;
	}
	
	File getFile() {
		if (file == null) {
			String msg = "typing not yet done";
			throw new Error(msg);
		}
		return file;
	}
	
	@Override
	public void visit(Pfile n) {
		lastExpr = new Econst(0);
		structs = new HashMap<String, Structure>();
		scopes  = new LinkedList<HashMap<String, Typ>>();
		file    = new File(new LinkedList<Decl_fun>());
	
		LinkedList<Decl_var> args = new LinkedList<Decl_var>();
		args.add(new Decl_var(new Tint(), "c"));
		file.funs.add(new Decl_fun(new Tint(), "putchar", args,
				new Sblock(new LinkedList<Decl_var>(), new LinkedList<Stmt>())));
		args.peek().name = "n";
		file.funs.add(new Decl_fun(new Tvoidstar(), "sbrk", args,
				new Sblock(new LinkedList<Decl_var>(), new LinkedList<Stmt>())));
		
		for (Pdecl decl : n.l) {
			decl.accept(this);
		}
		Decl_fun main = new Decl_fun(new Tint(), "main", null, null);
		if (!file.funs.contains(main)) {
			String msg = "file does not contain a valid entry point";
			throw new Error(msg);
		}
	}

	@Override
	public void visit(PTint n) {
		lastExpr.typ = new Tint();
	}

	@Override
	public void visit(PTstruct n) {
		Structure s = structs.get(n.id);
		if (s != null) {
			lastExpr.typ = new Tstructp(s);
		} else {
			String msg = printLoc(n.loc)
				+ "struct "
				+ n.id
				+ " not declared";
			throw new Error(msg);
		}
	}

	@Override
	public void visit(Pint n) {
		lastExpr = new Econst(n.n);
		if (n.n == 0) {
			lastExpr.typ = new Ttypenull();
		} else {
			lastExpr.typ = new Tint();
		}
	}

	@Override
	public void visit(Pident n) {
		
		lastExpr = new Eaccess_local(n.id);
		lastExpr.typ = null;
		
		Iterator<HashMap<String, Typ>> itLocals = scopes.iterator();
		while (lastExpr.typ == null && itLocals.hasNext()) {
			lastExpr.typ = itLocals.next().get(n.id);
		}
		
		if (lastExpr.typ == null) {
			Iterator<Decl_var> itArgs = file.funs.getLast().fun_formals.iterator();
			while (lastExpr.typ == null && itArgs.hasNext()) {
				Decl_var d = itArgs.next();
				if (d.name == n.id) {
					lastExpr.typ = d.t;
				}
			}
		}
		
		if (lastExpr.typ == null) {
			String msg = printLoc(n.loc)
				+ n.id
				+ " is used without being declared";
			throw new Error(msg);
		}
	}

	@Override
	public void visit(Punop n) {
		n.e1.accept(this);
		Typ t = new Tint();
		if ((n.op == Unop.Unot) || equivalent(lastExpr.typ, t)) {
			lastExpr = new Eunop(n.op, lastExpr);
			lastExpr.typ = t;
		} else {
			String msg = printLoc(n.loc)
				+ "expression of type "
				+ lastExpr.typ.toString()
				+ " cannot be used with unary '-'";
			throw new Error(msg);
		}
	}

	@Override
	public void visit(Passign n) {
		n.e1.accept(this);
		Expr tmpExpr = lastExpr;
		n.e2.accept(this);
		if (!equivalent(tmpExpr.typ, lastExpr.typ)) {
			String msg = printLoc(n.loc)
				+ "invalid assignment of type "
				+ tmpExpr.typ.toString()
				+ " to expression of type " 
				+ lastExpr.typ.toString();
			throw new Error(msg);
		}
		if (tmpExpr instanceof Eaccess_local) {
			Eaccess_local e = (Eaccess_local)tmpExpr;
			lastExpr = new Eassign_local(e.i, lastExpr);
			lastExpr.typ = e.typ;	
		}
		if (tmpExpr instanceof Eaccess_field) {
			Eaccess_field e = (Eaccess_field)tmpExpr;
			lastExpr = new Eassign_field(e.e, e.f, lastExpr);
			lastExpr.typ = e.typ;
		}
	}

	@Override
	public void visit(Pbinop n) {
		n.e1.accept(this);
		Expr Expr1 = lastExpr;
		n.e2.accept(this);
		Expr Expr2 = lastExpr;
		lastExpr = new Ebinop(n.op, Expr1, Expr2);
		lastExpr.typ = new Tint();
		switch (n.op) {
		case Badd:
		case Bsub:
		case Bmul:
		case Bdiv:
			if (!equivalent(Expr1.typ, lastExpr.typ) || !equivalent(Expr2.typ, lastExpr.typ)) {
				String msg = printLoc(n.loc)
					+ "invalid arithmetic operations on non-int variables";
				throw new Error(msg);
			}
		case Beq:
		case Bneq:
		case Blt:
		case Ble:
		case Bgt:
		case Bge:
			if (!equivalent(Expr1.typ, Expr2.typ)) {
				String msg = printLoc(n.loc)
					+ "comparison on uncastable expressions";
				throw new Error(msg);
			}
		case Band:
		case Bor:
			break;
		default:
			String msg = printLoc(n.loc)
				+ "unsupported operand types";
			throw new Error(msg);
		}
	}

	@Override
	public void visit(Parrow n) {
		n.e.accept(this);
		if (!(lastExpr.typ instanceof Tstructp)) {
			String msg = printLoc(n.loc)
				+ "expression on the left side of arrow "
				+ "does not point to a valid structure";
			throw new Error(msg);
		}
		Structure s = ((Tstructp)lastExpr.typ).s;
		if (!s.fields.containsKey(n.f)) {
			String msg = printLoc(n.loc)
				+ "structure "
				+ s.str_name
				+ " has no field named "
				+ n.f;
			throw new Error(msg);
		}
		Field f = s.fields.get(n.f);
		lastExpr = new Eaccess_field(lastExpr, new Field(n.f, f.field_typ, f.pos));
		lastExpr.typ = f.field_typ;
	}

	@Override
	public void visit(Pcall n) {
		int func_id = file.funs.indexOf(new Decl_fun(null, n.f, null, null));
		if (func_id < 0) {
			String msg = printLoc(n.loc)
				+ "function "
				+ n.f
				+ " is used without declaration";
			throw new Error(msg);
		}
		Decl_fun prototype = file.funs.get(func_id);
		Iterator<Decl_var> it = prototype.fun_formals.iterator();
		LinkedList<Expr> args = new LinkedList<Expr>();
		
		int counter = 0;
		for (Pexpr e : n.l) {
			counter++;
			e.accept(this);
			if (!it.hasNext()) {
				int numArgs = counter-1;
				String msg = printLoc(n.loc)
						+ "too much parameters in call to "
						+ n.f
						+ ": expected "
						+ numArgs
						+ ", got "
						+ n.l.size();
				throw new Error(msg);
			}
			Typ t = it.next().t;
			if (!equivalent(lastExpr.typ, t)) {
				String msg = printLoc(n.loc)
					+ "expression #"
					+ counter
					+ " in call to "
					+ n.f
					+ " cannot be cast to type"
					+ t.toString();
				throw new Error(msg);
			}
			args.add(lastExpr);
		}
		if (it.hasNext()) {
			counter++;
			String msg = printLoc(n.loc)
					+ "missing parameter #"
					+ counter
					+ " in call to "
					+ n.f;
				throw new Error(msg);
		}
		lastExpr = new Ecall(prototype.fun_name, args);
		lastExpr.typ = prototype.fun_typ;
	}

	@Override
	public void visit(Psizeof n) {
		
		Structure s = structs.get(n.id);
		if (s == null) {
			String msg = printLoc(n.loc)
				+ "struct "
				+ n.id
				+ " not declared";
			throw new Error(msg);
		}
		lastExpr = new Esizeof(s);
		lastExpr.typ = new Tint();
	}

	@Override
	public void visit(Pskip n) {
		lastStmt = new Sskip();
	}

	@Override
	public void visit(Peval n) {
		n.e.accept(this);
		lastStmt = new Sexpr(lastExpr);
	}

	@Override
	public void visit(Pif n) {
		n.e.accept(this);
		Expr cond = lastExpr;
		n.s1.accept(this);
		Stmt tmpStmt = lastStmt;
		n.s2.accept(this);
		lastStmt = new Sif(cond, tmpStmt, lastStmt);
	}

	@Override
	public void visit(Pwhile n) {		
		n.s1.accept(this);
		n.e.accept(this);
		lastStmt = new Swhile(lastExpr, lastStmt);
	}

	@Override
	public void visit(Pbloc n) {
		
		Sblock block = new Sblock(new LinkedList<Decl_var>(), new LinkedList<Stmt>());
		HashMap<String, Typ> scope = new HashMap<String, Typ>();
		
		for (Pdeclvar v : n.vl) {
			v.typ.accept(this);
			if (scope.containsKey(v.id)) {
				String msg = printLoc(n.loc)
					+ "variable "
					+ v.id
					+ " already declared in this scope";
				throw new Error(msg);
			}
			scope.put(v.id, lastExpr.typ);
			block.dl.add(new Decl_var(lastExpr.typ, v.id));
		}
		
		scopes.push(scope);
		for (Pstmt s : n.sl) {
			s.accept(this);
			block.sl.add(lastStmt);
		}
		scopes.pop();
		lastStmt = block;
	}

	@Override
	public void visit(Preturn n) {
		n.e.accept(this);
		lastStmt = new Sreturn(lastExpr);
	}

	@Override
	public void visit(Pstruct n) {
		if (structs.containsKey(n.s)) {
			String msg = printLoc(n.loc)
				+ "struct "
				+ n.s
				+ " already declared";
			throw new Error(msg);
		}
		Structure decl = new Structure(n.s);
		structs.put(n.s, decl);
		int counter = 0;
		for (Pdeclvar f : n.fl) {
			f.typ.accept(this);
			if (decl.fields.containsKey(f.id)) {
				String msg = printLoc(f.loc) 
					+ "field "
					+ f.id
					+ " in struct "
					+ n.s
					+ " already declared";
				throw new Error(msg);
			}
			decl.fields.put(f.id, new Field(f.id, lastExpr.typ, counter++));
		}
		structs.replace(n.s, decl);
	}

	@Override
	public void visit(Pfun n) {
		
		n.ty.accept(this);
		Decl_fun decl = new Decl_fun(lastExpr.typ, n.s, null, null);
		if (file.funs.contains(decl)) {
			String msg = printLoc(n.loc)
				+ "function "
				+ n.s
				+ " already declared";
			throw new Error(msg);
		}
		
		decl.fun_formals = new LinkedList<Decl_var>();
		for (Pdeclvar v : n.pl) {
			v.typ.accept(this);
			Decl_var d = new Decl_var(lastExpr.typ, v.id);
			if (decl.fun_formals.contains(d)) {
				String msg = printLoc(n.loc)
					+ "formal argument with name "
					+ v.id
					+ " already exist in function "
					+ n.s;
				throw new Error(msg);
			}
			decl.fun_formals.add(d);
		}
		file.funs.addLast(decl);
		
		n.b.accept(this);
		file.funs.getLast().fun_body = lastStmt;
	}

}
