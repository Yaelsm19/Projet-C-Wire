# Chemin complet de l'exécutable
EXEC = /workspaces/Projet-C-Wire/Code_C/main.exe

# Fichiers source (ajouter tous les fichiers nécessaires)
SRC = /workspaces/Projet-C-Wire/Code_C/main.c \
      /workspaces/Projet-C-Wire/Code_C/avl_operations.c \
      /workspaces/Projet-C-Wire/Code_C/avl_file_operations.c

# Chemins des fichiers d'en-tête (ajoutez ici si vous avez un dossier include)
INCLUDE = -I/workspaces/Projet-C-Wire/Code_C

# Compilateur et options
CC = gcc
CFLAGS = -Wall -g

# Compilation (par défaut)
all: $(EXEC)

# Règle pour construire l'exécutable dans le répertoire cible
$(EXEC): $(SRC)
	$(CC) $(CFLAGS) $(INCLUDE) -o $(EXEC) $(SRC)

# Exécution avec des arguments (ARGS peut être vide ou défini lors de l'appel)
run: all
	@echo "Running: $(EXEC) $(ARGS)"
	@$(EXEC) $(ARGS)

# Nettoyage des fichiers générés
clean:
	rm -f $(EXEC)

# Aide pour afficher les cibles disponibles
help:
	@echo "Makefile commands:"
	@echo "  make           : Compile le programme dans 'Code_C'."
	@echo "  make run ARGS=\"arg1 arg2\" : Compile et exécute le programme avec des arguments."
	@echo "  make clean     : Supprime l'exécutable généré."
	@echo "  make help      : Affiche cette aide."
