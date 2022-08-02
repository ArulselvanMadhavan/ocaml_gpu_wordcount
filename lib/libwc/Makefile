CFLAGS=-std=c99 -O3 -lm

OS=$(shell uname -s)
ifeq ($(OS),Darwin)
OPENCL_LDFLAGS?=-framework OpenCL
else
OPENCL_LDFLAGS?=-lOpenCL
endif

.PHONY: clean run libwc-c libwc-opencl

all: wc-c wc-opencl huge.txt

run: wc-c wc-opencl huge.txt
	LC_ALL=C time wc huge.txt
	./wc-c -t huge.txt
	./wc-opencl -t huge.txt

libwc-opencl.c libwc-opencl.h: libwc.fut
	futhark opencl --library libwc.fut -o libwc-opencl

libwc-c.c libwc-c.h: libwc.fut
	futhark c --library libwc.fut -o libwc-c

wc-c: wc.c libwc-c.c libwc-c.h
	gcc wc.c libwc-c.c -o wc-c $(CFLAGS)

wc-opencl: wc.c libwc-opencl.c libwc-opencl.h
	gcc wc.c libwc-opencl.c -o wc-opencl $(CFLAGS) $(OPENCL_LDFLAGS) -DOPENCL

huge.txt: big.txt
	cat big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt big.txt > huge.txt

clean:
	rm -f wc-* libwc-*.c libwc-*.h libwc-*.a libwc-*.so libwc-*.o libwc-*.json huge.txt

libwc-c.o: libwc-c.c
	gcc -c libwc-c.c -fPIC -o libwc-c.o $(CFLAGS)

libwc-c.so: libwc-c.o
	gcc -shared libwc-c.o -o libwc-c.so

libwc-c.a: libwc-c.o
	ar crs libwc-c.a libwc-c.o

libwc-c: clean libwc-c.so libwc-c.a

libwc-opencl.o: libwc-opencl.c
	gcc -c libwc-opencl.c -fPIC -o libwc-opencl.o $(CFLAGS) $(OPENCL_LDFLAGS) -DOPENCL

libwc-opencl.so: libwc-opencl.o
	gcc -shared libwc-opencl.o -o libwc-opencl.so $(CFLAGS) $(OPENCL_LDFLAGS) -DOPENCL

libwc-opencl.a: libwc-opencl.o
	ar crs libwc-opencl.a libwc-opencl.o

libwc-opencl: clean libwc-opencl.so libwc-opencl.a
