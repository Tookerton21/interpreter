# Makefile for CS422 assign4. (Jingke Li)
#
JFLAGS = -g
JC = javac

.SUFFIXES: .java .class

.PRECIOUS: %.java

.java.class:
	$(JC) $(JFLAGS) $*.java

ir1cgen: ir1/Ir1.class ir1/Ir1Parser.class target/X86.class ir1/CodeGen.class

all:	ir1cgen

clean:
	'rm' ir1/*.class


