// X86-64 code generator for IR1. (A starter version)
//
// (This is a naive generator, without reg allocation.)
//
package ir1;
import java.util.*;
import java.io.*;
import target.*;

class CodeGen {

  public static void main(String [] args) throws Exception {
    if (args.length == 1) {
      FileInputStream stream = new FileInputStream(args[0]);
      Ir1.Program p = new Ir1Parser(stream).Program();
      stream.close();
      gen(p);
    } else {
      System.out.println("You must provide an input file name.");
    }
  }

  // Global Variables
  //-----------------

  static List<String> stringLiterals; 	     // accumulated string literals
  static final X86.Reg tempReg1 = X86.R10;   // scratch registers (64-bits)
  static final X86.Reg tempReg2 = X86.R11;   //  for operations
  static final X86.Reg tempReg1L = X86.R10d; // scratch registers (32-bits)
  static final X86.Reg tempReg2L = X86.R11d; //  for loads/stores

  // Environment
  //------------
  // For keeping info needed for inst codegen (one copy per function)
  //
  static class Env {
    int frameSize;                  // current stack frame size
    Map<String,Integer> offsetMap;  // params/vars/temps' frame offset
    Env(int size, Map<String,Integer> map) {
      frameSize = size;
      offsetMap = map;
    }
  }

  // Gen Routines
  //-------------

  // Program ---
  // Func[] funcs;
  //
  // Guideline:
  // - create a string literal list
  // - generate code for functions
  // - emit string literals to a single data section
  //
  public static void gen(Ir1.Program n) throws Exception {
    stringLiterals = new ArrayList<String>();
    stringLiterals.add("%d\\n");   // the print control string
    X86.emit0(".text");
    for (Ir1.Func f: n.funcs)
      gen(f);
    X86.emitComment("string literals\n");
    X86.emit0(".data");
    //stringLiterals.add("%d\\n");

    for(int i=0; i < stringLiterals.size(); ++i){
      X86.emitLabel(new X86.Label(".S"+i));
      X86.emitString(stringLiterals.get(i));
    }
  }

  // Func ---
  // String name;
  // Var[] params;
  // Var[] locals;
  // Inst[] code;
  //
  // Guideline:
  // - emit the function header
  // - compute frameSize
  // - emit code to allocate a new frame on the stack
  // - create a hashmap for mapping params/vars/temps to frame offsets
  // - add params to the hashmap, simply fail if there are >6 params
  // - emit code to move actual arguments from argRegs to frame locations
  // - call gen routine on the instructions of function body
  //
  static void gen(Ir1.Func n) throws Exception {

    // ... code needed ...
    int paramCnt  = n.params.length;
    int varCnt    = n.locals.length;
    int instCnt   = n.code.length;

    if(paramCnt > 6)
      throw new Exception ("Too many parameters > 6");

    int frameSize = (paramCnt + varCnt + instCnt) * 4;
    if((frameSize % 16) == 0)
      frameSize += 8;

    Map<String,Integer> offsets = new HashMap <String,Integer>();
    String str = "";
    int x = 0;
    if(varCnt > 0 && paramCnt > 0){
      //X86.emit0("INside double");
      String str2 = "";
      for(int i=0; i<paramCnt; ++i){
          offsets.put(n.params[i], (x+=4));
      if(i == paramCnt-1){
        str = str + n.params[i];
        }
        else
          str = str + n.params[i] + ", ";
        }

      for(int i=0; i<varCnt; ++i){
        if(i == varCnt-1){

          str2 = str2 + n.locals[i];
        }
        else
          str2 = str2 + n.locals[i] + ", ";
        }
        X86.emitComment(n.name+" ("+str+")" + " (" + str2 + ")");
    }
    else if(varCnt > 0){
       str= "";
      for(int i=0; i<varCnt; ++i){
        if(i == varCnt-1)
          str = str + n.locals[i];
        else
          str = str + n.locals[i] + ", ";
      }
      X86.emitComment(n.name+" ()" + " (" + str + ")");
    }
    else if(paramCnt > 0){
          for(int i=0; i<paramCnt; ++i){
        offsets.put(n.params[i], (x+=4));
        if(i == paramCnt-1)
          str = str + n.params[i];
        else
          str = str + n.params[i] + ", ";
      }
        X86.emitComment(n.name+"" + " (" + str + ")");

    }
    else
      X86.emitComment(n.name+" ()");
    X86.emit0("\n\t.globl "+n.name);

    X86.emitLabel(new X86.Label(n.name));
    Env env = new Env(frameSize, offsets);
    X86.emit2("subq", new X86.Imm(env.frameSize), X86.RSP);
    if(paramCnt > 0){
      for(int i=0; i<paramCnt; ++i){
        int pos = env.offsetMap.get(n.params[i]);
        X86.emit2("movq", X86.argRegs[i], new X86.Mem(X86.RSP, pos));
      }
    }
    for (Ir1.Inst f: n.code){
      gen(f, env);
    }
  }

  // INSTRUCTIONS

  static void gen(Ir1.Inst n, Env env) throws Exception {
    X86.emitComment(n.toString());
    if (n instanceof Ir1.Binop) 	gen((Ir1.Binop) n, env);
    else if (n instanceof Ir1.Unop) 	gen((Ir1.Unop) n, env);
    else if (n instanceof Ir1.Move) 	gen((Ir1.Move) n, env);
    else if (n instanceof Ir1.Load) 	gen((Ir1.Load) n, env);
    else if (n instanceof Ir1.Store) 	gen((Ir1.Store) n, env);
    else if (n instanceof Ir1.LabelDec) gen((Ir1.LabelDec) n, env);
    else if (n instanceof Ir1.CJump) 	gen((Ir1.CJump) n, env);
    else if (n instanceof Ir1.Jump) 	gen((Ir1.Jump) n, env);
    else if (n instanceof Ir1.Call)     gen((Ir1.Call) n, env);
    else if (n instanceof Ir1.Return)   gen((Ir1.Return) n, env);
    else throw new Exception("Illegal IR1 instruction: " + n);
  }

  // Binop ---
  //  BOP op;
  //  Dest dst;
  //  Src src1, src2;
  //
  // Guideline:
  // - check to see if dst (which should be either a var or a temp)
  //   is in Env.HashMap; if not, adds it in
  //
  // - Regular cases (ADD, SUB, MUL, AND, OR):
  //   . call gen() to generate code for both operands and bring
  //     them to two tempRegs
  //   . generate code for the operation
  //
  // - For DIV:
  //   . generate code for first operand and bring it into RAX
  //   . generate code for second operand and bring it into a tempReg
  //   . generate "cqto" (sign-extend into RDX) and "idivq"
  //
  // - For relational ops:
  //   . generate "cmp" and "set" (note: set takes a byte-sized reg)
  //   . generate "movzbq" to size--extend the involved register
  //
  // - store result into dst's frame slot
  //
  static void gen(Ir1.Binop n, Env env) throws Exception {
    if(env.offsetMap.containsKey(n.dst.toString()) == false){
      int size = env.offsetMap.size()+1; //Get the size of the HashMap if non-empty
      int offset = (size*4);
      env.offsetMap.put(n.dst.toString(), offset);
    }

    //For Regular classes
    if(n.op instanceof Ir1.AOP){
      if(n.op == Ir1.AOP.DIV){
        if(n.src1 instanceof Ir1.Temp || n.src1 instanceof Ir1.Id)
          gen(n.src1, X86.EAX, env); //Bring first operandinto rax
        else
          gen(n.src1, X86.RAX, env);

        if(n.src2 instanceof Ir1.Temp || n.src1 instanceof Ir1.Id)
          gen(n.src2, X86.R10d, env); //Bring second operand into a temp  reg
        else
          gen(n.src2, X86.R10, env);

        X86.emit0("cqto"); //generate cqto
        String op = opname((Ir1.AOP)n.op);
        X86.emit1(op, X86.R10);
        X86.Mem mem = new X86.Mem(X86.RSP, null, frameOffset(n.dst, env), 2);
        X86.emit2("movl", X86.EAX, mem);
      }
      else{
        if((n.src1 instanceof Ir1.IntLit || n.src1 instanceof Ir1.BoolLit) && (n.src2 instanceof Ir1.IntLit || n.src2 instanceof Ir1.BoolLit)){
          gen(n.src1, X86.R10, env);
          gen(n.src2, X86.R11, env);
        }
        if ((n.src1 instanceof Ir1.Id || n.src1 instanceof Ir1.Temp) && (n.src2 instanceof Ir1.IntLit || n.src2 instanceof Ir1.BoolLit)){
          gen(n.src1, X86.R10d, env);
          gen(n.src2, X86.R11, env);
        }
        if((n.src1 instanceof Ir1.IntLit || n.src1 instanceof Ir1.BoolLit) && (n.src2 instanceof Ir1.Id || n.src2 instanceof Ir1.Temp)){
          gen(n.src1, X86.R10, env);
          gen(n.src2, X86.R11d, env);
        }
        if((n.src1 instanceof Ir1.Id || n.src1 instanceof Ir1.Temp) && (n.src2 instanceof Ir1.Id || n.src2 instanceof Ir1.Temp)){
          gen(n.src1, X86.R10d, env);
          gen(n.src2, X86.R11d, env);
        }
        X86.Reg reg1;
        X86.Reg reg2;

        String op = opname((Ir1.AOP)n.op);
        X86.emit2(op, X86.R11, X86.R10);
        X86.Mem mem = new X86.Mem(X86.RSP, null, frameOffset(n.dst, env), 2);
        X86.emit2("movl", X86.R10d, mem);
      }
    }
    if(n.op instanceof Ir1.ROP){
      String op = opname((Ir1.ROP)n.op); //Get the String for ROP op

      if(n.src1 instanceof Ir1.Temp || n.src1 instanceof Ir1.Id)
        gen(n.src1, X86.R10d, env); //Bring first operandinto rax
      else
        gen(n.src1, X86.R10, env);

      if(n.src2 instanceof Ir1.Temp || n.src2 instanceof Ir1.Id)
        gen(n.src2, X86.R11d, env);
      else
        gen(n.src2, X86.R11, env);

      //Call cmp
      X86.emit2("cmpq", X86.R11, X86.R10);
      X86.Reg R11b = new X86.Reg(11, X86.Size.B);
      X86.emit1("set"+op, R11b);
      X86.emit2("movzbq", R11b, X86.R11);
      X86.Mem mem = new X86.Mem(X86.RSP, null, frameOffset(n.dst, env), 2);
      X86.emit2("movl", X86.R11d, mem);
    }
  }

  // Unop ---
  //  UOP op;
  //  Dest dst;
  //  Src src;
  //
  // Guideline:
  // - call gen() to generate code for the operand
  // - generate code for the operation
  // - store result into dst's frame slot
  //
  static void gen(Ir1.Unop n, Env env) throws Exception {
    int size = env.offsetMap.size()+1; //Get the size of the HashMap if non-empty
    int offset = (size*4);
    env.offsetMap.put(n.dst.toString(), offset);

    if(n.src instanceof Ir1.Temp || n.src instanceof Ir1.Id)
        gen(n.src, X86.R10d, env);
    else
      gen(n.src, X86.R10, env);

    String op = opname(n.op);
    X86.emit1(op, X86.R10);
    X86.Mem mem = new X86.Mem(X86.RSP, null, frameOffset(n.dst, env), 2);
    X86.emit2("movl", X86.R10d, mem);


  }

  // Move ---
  //  Dest dst;
  //  Src src;
  //
  // Guideline:
  // - call gen() to generate code for the src
  // - generate a "mov" to store result to dst's frame slot
  //
  static void gen(Ir1.Move n, Env env) throws Exception {
    int size;
    if(env.offsetMap == null)
      throw new Exception ("env offsetMap is EMPTY F: move");

      size = env.offsetMap.size()+1; //Get the size of the HashMap if non-empty
      int offset = (size*4);
      if(env.offsetMap.containsKey(n.dst.toString()) == false)
        env.offsetMap.put(n.dst.toString(), offset);
    if(n.src instanceof Ir1.IntLit ){
      gen(n.src,tempReg1, env);
      String str = n.dst.toString();
      int get = env.offsetMap.get(str);
      str = Integer.toString(get);
      X86.emit2("movl", X86.R10d, new X86.Mem(X86.RSP, get));
    }
    else if(n.src instanceof Ir1.BoolLit ){
      gen(n.src,tempReg1, env);
      String str = n.dst.toString();
      int get = env.offsetMap.get(str);
      str = Integer.toString(get);
      int i = 0;
      if(((Ir1.BoolLit)n.src).b == true)
        i = 1;
      else
        i = 0;
      X86.emit2("movl", X86.R10d, new X86.Mem(X86.RSP, get));
    }
    else if (n.src instanceof Ir1.Temp){
      gen(n.src,X86.R10d, env);
      String str = n.dst.toString();
      int get = env.offsetMap.get(str);
      X86.Mem mem = new X86.Mem(X86.RSP, null, get, 2);
      X86.emit2("movl", X86.R10d, mem);
    }
    else if(n.src instanceof Ir1.Id){
      gen(n.src, X86.R10d, env); // Gen for src
      X86.emit2("movl", X86.R10d, new X86.Mem(X86.RSP, frameOffset(n.dst, env)));
    }
    else{
      throw new Exception ("unknown n.src of type"+n.src.getClass().getName());
    }
  }

  // Load ---
  //  Dest dst;
  //  Addr addr;
  //
  // Guideline:
  // - call gen_addr() to generate code for addr
  // - generate a "mov" to load data
  //   (note: all IR1's stored values are integers)
  //
  static void gen(Ir1.Load n, Env env) throws Exception {
    int off = (env.offsetMap.size() + 1) * 4;
    env.offsetMap.put (n.dst.toString(), off);
    X86.Operand op = gen(n.addr, X86.R10d, env);
    X86.emit2("movslq", op, X86.R10);
    X86.emit2("movl", X86.R10d, new X86.Mem(X86.RSP, frameOffset(n.dst, env)));
  }

  // Store ---
  //  Addr addr;
  //  Src src;
  //
  // Guideline:
  // - call gen() to generate code for src
  // - call gen_addr() to generate code for addr
  // - generate a "mov" to store data
  //   (note: all IR1's stored values are integers)
  //
  static void gen(Ir1.Store n, Env env) throws Exception {
    gen(n.src, X86.R10, env);
    X86.Operand op = gen(n.addr, X86.R11d, env);
    X86.emit2("movl", X86.R10d, op);
  }

  // LabelDec ---
  //  Label lab;
  //
  static void gen(Ir1.LabelDec n, Env env) {
    X86.emitLabel(new X86.Label(n.lab.name));
  }

  // CJump ---
  //  ROP op;
  //  Src src1, src2;
  //  Label lab;
  //
  // Guideline:
  // - recursively generate code for both operands
  // - generate a "cmp" and a jump instruction
  //   . remember: left and right are switched under gnu assembler
  //   . conveniently, IR1 and X86 names for the condition
  //     suffixes are the same
  //
  static void gen(Ir1.CJump n, Env env) throws Exception {
    gen(n.src1, X86.R10d, env);
    gen(n.src2, X86.R11, env);
    X86.emit2("cmpq", X86.R11, X86.R10);
    X86.emit1("je", new X86.Label(n.lab.name));
  }

  // Jump ---
  //  Label lab;
  //
  static void gen(Ir1.Jump n, Env env) throws Exception {
    X86.emit0("jmp " +new X86.Label(n.lab.name));
  }

  // Call ---
  //  String name;
  //  Src[] args;
  //  Dest rdst;
  //
  // Guideline:
  // - check name to single out "printInt" and "printStr"
  //   . for printInt, generate code for loading the control string
  //     "%d\n" (which should have been placed in the global string
  //     list) into RDI, then generate code for loading args[0] into
  //     RSI
  //   . for printStr, generate code for loading args[0] into RDI
  //   . emit "call printf"
  //
  // - for other cases,
  //   . generage code for loading args into argRegs (RDI, RSI, RDX,
  //     RCX, R8, R9)
  //   . emit a "call" to func name
  //   . if rdst is not null, generate a "mov" to copy result from RAX
  //     to its frame slot
  //
  static void gen(Ir1.Call n, Env env) throws Exception {
    if(n.name.equals("printInt") || n.name.equals("printStr")){
      if(n.name.equals("printStr")){
        gen(n.args[0],X86.RDI, env);
      }
      else{
        int strIdx = 0;
        X86.emit2("leaq", new X86.AddrName(".S" + strIdx), X86.RDI);

        if(n.args[0] instanceof Ir1.IntLit || n.args[0] instanceof Ir1.BoolLit)
          gen(n.args[0], X86.RSI, env);
        else {
          gen(n.args[0], X86.ESI, env);
        }
      }
      X86.emit2("xorl", X86.EAX, X86.EAX);
      X86.emit0("call printf");
    }
    else if(n.name.equals("malloc")){
      X86.emit2("movq", new X86.Imm(((Ir1.IntLit)n.args[0]).i), X86.RDI);
      X86.emit0("call malloc");

      if(n.rdst != null){
        int offset = (env.offsetMap.size() + 1) * 4;
        env.offsetMap.put(n.rdst.toString(), offset);
        String str = n.rdst.toString();
        int get = env.offsetMap.get(str);
        X86.Mem mem = new X86.Mem(X86.RSP, null, get, 2);
        X86.emit2("movl", X86.EAX, mem);
      }
    }
    else{
      if(n.args != null && n.args.length > 0){
        for(int i=0; i<n.args.length; ++i){
          if(n.args[i] instanceof Ir1.Temp || n.args[i] instanceof Ir1.Id)
            gen(n.args[i], X86.argRegsL[i], env);
          else
            gen(n.args[i], X86.argRegs[i], env);
        }
      }
      X86.emit0("call " + n.name);
      int off = (env.offsetMap.size()  + 1) * 4;
      env.offsetMap.put(n.rdst.toString(),off);
      X86.emit2("movl", X86.EAX, new X86.Mem(X86.RSP, off));
    }

  }

  // Return ---
  //  Src val;
  //
  // Guideline:
  // - if there is a value, emit a "mov" to move it to RAX
  // - pop the frame (add framesize back to stack pointer)
  // - emit a "ret"
  //
  static void gen(Ir1.Return n, Env env) throws Exception {

    // ... code needed ...
    if(n.val != null){
      if(n.val instanceof Ir1.Temp || n.val instanceof Ir1.Id)
        gen(n.val, X86.EAX, env); // Move to EAX if id or temp
      else
        gen(n.val, X86.RAX, env);
    }
    X86.emit0 ("addq"+" $"+env.frameSize+", "+"%rsp");
    X86.emit0("ret");
  }

  // OPERANDS

  // Guideline:
  //
  // * Id & Temp ---
  //   - find Id's frame offset
  //   - generate code to load its value from frame slot
  //     (note: all IR1's stored values are integers)
  //
  // * IntLit & BoolLit ---
  //   - treat boolean values as integers 0 and 1
  //   - generate code to load its value to designated reg
  //
  // * StrLit ---
  //   - add string to the global string list
  //   - generate code to load its label to designated reg
  //
  static void gen(Ir1.Src n, X86.Reg reg, Env env) throws Exception {
    if (n instanceof Ir1.Id) {
      String str = n.toString();
      int get = env.offsetMap.get(str);
      X86.Mem mem = new X86.Mem(X86.RSP, null, get, 2);
      X86.emit2("movl", mem, reg);
    }
    else if (n instanceof Ir1.Temp) {
      String str = n.toString();
      int get = env.offsetMap.get(str);
      X86.Mem mem = new X86.Mem(X86.RSP, null, get, 2);
      X86.emit2("movl", mem, reg);
    }
    else if (n instanceof Ir1.IntLit) {
      int strIdx = 0;
      X86.emit2("movq", new X86.Imm(((Ir1.IntLit)n).i), reg);
    }
    else if (n instanceof Ir1.BoolLit) {
      int i = 0;
      if(((Ir1.BoolLit)n).b == true)
        i = 1;
      else
        i = 0;

      X86.emit2("movq", new X86.Imm(i), reg);
    } else if (n instanceof Ir1.StrLit) {
      int strIdx = stringLiterals.size();
      stringLiterals.add(((Ir1.StrLit)n).s + "\\n");
      X86.emit2("leaq", new X86.AddrName(".S" + strIdx), reg);
    } else
      throw new Exception("Illegal IR1 operand: " + n);
  }

  // Addr ---
  // Src base;
  // int offset;
  //
  // Guideline:
  // - call gen() on base to place it in a reg
  // - generate a memory operand (i.e. X86.Mem)
  //
  static X86.Operand gen(Ir1.Addr addr, X86.Reg reg, Env env) throws Exception {
    gen(addr.base, reg, env);
    return new X86.Mem(new X86.Reg(reg.r()), addr.offset);
  }

  //----------------------------------------------------------------------------------
  // Ultilities
  //------------

  // Check if dest (which is either a var or a temp) is in offsetMap,
  // if not, add it in; return dest's frame offset
  //
  static int frameOffset(Ir1.Dest dest, Env env) throws Exception {
    int off = env.offsetMap.get(((Ir1.Src)dest).toString());
    return off;
  }

  static String opname(Ir1.AOP op) {
    switch(op) {
    case ADD: return "addq";
    case SUB: return "subq";
    case MUL: return "imulq";
    case DIV: return "idivq"; // not used
    case AND: return "andq";
    case OR:  return "orq";
    }
    return null; // impossible
  }

  static String opname(Ir1.ROP op) {
    switch(op) {
    case EQ: return "e";
    case NE: return "ne";
    case LT: return "l";
    case LE: return "le";
    case GT: return "g";
    case GE: return "ge";
    }
    return null; // impossible
  }

  static String opname(Ir1.UOP op) {
    switch(op) {
    case NEG: return "negq";
    case NOT: return "notq";
    }
    return null; // impossible
  }

}
