
src=/home/carlo/supercollider

all: main 

main: main.cpp
	g++ -I $(src)/include/common -I $(src)/include/lang -I $(src)/include/plugin_interface -I $(src)/include/server main.cpp -ldl -o min

clean:
	rm -f min

