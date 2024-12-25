# Documentation

## Initialisation du dépôt

```bash
 git init
 git remote add origin https://github.com/Zecomodore/projetsurmandat_groupe07.git
```

## Rédiger un commit

```
Titre du commit

Description de notre commit avec des informations sur l'évolution du projet
```

## Envoyer un commit sur le dépôt distant
```bash
 git add . // git add README.md test.md ...
 git status
 git commit
 git push origin master
```

## Envoyer un commit sur le dépôt distant
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