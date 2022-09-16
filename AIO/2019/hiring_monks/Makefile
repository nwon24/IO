NAME = monks
CC = g++
CFLAGS = -std=c++17 -Wall -Wextra -pedantic -ggdb -O2

all: ${NAME}.w
	ctangle ${NAME}.w - ${NAME}.cpp
	$(CC) ${NAME}.cpp -o ${NAME} $(CFLAGS)
	cweave ${NAME}.w
	tex ${NAME}
	dvipdfmx ${NAME}
