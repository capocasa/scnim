
scnim?=/usr/src/scnim
name=Example

all: main 

main: $(name)UGens.nim
	nim --path=$(scnim) --deadCodeElim=on --gc=none --app=lib -d:release --out=$(name)UGens.so cpp $(name)UGens.nim
	strip $(name)UGens.so

clean:
	rm -f nimcache/*
	rmdir nimcache
	rm -f $(name)UGens.so

