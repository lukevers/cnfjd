PROGRAM := cnfjd

.PHONY: all install clean

all: $(PROGRAM)

$(PROGRAM):
	nim c -d:ssl -d:release cnfjd.nim

install: $(PROGRAM)
	@- install -m 755 $(PROGRAM) /usr/local/bin

clean:
	@- $(RM) $(PROGRAM)
