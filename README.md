# Documentation pour github

## Initialisation du dépôt

```bash
 git init
 git remote add origin https://github.com/Zecomodore/projetsurmandat_groupe07.git
```

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
 git push origin master
```

## Créer une nouvelle branche
```bash
 git checkout -b NOM_BRANCHE
```

## Mettre les informations de la branche "develop" dans la branche "master"
Dans la branche "develop"
```bash
 git merge develop
```
Dans la branche "master"
```bash
 git push origin master
```

Pour les bonne pratique, on va intégrer la notion de revue de code. Pour cela, on va créer une branche, faire des modifications, les envoyer sur le dépôt distant, puis créer une pull request pour demande une revue de code