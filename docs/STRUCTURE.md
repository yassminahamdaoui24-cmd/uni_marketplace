# Guide de structure du code : Uni Marketplace

## Les couches (dans lib/)

| Dossier         | Contenu                                                                                                 |
| --------------- | ------------------------------------------------------------------------------------------------------- |
| `data/`         | modèles (`models/`), accès Firebase (`datasources/`), implémentation des repositories (`repositories/`) |
| `domain/`       | entités (`entities/`), interfaces des repositories (`repositories/`), règles métier                     |
| `presentation/` | pages (`pages/`), widgets (`widgets/`), gestion d'état (`state/`)                                       |
| `core/`         | éléments partagés : thème (`theme/`), constantes (`constants/`), utilitaires (`utils/`)                 |
| `main.dart`     | démarrage de l'application                                                                              |

## Où placer un nouveau fichier ?

- Nouvelle page : `presentation/pages/`
- Widget réutilisable : `presentation/widgets/`
- Service Firebase (Auth, Firestore, Storage) : `data/datasources/`
- Modèle de données (conversion Firestore) : `data/models/`
- Entité métier (Utilisateur, Annonce, Favori) : `domain/entities/`
- Couleurs, thème, constantes : `core/`

## Règle de dépendance

`presentation` utilise `domain`, `data` implémente `domain`. Le dossier `domain/` n'importe rien de `data/` ni de `presentation/`.

## Conventions de nommage

- Fichiers : `snake_case` avec suffixe (`login_page.dart`, `user_model.dart`, `user_entity.dart`, `auth_repository.dart`)
- Classes : `PascalCase` (`LoginPage`, `UserModel`)
- Variables et fonctions : `camelCase` (`userName`, `fetchListings()`)
- Constantes : `camelCase` dans une classe dédiée (`AppColors.primary`)

## État de la migration

| Ancien dossier   | Nouveau dossier         | État                                 |
| ---------------- | ----------------------- | ------------------------------------ |
| `screens/`       | `presentation/pages/`   | fait                                 |
| `models/`        | `data/models/`          | fait                                 |
| `services/`      | `data/datasources/`     | fait (ancien dossier supprimé, vide) |
| `widgets/`       | `presentation/widgets/` | à faire (Yasmine)                    |
| `app_theme.dart` | `core/theme/`           | à faire (Yasmine)                    |
