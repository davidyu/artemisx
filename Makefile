.PHONY: test doc clean

doc: doc/index.html

%/index.html: %/haxedoc.xml %/template.xml
	cd "$*" && haxedoc haxedoc.xml -f com

%/haxedoc.xml:
	haxe -xml "$@" test.hxml

test:
	haxe test.hxml
	neko bin/test.n

clean:
	rm bin/*
