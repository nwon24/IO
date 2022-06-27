NAME = mango
CC = cc
CFLAGS = -std=c11 -Wall -Wextra -pedantic -ggdb

all: ${NAME}.w
	ctangle ${NAME}.w
	$(CC) ${NAME}.c -o ${NAME} $(CFLAGS)
	cweave ${NAME}.w
	tex ${NAME}
	dvipdfmx ${NAME}
