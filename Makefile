
.PHONE: clean gen-file

clean:
	rm -rf huge.txt

gen-file: clean
	bash scripts/gen-file.sh

run: gen-file
	dune exec ./bin/main.exe
