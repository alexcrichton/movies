CFLAGS = -O4 -Werror -Wextra -Wall -Wno-unused-parameter
CC = gcc

all: find match

adjacent: match
	./match > adj.lst

clean:
	rm find match adj.lst
