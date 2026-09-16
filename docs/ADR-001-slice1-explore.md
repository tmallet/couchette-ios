# ADR-001 — Slice 1 Couchette : Explore carte + fiche cabine + CTA

- **Statut** : Accepté (stack figée ThiMal)
- **Date** : 2026-09-16
- **Auteur** : Campos (Architecte)
- **Contexte** : Slice 1 avant implémentation Dembélé
- **Décideurs** : ThiMal (stack), Luis (scope), Campos (archi)

## Contexte

Couchette Slice 1 : explorer les trains de nuit FR / Benelux / DE (Nightjet + European Sleeper), ouvrir une fiche cabine, puis un CTA qui ouvre de **vraies URLs** de réservation (grille smoke).

Stack figée :
- **SwiftUI iOS natif** (pas React Native)
- Composants Apple max : Liquid Glass, `TabView`, `NavigationStack`, `MapKit` si pertinent, SF Symbols

## Décision

### 1. Modules (cibles Xcode)

| Module | Responsabilité | Dépendances |
|--------|----------------|-------------|
| `App` | Composition root, scène, injection légère | FeatureExplore |
| `FeatureExplore` | Carte, liste/pins, fiche cabine, CTA | Domain, DesignSystem |
| `Domain` | Modèles purs (`Operator`, `Route`, `Cabin`, `BookingCTA`), pas d’UI | — |
| `Data` | `ExploreRepository` (protocole) + `MockExploreRepository` Slice 1 | Domain |
| `DesignSystem` | Tokens, styles Liquid Glass, composants réutilisables | — |

Pas de couche réseau réelle en Slice 1. Le protocole `ExploreRepository` reste le point d’extension pour une API plus tard.

### 2. Data : mock vs API

**Slice 1 = 100 % mock local** (JSON ou structs Swift seedés dans `Data`).

Raisons :
- Smoke UI sans backend
- Contrôle total des pins carte et des URLs CTA
- Zéro risque de casse si les sites opérateurs changent leur HTML

Contrat du mock (grille smoke minimale) :

| Opérateur | Routes couvertes (ex.) | URL CTA de base |
|-----------|------------------------|-----------------|
| Nightjet | Axes FR / Benelux / DE typiques Nightjet | `https://www.nightjet.com/en/ticket-buchen` |
| European Sleeper | Paris–Berlin, Brussels–Prague, Brussels–Milan (réseau ES) | `https://www.europeansleeper.eu/` |

Chaque `Cabin` expose un `bookingURL: URL` **absolu https** (pas de deep link custom app en S1). Optionnel : query `utm_source=couchette` pour tracer le smoke.

**Hors scope S1** : auth, paiement in-app, scraping, deep links `couchette://`, sync offline.

Évolution prévue : `LiveExploreRepository` derrière le même protocole ; bascule via flag / composition root, sans toucher `FeatureExplore`.

### 3. Navigation

```
TabView
 └─ Tab « Explorer » (SF Symbol map)
      └─ NavigationStack
           ├─ ExploreMapView          // MapKit + annotations
           └─ navigationDestination → CabinDetailView
```

- Une seule tab fonctionnelle en S1 (les autres tabs peuvent être placeholders non branchés).
- Sélection pin / row → push `CabinDetailView` via `NavigationPath` ou `navigationDestination(for: Cabin.ID.self)`.
- Retour natif `NavigationStack` ; pas de coordinator custom.
- Liquid Glass sur chrome tab / bar quand dispo (iOS 26+), fallback system materials sinon.

`MapKit` :
- Région initiale centrée Europe de l’Ouest (FR / Benelux / DE).
- Annotations = points d’intérêt route / hub (pas le tracé ferroviaire complet en S1).
- Tap annotation → même destination que la liste (fiche cabine).

### 4. Deep-link / CTA externe

S1 = **sortie navigateur**, pas d’Universal Links entrants.

Pattern retenu :

```swift
// CabinDetailView — CTA primaire
Link(destination: cabin.bookingURL) { … }
// ou
openURL(cabin.bookingURL)  // via Environment(\.openURL)
```

| Option | Choix S1 | Pourquoi |
|--------|----------|----------|
| `SFSafariViewController` / `SafariView` | **Non (défaut)** | Le booking est multi-étapes ; Safari app = meilleur cookie / password autofill |
| `openURL` / `Link` | **Oui** | Ouvre Safari (ou navigateur défaut) avec l’URL réelle |
| `WKWebView` in-app | Non | Complexité + auth opérateurs |

Exception documentée : si produit exige « rester dans l’app » plus tard → wrapper `SafariView` (SFSafariViewController) **sans** changer le modèle `bookingURL`.

Validation smoke :
1. Chaque CTA de la grille mock ouvre bien l’URL https attendue.
2. Nightjet → page ticket ; European Sleeper → site / book.
3. Échec réseau / URL invalide → alerte native simple (pas de retry fancy).

### 5. Modèle domaine (minimal)

```text
Operator   { id, name, brandSymbol }           // nightjet | europeanSleeper
Route      { id, operatorId, title, cities[], coordinate }
Cabin      { id, routeId, title, summary, amenities[], bookingURL }
```

`FeatureExplore` ne parle qu’à `ExploreRepository` ; pas d’URL hardcodées dans les vues.

## Conséquences

**Positif**
- Dembélé peut coder UI + navigation sans attendre d’API
- Stack 100 % Apple, alignée décision ThiMal
- Remplacement mock → live sans refactor feature

**Négatif / dette acceptée**
- Données figées (maj manuelle du seed)
- Pas de deep link entrant ni attribution fine
- Map = hubs, pas polylines ferroviaires

**Non-goals S1**
- RN, multi-plateforme, backend Couchette, login, push

## Go pour Dembélé

Implémenter dans l’ordre :
1. `Domain` + seed mock (`Data`)
2. `ExploreMapView` + annotations
3. `CabinDetailView` + CTA `openURL` / `Link`
4. Grille smoke manuelle sur device / simu (toutes les URLs de la grille)

Bloquants à remonter à Luis (puis ThiMal) : changement de stack, besoin SafariView in-app, ou API live avant fin S1.
