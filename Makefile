# Nom de l'exécutable
EXEC = main.exe

# Fichiers source
SRC = /workspaces/Projet-C-Wire/Code\ C/main.c

# Compilateur et options
CC = gcc
CFLAGS = -Wall -g

# Compilation (par défaut)
all: $(EXEC)

# Règle pour construire l'exécutable
$(EXEC): $(SRC)
	$(CC) $(CFLAGS) -o $(EXEC) $(SRC)

# Exécution avec des arguments (ARGS peut être vide ou défini lors de l'appel)
run: all
	@echo "Running: ./$(EXEC) $(ARGS)"
	@./$(EXEC) $(ARGS)

# Nettoyage des fichiers générés
clean:
	rm -f $(EXEC)

# Aide pour afficher les cibles disponibles
help:
	@echo "Makefile commands:"
	@echo "  make           : Compile le programme."
	@echo "  make run ARGS=\"arg1 arg2\" : Compile et exécute le programme avec des arguments."
	@echo "  make clean     : Supprime les fichiers générés (exécutables)."
	@echo "  make help      : Affiche cette aide."
