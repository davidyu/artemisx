.PHONY: test clean

test:
	haxe test.hxml
	neko bin/test.n

clean:
	rm bin/*
