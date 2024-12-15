# Nom de l'exécutable
EXEC = main
SRC = main.c
CC = gcc

# Compilation
all:
	$(CC) -o $(EXEC) $(SRC)

# Exécution avec les arguments
run:
	./$(EXEC) $(ARGS)

# Nettoyage
clean:
	rm -f $(EXEC)