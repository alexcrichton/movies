CFLAGS = -O4 -Werror -Wextra
CC = gcc

all: find

find: find.c
	$(CC) $(CFLAGS) -o find find.c

clean:
	rm find