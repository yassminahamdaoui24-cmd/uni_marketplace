# Guide de structure du code : Uni Marketplace

## Les couches (dans lib/)
| Dossier | Contenu |
|---|---|
| `data/` | modèles (`models/`), accès Firebase (`datasources/`), implémentation des repositories (`repositories/`) |
| `domain/` | entités (`entities/`), interfaces des repositories (`repositories/`), règles métier |
| `presentation/` | pages (`pages/`), widgets (`widgets/`), gestion d'état (`state/`) |
| `core/` | éléments partagés : thème (`theme/`), constantes (`constants/`), utilitaires (`utils/`) |
| `main.dart` | démarrage de l'application |

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

## Migration des dossiers existants (à décider en équipe)
| Actuel | Futur |
|---|---|
| `screens/` | `presentation/pages/` |
| `widgets/` | `presentation/widgets/` |
| `app_theme.dart` | `core/theme/` |
| `models/` | `data/models/` |
| `services/` | `data/datasources/` |

Aucun fichier existant n'est déplacé sans l'accord de toute l'équipe, pour éviter les conflits Git.
