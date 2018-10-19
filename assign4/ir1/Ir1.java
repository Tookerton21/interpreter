//-------------------------------------------------------------------------
// Supporting software for CS421/422 Programming Language Implementation.
// Copyright(c) Portland State University (J. Li, 2017).
//-------------------------------------------------------------------------

// IR1 Representation
//
// (Updated 5/18/18: removed "_" from func names)
//
package ir1;
import java.io.*;
import java.util.*;

public class Ir1 {
  public static final BoolLit TRUE = new BoolLit(true);
  public static final BoolLit FALSE = new BoolLit(false);

  // Program -> {Func}
  //
  public static class Program {
    final Func[] funcs;

    public Program(Func[] f) { funcs=f; }
    public Program(List<Func> fl) { this(fl.toArray(new Func[0])); }
    public String toString() { 
      String str = "# IR1 Program\n";
      for (Func f: funcs)
	str += "\n" + f;
      return str;
    }
  }

  // Func -> <global> VarList [VarList] {Inst}
  //
  public static class Func {
    final String name;
    final String[] params;
    final String[] locals;
    final Inst[] code;

    public Func(String n, String[] p, String[] l, Inst[] c) {
      name=n; params=p; locals=l; code=c; 
    }
    public Func(String n, List<String> pl, List<String> ll, List<Inst> cl) {
      this(n, pl.toArray(new String[0]), ll.toArray(new String[0]),
	   cl.toArray(new Inst[0])); 
    }
    public String toString() { 
      String header = name + " " + StringArrayToString(params) + "\n" +
  	                (locals.length==0? "" : StringArrayToString(locals) + "\n");
      String body = "";
      for (Inst s: code)
	body += s.toString();
      return header + "{\n" + body + "}\n";
    }
    public String header() { 
      return name + " " + StringArrayToString(params) + " " +
	  (locals.length==0? "" : StringArrayToString(locals)) + "\n";
    }
  }

  // VarList -> "(" [<Id> {"," <Id>}] ")"
  //
  static String StringArrayToString(String[] vars) {
    String s = "(";
    if (vars.length > 0) {
      s += vars[0];
      for (int i=1; i<vars.length; i++)
	s += ", " + vars[i];
    }
    return s + ")";
  }

  // Instructions

  public static abstract class Inst {}

  // Inst -> Dest "=" Src BOP Src
  //
  public static class Binop extends Inst {
    final BOP op;
    final Dest dst;
    final Src src1, src2;

    public Binop(BOP o, Dest d, Src s1, Src s2) { 
      op=o; dst=d; src1=s1; src2=s2; 
    }
    public String toString() { 
      return " " + dst + " = " + src1 + " " + op + " " + src2 + "\n";
    }
  }

  // Inst -> Dest "=" UOP Src
  //
  public static class Unop extends Inst {
    final UOP op;
    final Dest dst;
    final Src src;

    public Unop(UOP o, Dest d, Src s) { op=o; dst=d; src=s; }
    public String toString() { 
      return " " + dst + " = " + op + src + "\n";
    }
  }

  // Inst -> Dest "=" Src
  //
  public static class Move extends Inst {
    final Dest dst;
    final Src src;

    public Move(Dest d, Src s) { dst=d; src=s; }
    public String toString() { 
      return " " + dst + " = " + src + "\n"; 
    }
  }

  // Inst -> Dest "=" Addr
  //
  public static class Load extends Inst {
    final Dest dst;
    final Addr addr;

    public Load(Dest d, Addr a) { dst=d; addr=a; }
    public String toString() { 
      return " " + dst + " = " + addr + "\n"; 
    }
  }
    
  // Inst -> Addr "=" Src
  //
  public static class Store extends Inst {
    final Addr addr;
    final Src src;

    public Store(Addr a, Src s) { addr=a; src=s; }
    public String toString() { 
      return " " + addr + " = " + src + "\n"; 
    }
  }

  // Inst -> [Dest "="] "call" <Global> "(" [Src {"," Src}] ")"
  //
  public static class Call extends Inst {
    final String name;
    final Dest rdst;    // could be null
    final Src[] args;

    public Call(String n, Src[] a, Dest r) { 
      name=n; args=a; rdst=r;
    }
    public Call(String n, List<Src> al, Dest r) { 
      this(n, al.toArray(new Src[0]), r);
    }
    public Call(String n, List<Src> al) { 
      this(n, al.toArray(new Src[0]), null);
    }
    public String toString() { 
      String arglist = "(";
      if (args.length > 0) {
	arglist += args[0];
	for (int i=1; i<args.length; i++)
	  arglist += ", " + args[i];
      }
      arglist +=  ")";
      String retstr = (rdst==null) ? " " : " " + rdst + " = ";
      return retstr +  "call " + name + arglist + "\n";
    }
  }

  // Inst -> "return" [Src]
  //
  public static class Return extends Inst {
    final Src val;	// could be null

    public Return() { val=null; }
    public Return(Src s) { val=s; }
    public String toString() { 
      return " return " + (val==null ? "" : val) + "\n"; 
    }
  }

  // Inst -> "if" Src ROP Src "goto" <Label>
  //
  public static class CJump extends Inst {
    final ROP op;
    final Src src1, src2;
    final Label lab;

    public CJump(ROP o, Src s1, Src s2, Label l) { 
      op=o; src1=s1; src2=s2; lab=l; 
    }
    public String toString() { 
      return " if " + src1 + " " + op + " " + src2 + 
	" goto " + lab + "\n";
    }
  }

  // Inst -> "goto" <Label>
  //
  public static class Jump extends Inst {
    final Label lab;

    public Jump(Label l) { lab=l; }
    public String toString() { 
      return " goto " + lab + "\n"; 
    }
  }

  // Inst -> <Label> ":"
  //
  public static class LabelDec extends Inst { 
    final Label lab;

    public LabelDec(Label l) { lab=l; }

    public String toString() { 
      return lab + ":\n"; 
    }
  }

  // Addr -> [<IntLit>] "[" Src "]"
  //
  public static class Addr {
    final Src base;  
    final int offset;

    public Addr(Src b) { base=b; offset=0; }
    public Addr(Src b, int o) { base=b; offset=o; }
    public String toString() {
      return "" + ((offset == 0) ? "" : offset) + "[" + base + "]";
    }
  }

  // Operands

  // Src -> <Id> | <Temp> | <IntLit> | <BoolLit> | <StrLit> 
  //
  public interface Src {}

  // Dest -> <Id> | <Temp> 
  //
  public interface Dest {}

  // <Global>
  //
  public static class Global {
    final String name;

    public Global(String s) { name = s; }
    public String toString() { return name; }
  }

  // <Label>
  //
  public static class Label {
    private static int labelnum=0;
    String name;

    public Label() { name = "L" + labelnum++; }
    public Label(String s) { name = s; }
    public void set(String s) { name = s; }
    public String toString() { return name; }
  }

  // <Id>
  //
  public static class Id implements Src, Dest  {
    final String name;

    public Id(String s) { name=s; }
    public String toString() { return name; }

    public boolean equals(Object l) {
      return (l instanceof Id && (((Id) l).name.equals(name)));
    }
    public int hashCode() {  
      return name.hashCode(); 
    }
  }

  // <Temp>
  //
  public static class Temp implements Src, Dest  {
    private static int cnt=0;
    final int num;

    public Temp() { num = ++Temp.cnt; }
    public Temp(int n) { num=n; }
    public String toString() { return "t" + num; }

    public boolean equals(Object l) {
      return (l instanceof Temp && (((Temp) l).num == num));
    }
    public int hashCode() {  
      return num; 
    }
  }

  // <IntLit>
  //
  public static class IntLit implements Src {
    final int i;

    public IntLit(int v) { i=v; }
    public String toString() { return i + ""; }
  }

  // <BoolLit>
  //
  public static class BoolLit implements Src {
    final boolean b;

    public BoolLit(boolean v) { b=v; }
    public String toString() { return b + ""; }
  }

  // <StrLit>
  //
  public static class StrLit implements Src {
    final String s;

    public StrLit(String v) { s=v; }
    public String toString() { return "\"" + s + "\""; }
  }

  // Operators

  public static interface BOP {}

  public static enum AOP implements BOP {
    ADD("+"), SUB("-"), MUL("*"), DIV("/"), AND("&&"), OR("||");
    final String name;

    AOP(String n) { name = n; }
    public String toString() { return name; }
  }

  public static enum ROP implements BOP {
    EQ("=="), NE("!="), LT("<"), LE("<="), GT(">"), GE(">=");
    final String name;

    ROP(String n) { name = n; }
    public String toString() { return name; }
  }

  public static enum UOP {
    NEG("-"), NOT("!");
    final String name;

    UOP(String n) { name = n; }
    public String toString() { return name; }
  }

}
