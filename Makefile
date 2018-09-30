.PHONY: all rompr

all: rompr

rompr:
	git clone -b rompr https://github.com/christiansteier/MuCuBox.git --depth 1
	git clone https://github.com/armbian/build --depth 1
	cp -ar build/* MuCuBox/
	rm -rf build
	mv MuCoBox build
	cd build
	./compile docker
