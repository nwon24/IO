NAME = ghost
CC = cc
CFLAGS = -std=c11 -O2 -Wall -Wextra -pedantic -ggdb -O2

all: ${NAME}.w
	ctangle ${NAME}.w
	$(CC) ${NAME}.c -o ${NAME} $(CFLAGS)
	cweave ${NAME}.w
	tex ${NAME}
	dvipdfmx ${NAME}
