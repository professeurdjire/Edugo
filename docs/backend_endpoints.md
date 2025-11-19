# Vue d’ensemble des endpoints backend

Ce fichier décrit l’état d’intégration des différents endpoints exposés par l’API Spring Boot d’EduGo. Il s’appuie sur les services disponibles dans `lib/services`.

## Endpoints déjà intégrés dans l’application

| Domaine | Fichier(s) | Endpoints consommés | Notes |
| --- | --- | --- | --- |
| Authentification & session | `lib/services/auth_service.dart` | `/api/auth/login`, `/api/auth/register`, `/api/auth/logout`, `/api/auth/refresh`, `/api/auth/me` | Configure `Dio` (base URL, JWT) et expose `testConnection()` |
| Profil élève | `lib/services/eleveService.dart` | `/api/eleve/profil/{id}`, `/api/eleve/profil/{id}` (PUT), `/api/eleve/profil/{id}/change-password`, `/api/eleve/points/{id}` | Utilise les serializers BuiltValue |
| Objectifs de lecture | `lib/services/objectifService.dart` | `/api/eleve/{eleveId}/objectifs` (GET/POST/DELETE), `/api/eleve/{eleveId}/objectifs/en-cours`, `/api/eleve/{eleveId}/objectifs/historique` | Payloads typés `ObjectifRequest/ObjectifResponse` |
| Bibliothèque & fichiers | `lib/services/livre_service.dart`, `lib/services/book_file_service.dart` | `/api/livres`, `/api/livres/{id}`, `/api/livres/{id}/fichiers`, `/api/livres/fichiers/{fileId}/download`, `/api/livres/classe/{classeId}`, `/api/livres/matiere/{matiereId}`, `/api/livres/niveau/{niveauId}`, `/api/livres/disponibles/{eleveId}`, `/api/livres/populaires`, `/api/livres/recents`, `/api/livres/recommandes/{eleveId}`, `/api/livres/progression/{eleveId}`, `/api/livres/progression/{eleveId}/{livreId}`, `/api/livres/statistiques/{livreId}`, `/api/livres/recherche/auteur`, `/api/livres/recherche/titre`, `/livres/progression/{eleveId}/{livreId}` | Gère aussi la normalisation des URLs d’images de couverture |
| Assistant IA | `lib/services/assistant_service.dart` | `/api/ia/chat`, `/api/ia/chat/sessions` | Historique et envoi de messages |
| Défis | `lib/services/defi_service.dart` | via `DfisApi`: `getDefisDisponibles1`, `getDefisParticipes1`, `getDefiById`, `participerDefi1`, `getAllDefis` | Utilise l’API générée avec `AuthService().dio` |
| Exercices | `lib/services/exercice_service.dart` | via `ExercicesApi`: `getAllExercices`, `getExerciceById`, `getExercicesDisponibles`, `getExercicesByMatiere1`, `getExercicesByDifficulte`, `getExercicesByLivre`, `getHistoriqueExercices`, `getExerciceRealise`, `searchExercicesByTitre` | La soumission (`soumettreExercice`) reste à finaliser |
| Structure scolaire | `lib/services/schoolService.dart` | `/api/niveaux`, `/api/classes/niveau/{niveauId}` | Utilisé lors de l’inscription |
| Suggestions (partiel) | `lib/services/suggestionService.dart` | Endpoint encore à définir | La route est vide pour le moment → à brancher |

## Endpoints disponibles mais non branchés dans l’UI

Les fichiers générés dans `lib/services/api/` exposent encore plusieurs domaines qui ne sont pas consommés par les écrans actuels :

- `administration_api.dart` – gestion avancée côté admin.
- `authentification_api.dart` – alternative générée à `AuthService`.
- `badges_api.dart` – CRUD badges et attribution.
- `challenges_api.dart` – endpoints supplémentaires (classements, statistiques).
- `classes_api.dart`, `niveaux_api.dart`, `matires_api.dart` – disponibles via API générée mais non utilisés directement (nous consommons aujourd’hui des endpoints manuels via `SchoolService`).
- `lve_api.dart` – endpoints liés à la lecture à voix haute (non exposés dans l’UI actuelle).

## Prochaines étapes proposées

1. **Compléter les services partiels**  
   - Renseigner l’URL dans `SuggestionService.envoyerSuggestion`.  
   - Finaliser `ExerciceService.soumettreExercice` avec le modèle `ExerciceSubmissionRequest`.  
   - Ajouter un service pour consommer `badges_api.dart` (affichage et progression des badges).

2. **Centraliser l’accès aux APIs générées**  
   - Créer un singleton `Openapi` initialisé avec `AuthService().dio` pour partager les mêmes interceptors JWT.  
   - Exposer les instances `BadgesApi`, `ChallengesApi`, `AdministrationApi`, etc. via un repository commun.

3. **Tracer l’usage dans l’UI**  
   - Documenter dans chaque écran les services/endpoint utilisés afin de garantir la couverture fonctionnelle avant les phases de test.

Cette cartographie sera mise à jour au fur et à mesure que de nouveaux écrans consommeront les endpoints restants.

