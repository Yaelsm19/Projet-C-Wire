# Chemin relatif de l'exécutable
EXEC = main.exe

# Fichiers source (chemins relatifs)
SRC = main.c \
      avl_operations.c \
      avl_file_operations.c

# Chemins des fichiers d'en-tête
INCLUDE = -I.

# Compilateur et options
CC = gcc
CFLAGS = -Wall -g

# Compilation (par défaut)
all: $(EXEC)

# Règle pour construire l'exécutable
$(EXEC): $(SRC)
	@$(CC) $(CFLAGS) $(INCLUDE) -o $(EXEC) $(SRC)

# Exécution avec des arguments
run: all
	@./$(EXEC) $(ARGS)

# Nettoyage des fichiers générés
clean:
	@rm -f $(EXEC)

# Aide pour afficher les cibles disponibles
help:
	@echo "Usage:"
	@echo "  make           : Compile le programme."
	@echo "  make run ARGS=\"arg1 arg2\" : Compile et exécute le programme avec des arguments."
	@echo "  make clean     : Supprime l'exécutable généré."
