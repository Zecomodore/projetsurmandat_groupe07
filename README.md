# Documentation pour github

## Espace de développement pour Bryan
Espace dédié pour le développement des fonctionnalités que Bryan gérera

## Rédiger un commit
Dans l'interface commit -> appuyer sur i pour insérer le titre et la description
```
Titre du commit

Description de notre commit avec des informations sur l'évolution du projet
```
Appuyer sur "esc" pour sortir de l'interface.

":wq" -> w = write / q = quite

## Envoyer un commit sur le dépôt distant
```bash
 git add . // git add README.md test.md ...
 git status
 git commit
 git push origin develop_bryan
```

## Créer une nouvelle branche
```bash
 git checkout -b NOM_BRANCHE
```

## Mettre les informations de la branche "develop" dans la branche "master"
Dans la branche "develop"
```bash
 git merge develop_bryan
```
Dans la branche "master"
```bash
 git push origin master
```