CONFIG=Makefile.config

include $(CONFIG)

default: build

build:

	for file in \
		bin/bloonix-wtrm \
		bin/bloonix-init-wtrm \
		etc/init/bloonix-wtrm \
		etc/init/bloonix-wtrm.service \
	; do \
		cp $$file.in $$file; \
		sed -i "s!@@PERL@@!$(PERL)!g" $$file; \
		sed -i "s!@@PREFIX@@!$(PREFIX)!g" $$file; \
		sed -i "s!@@CACHEDIR@@!$(CACHEDIR)!g" $$file; \
		sed -i "s!@@CONFDIR@@!$(CONFDIR)!g" $$file; \
		sed -i "s!@@RUNDIR@@!$(RUNDIR)!g" $$file; \
		sed -i "s!@@USRLIBDIR@@!$(USRLIBDIR)!" $$file; \
		sed -i "s!@@SRVDIR@@!$(SRVDIR)!g" $$file; \
		sed -i "s!@@LIBDIR@@!$(LIBDIR)!g" $$file; \
		sed -i "s!@@LOGDIR@@!$(LOGDIR)!g" $$file; \
	done;

test:

install:

	./install-sh -d -m 0750 $(LOGDIR)/bloonix;
	./install-sh -d -m 0755 $(RUNDIR)/bloonix;
	./install-sh -d -m 0755 $(PREFIX)/bin;
	./install-sh -d -m 0755 $(CONFDIR)/bloonix;
	./install-sh -d -m 0755 $(CONFDIR)/bloonix/wtrm;
	./install-sh -c -m 0755 bin/bloonix-wtrm $(PREFIX)/bin/bloonix-wtrm;
	./install-sh -c -m 0755 bin/bloonix-init-wtrm $(PREFIX)/bin/bloonix-init-wtrm;
	./install-sh -d -m 0755 $(USRLIBDIR)/bloonix/etc/wtrm;
	./install-sh -c -m 0644 etc/bloonix/wtrm/main.conf $(USRLIBDIR)/bloonix/etc/wtrm/main.conf;
	./install-sh -d -m 0755 $(USRLIBDIR)/bloonix/etc/init.d;
	./install-sh -c -m 0755 etc/init/bloonix-wtrm $(USRLIBDIR)/bloonix/etc/init.d/bloonix-wtrm;
	./install-sh -d -m 0755 $(USRLIBDIR)/bloonix/etc/systemd;
	./install-sh -c -m 0755 etc/init/bloonix-wtrm.service $(USRLIBDIR)/bloonix/etc/systemd/bloonix-wtrm.service;

	if test "$(BUILDPKG)" = "0" ; then \
		if test -d /usr/lib/systemd ; then \
			./install-sh -d -m 0755 $(DESTDIR)/usr/lib/systemd/system/; \
			./install-sh -c -m 0644 etc/init/bloonix-wtrm.service $(DESTDIR)/usr/lib/systemd/system/; \
			systemctl daemon-reload; \
		elif test -d /etc/init.d ; then \
			./install-sh -c -m 0755 etc/init/bloonix-wtrm $(INITDIR)/bloonix-wtrm; \
		fi; \
	fi;

clean:

