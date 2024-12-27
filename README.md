# Documentation pour github

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
 git push origin develop_bruno
```

## Mettre les informations de la branche "develop" dans la branche "master"
Dans la branche "develop"
```bash
 git merge develop_bruno
```
Dans la branche "master"
```bash
 git push origin master
```