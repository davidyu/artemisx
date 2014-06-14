.PHONY: test doc clean

doc: doc/index.html

%/index.html: %/haxedoc.xml
	cd "$*" && chxdoc -o . -f haxedoc.xml --policy=deny --deny=com.artemisx.test.* --allow=com.artemisx.* --title=artemisx

%/haxedoc.xml:
	haxe -xml "$@" test.hxml

test:
	haxe test.hxml
	neko bin/test.n

clean:
	rm bin/*
