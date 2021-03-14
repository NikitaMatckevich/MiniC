package mini_c;

public class Main {

  static boolean parse_only = false;
  static boolean type_only = false;
  static boolean interp_rtl = false;
  static boolean interp_ertl = false;
  static boolean interp_ltl = false;
  static boolean debug = false;
  static String file = null;

  static void usage() {
    System.err.println("mini-c [--parse-only] [--type-only] file.c");
    System.exit(1);
  }

  public static void main(String[] args) throws Exception {
    for (String arg: args)
      if (arg.equals("--parse-only"))
        parse_only= true;
      else if (arg.equals("--type-only"))
        type_only = true;
      else if (arg.equals("--interp-rtl"))
        interp_rtl = true;
      else if (arg.equals("--interp-ertl"))
        interp_ertl = true;
      else if (arg.equals("--interp-ltl"))
          interp_ltl = true;
      else if (arg.equals("--debug"))
        debug = true;
      else {
        if (file != null) usage();
        if (!arg.endsWith(".c")) usage();
        file = arg;
      }
    if (file == null) usage ();
    
    java.io.Reader reader = new java.io.FileReader(file);
    
    Lexer lexer = new Lexer(reader);
    
    Parser parser = new Parser(lexer);
    Pfile f = (Pfile) parser.parse().value;
    if (parse_only) System.exit(0);
    
    Typing typer = new Typing();
    typer.visit(f);
    File tf = typer.getFile();
    if (type_only) System.exit(0);
    
    ConstexprExecutor cstex = new ConstexprExecutor();
    cstex.visit(tf);
    
    ToRTL rtl = new ToRTL();
    rtl.visit(tf);
    RTLfile rtlf = rtl.getFile();
    if (debug) rtlf.print();
    if (interp_rtl) { new RTLinterp(rtlf); System.exit(0); }
    
    ToERTL ertl = new ToERTL();
    ertl.visit(rtlf);
    ERTLfile ertlf = ertl.getFile();
    if (debug) ertlf.print();
    if (interp_ertl) { new ERTLinterp(ertlf);  System.exit(0); }
    
    ToLTL ltl = new ToLTL();
    ltl.visit(ertlf);
    LTLfile ltlf = ltl.getFile();
    if (debug) ltlf.print();
    if (interp_ltl) { new LTLinterp(ltlf);  System.exit(0); }
    
    Lin lin = new Lin();
    lin.visit(ltlf);
    lin.print(file.substring(0, file.lastIndexOf('.')) + ".s");
  }

}
