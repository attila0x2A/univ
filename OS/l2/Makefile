.PHONY: all
all: Hello.exe


run: Hello.exe
	@mono $<

Hello.exe: Hello.cs
	@mcs $<
