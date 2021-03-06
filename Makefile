### Makefile --- 

## Author: shell@dsk
## Version: $Id: Makefile,v 0.0 2020/04/29 14:02:48 shell Exp $
## Keywords: 
## X-URL: 
LEVEL=NOTICE
VERSION=$(shell dpkg-parsechangelog --show-field Version)
GIT_COMMIT=$(shell git rev-list -1 HEAD | head -c 8)

all: clean build

clean:
	rm -rf bin pkg gopath debuild *.log

build: bin/doh

bin/doh:
	mkdir -p gopath/src/github.com/shell909090/
	ln -s "$$PWD" gopath/src/github.com/shell909090/doh
	mkdir -p bin
	GOPATH="$$PWD/gopath":"$$GOPATH" go build -o bin/doh -ldflags "-X main.Version=$(VERSION)-$(GIT_COMMIT)" github.com/shell909090/doh/doh
	rm -rf gopath

install: bin/doh
	install -d $(DESTDIR)/usr/bin/
	install -m 755 -s bin/doh $(DESTDIR)/usr/bin/

test:
	go test -v github.com/shell909090/doh/iplist

benchmark:
	go test -v github.com/shell909090/doh/iplist -bench . -benchmem

build-deb:
	dpkg-buildpackage --no-sign
	mkdir -p debuild
	mv -f ../doh_* debuild

testquery:
	scripts/test.sh query
	scripts/test.sh short
	scripts/test.sh edns
	scripts/test.sh rfc8484
	scripts/test.sh google
	scripts/test.sh http
	scripts/test.sh https

test-public:
	scripts/diagdns www.twitter.com www.baidu.com www.google.com www.taobao.com www.jd.com open.163.com github.com en.wikipedia.org www.startpage.com

### Makefile ends here
