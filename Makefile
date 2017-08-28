NAME=urlhandler

CFLAGS += -O3 -fobjc-arc
LDFLAGS += -framework CoreServices

TARGETDIR = ~/bin

all: $(NAME)

$(TARGETDIR)/$(NAME): $(NAME)
	install -s -m 0755 $< $@

install: $(TARGETDIR)/$(NAME)

uninstall:
	$(RM) $(TARGETDIR)/$(NAME)

clean:
	$(RM) $(NAME)
