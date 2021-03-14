# path to sources

SRCPATH := src/mini_c

# integrate auto-generated java files into project via jar file

JAVAC := javac -cp lib/java-cup-11a-runtime.jar -d bin

all: $(SRCPATH)/Lexer.java $(SRCPATH)/Parser.java
	$(JAVAC) $(SRCPATH)/*.java

# cup and flex compilation into .java files

JAVACUP := java -jar ../../lib/java-cup-11a.jar

$(SRCPATH)/Parser.java $(SRCPATH)/sym.java: $(SRCPATH)/Parser.cup
	rm -f $@
	cd $(SRCPATH) && $(JAVACUP) -package mini_c -parser Parser Parser.cup

JAVAFLEX := jflex 

$(SRCPATH)/Lexer.java: $(SRCPATH)/Lexer.flex
	rm -f $@
	$(JAVAFLEX) $<
