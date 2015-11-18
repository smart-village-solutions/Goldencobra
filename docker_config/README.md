## Installationsanleitung

Um Docker mit Stash und private Github Repositories nutzen zu können, werden die ssh_key files benötigt! Kopiere dazu die id_dsa bzw. id_rsa Datei aus dem ~/.ssh/ Verzeichnis hier in das docker_config Verzeichnis.

```
cp ~/.ssh/id_* docker_config/
```

Achte darauf, dass die Dateien nicht im git landen.

```
echo "docker_config/id_*" >> .gitignore
```