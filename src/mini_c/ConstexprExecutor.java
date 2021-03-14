package mini_c;

class ConstexprExecutor implements Visitor {

	private int lastValue;
	private boolean lastState;
	
	@Override
	public void visit(Field n) {
		lastState = false;
	}

	@Override
	public void visit(Econst n) {
		lastValue = n.i;
		lastState = true;
	}

	@Override
	public void visit(Eaccess_local n) {
		lastState = false;
	}

	@Override
	public void visit(Eaccess_field n) {
		lastState = false;
	}

	@Override
	public void visit(Eassign_local n) {
		n.e.accept(this);
		if (lastState) {
			n.e = new Econst(lastValue);
			lastState = false;
		}
	}

	@Override
	public void visit(Eassign_field n) {
		n.e2.accept(this);
		if (lastState) {
			n.e2 = new Econst(lastValue);
			lastState = false;
		}
	}

	@Override
	public void visit(Eunop n) {
		n.e.accept(this);
		if (lastState) {
			n.e = new Econst(lastValue);
			switch (n.u) {
			case Uneg:
				lastValue = -lastValue;
				break;
			case Unot:
				lastValue = (lastValue == 0) ? 1 : 0;
				break;
			default:
				String msg = "no evaluation provided for unary operation " + n.u.toString();
				throw new Error(msg);
			}
		}
	}

	@Override
	public void visit(Ebinop n) {
		n.e1.accept(this);
		if (lastState) {
			n.e1 = new Econst(lastValue);
		}
		int firstValue = lastValue;
		boolean firstState = lastState;
		
		n.e2.accept(this);
		if (lastState) {
			n.e2 = new Econst(lastValue);
		}
		
		if (firstState && lastState) {
			switch (n.b) {
			case Badd:
				lastValue = firstValue + lastValue;
				break;
			case Bsub:
				lastValue = firstValue - lastValue;
				break;
			case Bmul:
				lastValue = firstValue * lastValue;	
				break;
			case Bdiv:
				if (lastValue != 0)
					lastValue = firstValue / lastValue;
				else 
					lastState = false;
				break;
			case Beq:
				lastValue = firstValue == lastValue ? 1 : 0;
				break;
			case Bneq:
				lastValue = firstValue == lastValue ? 0 : 1;
				break;
			case Blt:
				lastValue = firstValue < lastValue ? 1 : 0;	
				break;
			case Ble:
				lastValue = firstValue <= lastValue ? 1 : 0;	
				break;
			case Bgt:
				lastValue = firstValue > lastValue ? 1 : 0;	
				break;
			case Bge:
				lastValue = firstValue >= lastValue ? 1 : 0;	
				break;
			default:
				lastState = false;
			}
		} else {
			lastState = false;
		}
	}

	@Override
	public void visit(Ecall n) {
		int size = n.el.size();
		for (int i = 0; i < size; i++) {
			Expr e = n.el.get(i);
			e.accept(this);
			if (lastState) {
				n.el.set(i, new Econst(lastValue));
			}
		}
		
		lastState = false;
	}

	@Override
	public void visit(Esizeof n) {
		lastValue = 8*n.s.fields.size();
		lastState = true;
	}

	@Override
	public void visit(Sskip n) {
	}

	@Override
	public void visit(Sexpr n) {
		n.e.accept(this);
		if (lastState) {
			n.e = new Econst(lastValue);
		}
	}

	@Override
	public void visit(Sif n) {
		n.e.accept(this);
		if (lastState) {
			n.e = new Econst(lastValue);
			lastState = false;
		}
		n.s1.accept(this);
		n.s2.accept(this);
	}

	@Override
	public void visit(Swhile n) {
		n.e.accept(this);
		if (lastState) {
			n.e = new Econst(lastValue);
			lastState = false;
		}
		n.s.accept(this);
	}

	@Override
	public void visit(Sblock n) {
		for (Stmt s : n.sl) {
			s.accept(this);
		}
	}

	@Override
	public void visit(Sreturn n) {
		n.e.accept(this);
		if (lastState) {
			n.e = new Econst(lastValue);
			lastState = false;
		}
	}

	@Override
	public void visit(Decl_fun n) {
		lastState = false;
		n.fun_body.accept(this);
	}

	@Override
	public void visit(File n) {
		for (Decl_fun fun : n.funs) {
			fun.accept(this);
		}
	}
	
	@Override
	public void visit(Unop n) {}
	@Override
	public void visit(Binop n) {}
	@Override
	public void visit(String n) {}
	@Override
	public void visit(Tint n) {}
	@Override
	public void visit(Tstructp n) {}
	@Override
	public void visit(Tvoidstar n) {}
	@Override
	public void visit(Ttypenull n) {}
	@Override
	public void visit(Structure n) {}
	@Override
	public void visit(Decl_var n) {}
	@Override
	public void visit(Expr n) {}
}