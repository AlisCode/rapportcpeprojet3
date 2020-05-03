---
author: 
    - Olivier Pinon - 4IRC - Promotion 2017/2020 
    - \newline Grégory Obanos - Maître d'apprentissage 
    - \newline Marion Foare - Tutrice école
date: Année universitaire 2018/2019
title: Conception et implémentation d'une suite d'outils géospatiaux 3D
subtitle: Designing and implementing a 3D geospatial toolchain
caption: Projet 2 - Informatique et Réseaux de Communication 
lang: "fr-FR"
keywords: [3D, OSM, Geospatial, Rust, WebGL]
titlepage: true
logo: img/LogoAll.png
logo-width: 350
confidential: Rapport confidentiel 
bibliography: biblio.bib
header-left: ITII
fontsize: 10pt
header-center: Asylum
header-right: CPE Lyon
footer-left: Olivier PINON - 4IRC
toc: true
abstract: Au cours de cette deuxième année d'alternance, j'ai travaillé pour la société Asylum, SARL Lyonnaise spécialisée dans les solutions 3D pour l'architecture, l'immobilier et la construction. Dans l'objectif de rendre ses produits plus complets et d'apporter une meilleure intégration d'une maquette 3D, le projet qui m'a été assigné était de designer et développer une solution complète permettant la génération d'un environnement 3D (bâtiments et hauteur de terrain). Le présent rapport d'activité a pour but de décrire la phase d'analyse, de conception et d'implémentation d'un outil complexe, mêlant à la fois une suite d'outils géo-spatiaux, une application Web et un serveur suivant une architecture orientée service, développé avec le langage Rust.  
---

\newpage

**Remerciements**     

Dans un premier temps, j'adresse mes remerciements tout particuliers à Monsieur Grégory OBANOS, mon maître d'apprentissage, pour sa confiance, son écoute, son suivi et son investissement durant ces deux premières années d'alternance. Ses conseils, sa réactivité et son expérience font de lui le soutien idéal à ma progression au sein du monde de l'entreprise.

\ 

Je souhaite remercier Messieurs Arnaud THOMAS et Christophe BERTRAND pour leur confiance lors des derniers mois, et l'attention portée à mes travaux.   

\ 

Je remercie Madame Clotilde VIVANT pour son soutien, ses conseils, l'organigramme de la société et la relecture de mon rapport.   

\ 

Finalement, je tiens à remercier l'ensemble de mes collègues chez Asylum, cette équipe jeune et dynamique qui a su m'intégrer malgré nos travaux différents, et qui contribue à mon bien-être au sein de l'entreprise. Travailler à leurs côtés est à la fois un plaisir et une experience très enrichissante sur le plan professionel.

\newpage

# Trivia

## Société Asylum

### Présentation générale 

Asylum est une SARL Lyonnaise dont le siège social est situé à Lyon 07, fondée en 1995 par Christophe BERTRAND. Sur l'année 2018, l'entreprise de 40 salariés totalise un chiffre d'affaires de 2 500 000€ sur son unique site de Lyon.

L'entreprise commercialise des solutions 3D pour l'architecture, l'immobilier et la construction. Ces produits prennent la forme d'images et de vidéos de synthèse, ainsi que d'applications 3D multi-plateformes. 

> Pour l'exemple, quelques réalisations de l'agence sont disponibles en annexe.

![Logo de l'entreprise Asylum](img/LogoAsylum.png){width="50%"}

La société Asylum est associée à une autre entreprise, Virtual Building, qui complète son activité par des solutions d'intégration Web autour des mêmes thématiques de 3D.   

### Organisation interne 

Asylum s’appuie sur quatre services : le commerce, la production, le support technique et la R&D, l’administratif/RH/finance. La production est elle-même composée de quatre pôles, un pour chaque typologie de client : cette organisation permet aux graphistes de se spécialiser et d’en maîtriser les spécificités, et donne à l'entreprise une présence large et polyvalente sur le marché.

Chaque pôle est constitué d'un chef de projet et de plusieurs artistes, spécialisés soit :   

* Dans la retouche 2D avec Photoshop, 
* Dans la modélisation 3D de précision (modèles très détaillés), 
* Dans la modélisation 3D temps-réel (modèles simplifiés et travail plus important sur les textures)

Le travail effectué a été exercé au sein du pôle Recherche et Développement. Bien qu'ayant subi quelques modifications de structure récemment à cause des restrictions d'effectif, il contenait auparavant tous les développeurs de l'entreprise, le responsable du pôle Recherche (mon maître d'apprentissage), et le directeur technique.

> L'organigramme de la société est disponible en annexe  

# Contextualisation du projet 

## Asylum Infinity3D 

Asylum Infinity3D est la solution de commercialisation ciblée principalement sur le marché de l'immobilier.

Il s’agit de la solution développée durant ma première année d’alternance, et dont le pôle R&D a eu la charge de développement et de mise en production. Ce produit se présente sous la forme d'une solution générique à l'interface unifiée, composée de plusieurs modules mettant toutes en valeur un projet immobilier de façon différentes : 


* Module localisation : situer le projet dans son environnement (commerces, transports, ...)
* Module logement : présenter les caractéristiques diverses des différents logements du projet
*  Module chantier : présenter l'avancement du chantier d'un projet immobilier 
* Module visite immersive / appartement témoin : présenter chaque logement comme une visite d'appartement classique 
* Module maquette : présenter le projet en vue éclatée

L'application est utilisable sur toutes les plateformes :   

* Web avec VueJS
* Desktop et mobile avec Unity  

Le développement de ce produit ayant été traîté dans le premier rapport, il ne sera pas détaillé ici. La figure suivante est un screenshot de l'application afin de présenter le contexte du projet.  

\

![Application Web Infinity3D](img/ScreenInfinityWeb.png){width="100%"}

\

## Asylum District3D

Asylum District3D est une solution pour la présentation et la promotion des territoires et des projets urbains. 

L'outil se présente sous la forme d'une maquette 3D temps réel présentant le projet au milieu d'un environnement simplifié. Un exemple d'application District3D est donné dans la figure suivante. 

![Exemple d'application District3D](img/ScreenD3D.png){width=90%}

Le développement et la mise en production de cet outil remontent à 2014. Il existe un processus permettant de mettre à jour les données de l'application. Ainsi, une application mise en production et déjà présente chez le client peut être mise à jour sans nécessiter de réinstallation.   

Ce projet dépend actuellement d'une technologie de Microsoft nommée `CesiumJS` pour la version Web de l'environnement urbain. C'est un moteur utilisant les données de Bing Maps permettant de visualiser un environnement 3D.   

## Problématique d'environnement 3D

Le projet de la seconde année correspond à la création d'une suite d'outils permettants la génération d'un environnement complet en 3D, s'appuyant sur des données open-source.

L'enjeu d'un tel projet est de permettre à l'entreprise de s'affranchir du coup de la licence `CesiumJS`, sujet à fluctuations et à la politique d'utilisation imposée par Microsoft. Cela permettrait également de compléter l'offre des applications actuelles en proposant une meilleure contextualisation urbaine du projet mis en valeur.

De plus, la création d'un outil personnalisé permet d'en gérer complètement le format de sortie. Il sera ainsi possible d'utiliser ces fichiers dans différents projets tels que des films ou des applications personnalisées, voire de les commercialiser directement.

L'environnement produit par ces outils contiendra :  

* Des bâtiments en boîte blanche 
* Une représentation topographique
* Des extras divers (arbres uniquement pour le moment)

En plus de la chaîne d'outils nécéssaires à la génération de ces géométries 3D, il s'agira de rendre leur utilisation possible par un chef de projet via un outil interne (une application Web couplée à un web-service, en l'occurence). 

# Spécification du projet

## Schéma général de la solution

La solution proposée s'articule autour des modèles qui sont affichés dans le moteur. Ces modèles sont produits par la suite d'outils géospatiaux. Les commandes sont lancées par un utilisateur par le biais de l'application Web et du webservice, qui servent d'interface finale. 

La solution se présente sous la forme suivante :

```{.svgbob width="70%"}
                        +------------------+
                     +->|  Modèles villes  |-------+
+-----------------+  |  +------------------+       |
| Outils internes |--+                             |
+-----------------+  |  +-------------------+      |               +--------------------+
        ^            +->|  Modèles terrain  |------+-------------->| Moteur d'affichage |
        |            |  +-------------------+      | Utilisation   |  (Unity3D, WebGL)  |
+-----------------+  |                             |               +--------------------+
| Application web |  |                             |
| + backend       |  |                             |
+-----------------+  |  +------------------+       |
                     +->|  Modèles extras  |-------+
                        +------------------+

```

La suite d'outils géospatiaux permettant de générer les géometries est elle-même divisée en 5 outils, dans la but de séparer les responsabilités au maximum, dans le respect de la *philosophie Unix* où chaque outil a la responsabilité de **faire une chose, et la faire bien**.

Chaque outil sera détaillé par la suite. La figure suivante le schéma explicatif de l'architecture de la suite d'outils internes et du dialogue entre outils.  

```{.svgbob name="Architecture des outils internes" width="45%"}

+-----------------------------------------------------+
|                                                     |
| +---------------+          +----------------+       |
| | hgt - cleaner |          | osm - to - obj |       |
| +---------------+          +----------------+       |
|         |                       |                   |
|         v                       |                   |
| +----------------+              |                   |
| | hgt - to - obj |              |                   |
| +----------------+              |                   |
|         |                       |                   |
|         v                       v                   |
| +--------------------------+  +-------------------+ |
| | osm - tiles - downloader |->| infos - generator | |
| +--------------------------+  +-------------------+ |
|                                                     |
+-----------------------------------------------------+
        |
        v
    +-----------------+  _          
    | Base de données | |=|         
    +-----------------+ |_|
                        

```

La responsabilité de chacun des programmes est décrite ici : 

* `hgt-cleaner` permet de "nettoyer" les données d'altitude
* `hgt-to-obj` utilise les données d'altitude pour générer les modèles topographiques
* `osm-tiles-downloader` télécharge les textures à appliquer sur le sol
* `osm-to-obj` génère les modèles 3D des bâtiments à partir des données cartographiques OSM[^osm]
* `infos-generator` génère une donnée au format JSON pour standardiser l'entrée dans les différents moteurs

[^osm]: OpenStreetMap, données cartographiques sous licence libre.

Ayant eu carte blanche au niveau des outils pour l'implémentation du système. Le choix de technologie utilisée s'est porté sur le langage de programmation Rust. 

![Logo du langage Rust](img/LogoRust.png){width=25%}

Rust est un langage de programmation système axé sur 3 points principaux [@rustbook] :  

- Performance: il n'y a pas de garbage collector[^gc] et les performances sont proches voire supérieures à celles de C. 
- Sécurité: le langage garantit qu'il n'y aura pas de comportement indéfini ni d'`use-after-free`[^uaf], et bénéficie d'un système de typage fort. Le seul moyen d'avoir un logiciel qui plante est une panique (division par zéro, accès à une ressource nulle, ...), qui ne devrait jamais arriver en production.
- Productivité: La documentaion, les outils et l'environnement de travail sont matures et performants.

[^uaf]: Utilisation après destruction, problème de sécurité d'une application qui utilise un segment de mémoire après l'avoir désalloué, amenant à une erreur d'exécution de type `segfault`.

[^gc]: Garbage collector, collecteur de mémoire morte utilisé pour recycler la mémoire au sein d'un programme après que son utilisation soit terminée.

Ce langage est le sujet principal de la veille technologique du pôle R&D, et c'est certainement une des technologies dont le développement va s'accentuer dans les années à venir car le langage répond à plusieurs besoins (évoqués précédemment) dont l'industrie du logiciel ne peut se passer.

## Méthode de travail et gestion de projet

Tout au long du projet, une planification basée sur les objectifs a été mise en place par l'équipe. Un tableau Trello répertoriant les différentes tâches a été mis en place. Celui-ci permet de savoir ce qu'il reste à faire et d'estimer la durée de ces tâches en fonction de leur difficulté.  

> Un screenshot du tableau Trello montrant l'outil utilisé pour le jalonnement des tâches est disponible en annexe.

Si aucune méthode agile précise de type Scrum ou XP - standard de la gestion de projet dans l'industrie - n'a été appliquée, l'application des principes agile a été respectée de sorte que le besoin auquel le projet répond puisse être légèrement redéfini durant son élaboration, principalement au lancement du projet en juillet dernier.

On trouve notamment le principe de sprints d'une durée approximative d'un mois, ainsi que les réunions de comité de pilotage du projet, composé de :  

- Christophe Bertrand, **product owner**
- Grégory Obanos, **manager**
- Olivier Pinon, **lead technique**, développeur, testeur

Le tableau Trello tient le rôle à la fois de roadmap, backlog de produit et backlog de sprint.

## Outils de traitements géospatiaux
### Coords

La librairie de coordonnées est un outil permettant de standardiser au sein des outils la gestion de coordonnées GPS, leurs projections, et leur utilisation au sein des applications.

Dans une application de traitement de données géospatiales, il est commun de découper les zones géographiques par tuiles. Chaque tuile est identifiée par ses coordonées X et Y (sur un plan 2D, donc), ainsi que par son niveau de zoom. 

Le niveau de zoom est un entier dont valeur minimale est de 0 (pour l'échelle de la planète), puis chaque tuile est décomposée en 4 tuiles de niveau supérieur, de la façon suivante : 

```{.svgbob width="50%"} 

Tuile 1             4x Tuile 2

(zoom n)            (zoom n + 1)

+-------+           +---+---+
|       |           |   |   |
|       | ------->  +---+---+
|       |           |   |   |
+-------+           +---+---+


```

Le niveau de zoom maximum (conventionel) est de 19. Pour donner une représentation plus compréhensible, le tableau suivant associe un niveau de zoom à un exemple de zone représentable : 

| Niveau de zoom | Nombre de tuiles | Zone géographique   |
| -------------- | ---------------- | ------------------- |
| 0              | 1                | Planète             |
| 2              | 16               | Continent           |
| 3              | 64               | Pays très grand     |
| 6              | 4096             | Grand pays européen |
| 8              | 1406             | Petit pays européen |
| 10             | 1 408 576        | Métropole (Paris)   |
| 11             | 4 194 304        | Ville     (Lyon)    |
| 13             | 67 108 864       | Village             |
| 16             | 4 294 967 269    | Rue                 |
| 19             | 274 877 906 944  | Petite résidence    |  |

Le but des outils de traitement sera donc de sortir des tuiles affichables selon le niveau de zoom donné aux outils.

Le système de typage fort du langage `Rust` permet de typer les données de Latitude et de Longitude. Cette particularité permet d'éviter la confusion, puisqu'il est possible de savoir *à posteriori* si on parle de Longitude ou de Latitude dans nos calculs. Au sein de la librairie de coordonnées, la précision double appelée `f64` en Rust, est utilisée sur les nombres flottants pour leur propriété de précision optimale.

Chaque tuile peut être représentée comme une zone rectangulaire appelée `bounds` (pour "boîte englobante"). Les formules de collisions et des contenances de points sont triviales : 

```{.svgbob width="20%"}
y

^         w               
|     <--------->       
|   ^ +---------+ 
|   | |         |    
| h | |       x |  o
|   | |         | 
|   v +---------+ 
|     ( x,y )
|
+-------------------> x
```

Un point **n'est pas contenu** dans une tuile T si et seulement si : 

- $X_p < X_b$, ou
- $X_p > X_b + w$, ou
- $Y_p < Y_b$, ou
- $Y_p > Y_b + h$, ou

avec `p` le point, `b` la boîte englobante de la tuile T, `w` et `h` respectivement la longueur et la hauteur de la boîte englobante de la tuile T. Dans **tout autre cas**, le point est contenu.

S'agissant d'une application géospatiale, des problématiques liées à la projection sont inévitables. D'une manière générale, les sources de données utilisent toutes la projection `WGS84`, référentiel habituel des latitudes et longitudes GPS. Cependant, afin de pouvoir être affichées dans les moteurs 3D, les géométries doivent être projetées sur un plan 2D, puis 3D. La méthode de projection WebMercator développé par Google est alors utilisée puisqu'il s'agit d'un standard sur les technologies de ce type. Un exemple est montré ci-contre: 

![Projection WebMercator - slideplayer.com](img/webmercator.jpg){width="35%"}

Cette méthode, bien que très inexacte car projetée à l'infini aux pôles (*e.g. le Groenland fait la taille de l'Afrique*), est utilisée sur la majorité des systèmes de cartographies modernes et rend le résultat des outils intégrables au sein d'autres systèmes. 

### SRTM + HGT-cleaner

Afin de gérer la création des géometries de topographie, il faut tout d'abord bénéficier d'une source de données utilisables qui permette d'avoir des informations sur l'altitude. 

Après recherche, l'utilisation des données de la mission SRTM[^srtm] en version 3 est la solution la plus simple. Ces données ont été mises en libre service par la NASA et se présentent sur la forme de fichiers `.hgt`. 

Le format est décrit comme `un format de fichier brut`, qui `contient les données directement sous forme d'entier signés codés sur 16 bits`. Les données sont échantillonnées sur trois arc-secondes, soit avec une précision d'un point tous les 90 mètres environ (pour des latitudes similaires à la France). Elles contiennent 1201x1201 points par degré de latitude/longitude. Les données SRTMv3 sont dérivées des données SRTMv1, et ont été obtenues par une passe d'un filtre moyenneur 3x3 sur des données échantillonnées sur un arc-seconde. Puisque le plus gros facteur d'erreur est le bruit présent sur les données, les données SRTMv3 permettent une meilleure approximation. 

Ces fichiers suivent une nomenclature précise, de la forme suivante : 

* Point cardinal E (Est) ou W (Ouest) 
* Longitude GPS sur au moins deux nombres
* Point cardinal N (Nord) ou S (Sud)
* Latitude GPS sur au moins deux nombres

Par exemple, un fichier s'appelant `E01N01.hgt` contient les données d'altitude des coordonnées GPS (1,1) à (2,2) inclusif. 

Malheureusement, les fichiers contiennent des erreurs de mesure, dues notamment à l'altitude, aux nuages, aux ombres et autres phénomènes ayant eu lieu le jour de la mesure. Ces erreurs sont connues car elles ont des valeurs aberrantes par rapport aux autres données locales ; elles sont donc marquées explicitement fausses. Par convention, l'altitude est alors égale à la valeur minimale d'un `i16`[^i16], soit -32768. 

Pour solutionner ce problème, un outil de correction appelé `hgt-cleaner` a été écrit. L'unique but
de ce programme est de prendre un fichier `.hgt` en entrée et de rendre un fichier `.hgt` en sortie, dont les valeurs aberrantes ont été effacées par un filtre de correction paramétrable. 

Puisque les erreurs de mesures sont généralement très proches géographiquement, un filtre moyenneur s'est avéré inefficace voire contre-performant pour la correction de bruit. Il a donc été préféré d'effectuer une autre correction : l'estimation d'une valeur par échantillonage de valeurs voisines. 

Prenant les valeurs dans un périmètre défini soit par la distance hamiltonienne, soit par la distance réelle, il s'agit effectuer la moyenne de ces valeurs en évitant de prendre en compte les valeurs notées comme aberrantes. Ce filtre moyenneur modifié s'est avéré nettement plus performant.  

La figure suivante montre les deux types de filtres appliquables, en définissant la distance hamiltonienne et la distance réelle pour une filtre 3x3

```{.svgbob width="50%"}

  Hamiltonienne               Réelle 
. . . . . . . . .       . . . . . . . . .
. . . . • . . . .       . • • • • • • • .
. . . • . • . . .       . • . . . . . • .
. . • . . . • . .       . • . . . . . • .
. • . . x . . • .       . • . . x . . • .
. . • . . . • . .       . • . . . . . • .
. . . • . • . . .       . • . . . . . • .
. . . . • . . . .       . • • • • • • • .
. . . . . . . . .       . . . . . . . . .  

x case cible
• valeur selectionnée
. valeur ignorée

```

La figure suivante est une représentation graphique d'un fichier `.hgt` avant et après son traitement par l'outil `hgt-cleaner`. Les valeurs sont normalisées de la plus petite à la plus grande altitude. 

![Traitement d'erreur dans les fichiers HGT. Avant (gauche) / Après (droite)](img/hgt-cleaner.png)

[^srtm]: Shuttle Radar Topography Mission, mission de la Nasa pour cartographier la planète durant les années 2000 
[^i16]: Aussi appelé shortint, diminutif pour entier signé codé sur 16 bits

Un groupe de 1201 par 1201 points de données d'altitude aux valeurs cohérentes est ainsi obtenu. Cependant, cela n'est pas suffisant. En effet, le fait d'avoir des valeurs discrètes ne permet pas d'obtenir une estimation correcte pour n'importe quelle coordonnée. Si sur un degré de longitude on a 1201 points, cela donne une valeur exacte pour toutes les coordonnées divisibles par `1/1201`. Cependant, il faut pouvoir estimer une altitude de façon continue afin de générer des modèles 3D exploitables. 

Pour ce faire, la première approche a été l'utilisation dU produit en croix. Cette technique ayant fourni des résultats inutilisables, la seconde piste a été l'approximation entre 4 points, en faisant une moyenne des hauteurs des points voisins, en se servant des distances du point voulu aux voisins connus pour pondérer le calcul de la monyenne. Cette technique a eu pour effet de donner un résultat particulier: des sortes de "plateaux" rendant le modèle inexploitable également. 

La solution choisie est donc une interpolation à base de `Spline`s. Chaque point, défini par ses coordonnées GPS, est entouré de points dont la mesure est connue et supposée exacte, comme dans le schéma suivant : 

```{.svgbob width="30%"}

.   .   .   .   .               
.   .   .   .   .               
.   .   x   .   .               
.   .   .   .   .               
.   .   .   .   .               

x point cible
. coordonnées connues 

```

Pour effectuer l'interpolation, il s'agit de prendre les K valeurs connues autour du point sur l'axe Y, où K est défini comme la précision voulue, et d'approximer une Spline grâce à ces valeurs d'altitude. L'utilisation de l'interpolation cosinusoïdale ou de Catmull-Rom selon la taille de l'échantillon, permet de calculer une valeur approximée selon celles connues, et définie de manière continue. 
 
### HGT-to-OBJ

Grâce aux librairies SRTM et Coords, ainsi que de l'outil `hgt-cleaner`, une source de données de hauteur utilisables et approximée de manière continue est obtenue. 

Il faut désormais générer les modèles topographiques 3D pour donner des tuiles de terrain (sol), sur lesquelles seront ensuite placées les tuiles de bâtiments que générées par la suite ; c'est le rôle d'`hgt-to-obj`. 

La première version de l'outil a été développée grâce à une librairie maintenue par le groupe de travail de l'équipe Rust en charge des graphismes sur ordinateur - l'organisation `gfx-rs` - à savoir `genmesh`. 

Cette librairie a pour but de fournir des design pattern Builder sur des primitives 3D comme :   

* Cubes 
* Rectangles
* Sphères
* Plans

Chaque primitive générée par `genmesh` est paramétrable, et fournit un itérateur pour obtenir un accès mutable sur chaque sommet. Grâce au système de tuiles vu précédemment, il est possible de générer un plan 3D par tuile. Utilisant ensuite l'`ElevationProvider` précédemment créé pour associer un sommet à son altitude, un modèle de terrain utilisable est ainsi généré. 

Bien que cette solution donne des résultats exploitables, avec une vitesse de production très raisonnable (~20 secondes pour générer les tuiles de terrain sur la ville de Lyon), elle pose un dernier problème. En effet, le projet 3D mis en valeur par son environnement doit être intégrable dans ce dernier. Il s'agit donc de pouvoir découper des trous dans certaines tuiles, de la forme du projet, afin de pouvoir l'y intégrer.

La solution finale adoptée pour le projet sera développée dans la partie sur le traitement des difficultés.

### OSM-to-OBJ

`osm-to-obj` est l'outil qui permet la création des tuiles de bâtiment et d'extras. L'appel à cet outil génère donc les deux tuiles pour chaque coordonnées X et Y. Sur chaque tuile, les coordonées X et Z des objets 3D doivent être comprises dans l'intervalle [0;256]. Une mise à l'échelle est alors appliquée pour transformer des coordonnées en unités réelles (mètres)[^cf41]. De plus, chaque géometrie générée doit être placée à sa hauteur suivant les informations de terrain générées précédemment.

[^cf41]: Se référer à la partie 4.1 "Scaling du projet".

Cet outil est basé sur la librairie Coords pour la projection, ainsi que sur l'outil SRTM pour la hauteur des bâtiments. 

Afin de générer les géométries de bâtiments, il faut tout d'abord une source de données cartographiques donnant les informations nécéssaires. Les données cartographiques open-source d'OpenStreetMap sont donc tout indiquées. 

Ces données sont téléchargeables sur le site d'OpenStreetMap ou via des serveurs externes, comme l'API Overpass par exemple. Elles prennent la forme d'un fichier XML, qu'il faut donc traiter dans un premier temps. Il existe sur crates.io[^crates] une librairie pour traiter ces données (`osm-xml`), mais les tests initiaux ont montré des performances plutôt médiocres à cause du parsing du fichier XML. Il existe deux façons de traiter un tel fichier : 

[^crates]: crates.io est un dépôt de librairie Rust public - les librairies en Rust s'appellent des crates (caisses) et sont gérées par le gestionnaire de dépendances `Cargo`.

* De manière globale - *i.e.* charger tout le contenu du document en mémoire d'un coup et retourner l'énorme (en termes d'espace mémoire) structure de données associée.
* De manière évènementielle - *i.e* lire le fichier et générer un flux de tokens XML que que l'on va traiter par la suite. 
    * `pull-parser` : le programme crée une structure `parser` et demande à celle-ci de lui donner le prochain `Token`
    * `push-parser` : le programme crée des fonctions nommées `callback` et une structure `parser`, dont le rôle sera d'appeler les callback en fonction du type d'évènement

La manière évènementielle et en particulier la méthode `pull-parser` est adaptée à ce cas d'utilisation puisqu'il est possible d'utiliser un pattern Builder - idiomatique en Rust pour la propriété de gestion des erreurs du langage - afin de générer une structure de données utilisable.  

Un fichier OSM XML est constitué de : 

* Noeuds (tags `<node>`, et `<nd>`), qui continnent les informations de latitude, longitude et visiblité. Par exemple, les bords de bâtiments sont des noeuds. 
* Ways (tags `<way>`), qui contiennent des listes de noeuds. Ceux-ci forment par exemple des routes, des chemins, des rivières, des bâtiments, ...
* Relations (tags `relation`), qui mettent en commun des `Way`, permettent de former notamment des bâtiments complexes, et servent également à définir des zones géographiques (villes, régions, pays, etc ...) 
* Tags (tags `tag`), qui définissent des métadonnées sur des relation ou des noeuds, par exemple le nom de l'élément (*e.g.* "CPE Lyon", "Mairie d'Annecy", "Tour Eiffel"), si le noeud représente un arrêt de bus, de métro, s'il s'agit d'un bâtiment historique, etc... Chaque tag a une signification particulière et tous sont définis dans le Wiki d'OSM.  

Puisque la librairie `osm-xml` est trop peu performante, le choix s'est porté sur l'utilisation d'une librairie du parsing XML évènementielle très rapide (quick-xml), et de recréer une librairie spéciale pour Asylum par dessus. Les résultats sont convaincants ; 400 Mo de données de la ville de Lyon sont traîtés en 10 secondes, contre 40 secondes avec `osm-xml`. 

Une fois les données interprétées, il faut générer les géométries : il y a besoin de définir les surfaces du bâtiment, puis de les extruder. Une solution envisageable est l'utilisation d'un Tésselateur. 

Un Tésselateur est un outil qui permet de prendre des formes complexes et de les transformer en une liste de triangles qui sont alors utilisables par des API graphiques comme `Vulkan`, `DirectX`, `Metal` ou `OpenGL`. En l'occurence, ces triangles pour vont composer un fichier de géometrie `.obj`[^obj]. Il existe un tesselateur déjà intégré, celui de la crate `Lyon`, un composant de rendu logiciel similaire à `Cairo`, mais écrite à 100% en Rust afin de profiter de la généricité, des performances et des garanties de sécurité du langage.

Pour générer la géometrie 3D à l'aide des triangles, il est impossible d'utiliser `genmesh` car cet outil ne gère que des primitives simples et pas de formes complexes (polygones). Il faut donc créer cette géométrie à la main. 

La tesselation effectuée, donne des points sur un plan 2D, et une suite d'indices sur un tableau permet d'identifier quelles faces relier ensemble afin de former des triangles. Il s'agit alors de les placer sur le plan 3D. A cet effet, l'outil SRTM présenté précédemment est tout indiqué. Chaque sommet est placé à la hauteur attribuée par l'outil. 

Il faut ensuite déterminer la hauteur du bâtiment en cours d'extrusion. OSM se sert des tags pour indiquer la hauteur de certains bâtiments. Malheureusement, la plupart des informations n'ont pas ces données de hauteur. Il faut alors la générer de manière pseudo-aléatoire, en utilisant du bruit. C'est alors que rentre en jeu les techniques de génération de bruit (ici, Perlin et OpenSimplex sont utilisés), et à chaque bâtiment est associée une valeur pseudo-aléatoire en étage, qui permet tout de même de garder une cohérence.    

Après avoir copié la surface générée vers le haut (suivant la hauteur des bâtiments), la dernière étape de la création des primitives triangulaires consiste à créer les faces de mur. En prenant les index des faces et en utilisant l'opérateur modulo pour associer chaque point à ses deux voisins sur l'autre face, on trouve les triangles nécéssaires à la création des murs. 

Pour imager cet algorithme, on prendra l'exemple d'un bâtiment composé de 4 côtés. Le résultat de la tesselation donne le résultat suivant (vu de dessus) : 


```{.svgbob width="20%"}

1    2
+----+
|\   |
| \  |
|  \ |
|   \|           
+----+
4    3

```

Les indices sont indiqués, les faces triangulées sont donc (1,3,4) et (1,2,4).  

Une fois les sommets copiés vers le haut, la figure corresond au schéma suivant (vu en perspective) : 

```{.svgbob width="15%"}

       5   6
       +---+
      /|  /|
     / | / |
  8 +--++ 7| 
    |1 ++--+ 2 
    | / | / 
    |/  |/
    +---+
   4     3

```

Il faut donc générer les faces entre les points (2,3,7,6), (5,6,7,8), (1,4,5,8), (1,2,5,6) et (3,4,7,8).

Pour chaque index dans l'intervalle `[1;4]`, deux faces sont générées grâce aux formules suivantes:

- `(i, (i+1) % n + i, (i+1) % n + n)`
- `(i, (i+1) % n + n, i + n)`

où `i` est l'index sur lequel on itère, et `n` est le nombre de sommets pré-extrusion.

Selon l'ordre dans lequel les noeuds du bâtiment sont donnés (horaire ou anti-horaire, il n'existe pas de standard dans OSM), il faut inverser les faces. Prenant le sens de rotation d'un polygone grâec à son `Winding Number`, il faut inverser le deuxième et le troisième point de chaque face selon que le polygone soit indiqué en sens horaire ou non.  

Finalement, la crate `obj-exporter` qui a pour particularité de prendre une liste de primitives (triangles) en entrée, et de gérer l'écriture du fichier `.obj` toute seule, tout en permettant de gérer les erreurs liées aux accès disques et à la nature des fichiers 3D semble être une bonne solution pour l'export.

[^obj]: Format d'objets 3D, couramment appelé `Wavefront`. Le choix du format de fichier sera détaillé dans la partie 4.3, Réduction des temps de chargement. 

Pour tester l'outil, il a été choisi de prendre des informations de bâtiments complexes. En estimant que si l'outil est capable de faire un rendu de ce type de bâtiment, il n'aura aucun problème à rendre des bâtiments simples. Le cas de test qui a été retenu est celui de la Tour de Pise (un des bâtiments qui a pour particularité d'être très bien renseigné au niveau des hauteurs).  

![La tour de pise, rendu avec l'outil OSM-to-OBJ](img/pisatower.png){width="30%"}

C'est un succès. L'outil est fonctionnel et nécessite uniquement les informations de bruit pour générer procéduralement la hauteur des bâtiments, ainsi que le fichier source OSM XML pour fonctionner. 

### OSM-tiles-downloader 

Ayant désormais généré toutes les géométries à afficher. Il faut également des textures à appliquer sur le sol, sans quoi l'environnement semblerait fade. Dans cette optique, le choix s'est posé entre créer notre propre outil de traitement qui génèrerait les textures pour les tuiles, ou utiliser les tuiles pré-construites d'OpenStreetMap, disponibles en téléchargement sur leur serveur.

La seconde solution a été préferée dans une optique de réduction du temps de développement, un outil a été créé, dont le but est de lancer le téléchargement des textures de tuiles. Pour cela, il faut simplement lancer une requête HTTP `GET` sur le site d'OpenStreetMap, en suivant la nomenclature suivante :

`https://S.tile.openstreetmap.org/ZL/X/Y.png` où :  

- $S$ est le serveur. Soit a, soit b, soit c. Ne rien mettre ici utilisera le load-balancing[^lb] automatique du serveur d'OSM
- $ZL$ est le niveau de zoom de la tuile demandée
- $X$ est la coordonnée X de la tuile sur un plan 2D
- $Y$ est la coordonnée Y de la tuile sur un plan 2D

[^lb]: Equilibrage automatique des charges de travail sur les serveurs

Voici par exemple le fichier téléchargé en envoyant une requête sur l'adresse  

`https://a.tile.openstreetmap.org/17/67308/46743.png`

![Tuile représentant CPE Lyon au niveau de zoom 17](img/osmcpelyon.png){width="25%"}

Chaque tuile téléchargée, que l'on appelle `ortho`, sera appliquée sur la géométrie de terrain dans le moteur de rendu. 

### Résultat final 

En ajoutant les tuiles de terrain, de ville, ainsi que les extras générés par les outils ci-dessus, l'affichage par un moteur de rendu dont le concept sera expliqué en partie 3 permet alors de sortir une application 3D de maquette d'environnement. Le résultat est visible dans la figure ci-dessous. 

![Rendu des 3 couches dans le moteur de rendu Unity](img/ScreenUnity.png){width="85%"}

## Solution de back-end
### Back-office  

Le back-office est l'outil qui va permettre l'utilisation de la chaîne d'outil géospatiaux précédemment décrite. Bien que ces derniers soient déjà utilisables en l'état via l'interface en ligne de commande (CLI), ils sont peu graphiques et donc inutilisables pour des chefs de projets non initiés. Il faut donc fournir une interface utilisable, sous la forme d'une application Web et de l'application serveur associée. 

L'architecture du back-end suit une SOA (`architecture orientée service`), implémentée avec le langage Rust et utilisant la librairie `actix-web`. Cette librairie utilise le design pattern `actor` pour obtenir de très bonnes performances (actix-web est souvent classé dans les framework webs les plus performants, cf. [@techempower]). 

Le pattern d'actor fonctionne par un échange de message entre acteurs. A partir des adresses, chacun possède sa "boîte aux lettres" capable de recevoir des messages, de manière synchrone ou asynchrone. Puisque les mécanismes de synchronisation le permettent et par la nature de l'échange de message où chaque acteur garde uniquement son propre état, un acteur peut être situé sur n'importe quel fil d'exécution (`thread`), et sur n'importe quelle machine physique. Cette particularité permet une bonne scalabilité horizontale et rend le système potentiellement extensible. 

Prenons pour exemple le schéma suivant de dialogue entre les acteurs A et C

```{.svgbob width="65%"}

    Thread A                Thread B 
    +---------------+       +-----------+
    |               |       |           |
    | +---+   +---+ |       | +---+     |       
    | | A |   | B | |       | | C |     |
    | +---+   +---+ |       | +---+     |
    |   |           |       |   ^       |
    |   |           |       |   |       |
    |   +-----------+-------+---+       |
    |     message   |       |           |
    +---------------+       +-----------+

```

Au regard de l'implémentation, un acteur est une structure de données qui implémente le trait[^trait] `Actor`. Ce dernier permet de définir un contexte (synchrone ou asynchrone) afin de définir le fonctionnement interne de l'acteur.

Un message est un trait qui définit un type de réponse. Tout acteur qui souhaite pouvoir recevoir un type de message particulier doit alors implémenter le trait `Handler`, qui permet de définir un type de réponse qui doit être le même que celui du Message. Ce mécanisme permet de garantir à la compilation qu'un message sera effectivement traîté par un acteur et évite donc les erreurs ainsi que la perte de performance au runtime.

[^trait]: Particularité permettant la généricité Rust, qui joue à peu près le même rôle que les interfaces dans une conception objet. 

Le but du back-end est de fournir sour forme de service consommables via des requêtes HTTP les outils en ligne de commande décrits précédemment. En l'occurence, chaque service sera un acteur. Chaque programme expose ses fonctionnalités comme une librairie classique. Afin de lancer ces fonctionnalités, un point d'entrée unique est fourni pour chaque programme. La librairie `structopt` est utilisée, son but est de définir une structure de données qui est automatiquement crée au lancement du programme, et contient les informations données dans la ligne de commande. L'utilisation d'une telle librairie permet donc de garder le format ligne de commande qui facilite le debugging, et d'exposer l'outil de manière simple. 

Une application de ce type nécessite l'utilisation d'une base de données. Il existe une librairie nommée `Diesel`, une couche ORM[^orm] securisée et performante. Se fondant sur cette dernière et utilisant le SGBD[^sgbd] `SQLite`, cette base de données permettra de stocker les informations diverses sur les projets:  

- Coordonnées de projet
- Bounds
- Niveau de zoom à exporter
- Nom des projets
- Informations de bruit (taille de kernel, seed de génération pseudo-aléatoire, hauteur des bâtiments)
- Méta-données sur les fichiers HGT et OSM XML

L'architecture de la base de données suit le schéma MPD[^mpd] suivant : 

![MPD de la base de données du back-office](img/MPD_DB_Backend.png){width="75%"}

Pour l'interaction avec la base de données, une architecture REST[^rest] est mise en place, exposant sur les acteurs nommés "API" les routes HTTP qui permettent de répondre à des méthodes `GET`, `POST`, `PUT` et `DELETE`.

[^orm]: Object Relational Mapping, librairie permettant de transformer des données issues d'une base de données en structure utilisable dans la technologie cible.
[^sgbd]: Système de gestion de base de données *e.g.* MySQL, PostgreSQL, Oracle, SQLite... 
[^mpd]: Modèle Physique de Données: représentation schématique du contenu d'une base de données
[^rest]: REpresentational State Transfer, architecture de services proposant l'intéraction avec une ressource contenue sur le serveur.

De plus, le back-end expose une partie du système de fichiers interne du serveur afin de rendre possible le téléchargement des tuiles après leur génération. Cela permet également de stocker les fichiers du front-end afin d'héberger l'application web discutée ci-dessous.   


### Front-end

Si le serveur back-office est l'outil essentiel pour lancer les processus de création des géométries, il n'est pas utilisable à lui seul. Il faut créer une application Web qui lancera les requêtes de façon adéquate. L'entreprise Asylum possède déjà une base de code assez large [@rapport1], le projet Infinity WebGL utilisant le framework Vue.js.  

![Logo de Vue.js](img/LogoVue.png){width=20%}

Vue.js embarque son propre système pour le routage et pour la gestion de l'état interne d'une application et de ses composants (le pattern de `store`s et son implémentation `Vuex`). Pour ne pas avoir à se soucier de l'aspect graphique, mais le garder tout de même à l'esprit afin que l'application reste utilisable, un Framework CSS[^css] nommé `Bootstrap` (développé par Twitter) est mis en place. Il existe une librairie `bootstrap-vue` qui permet de faire facilement l'opération de jointure entre les deux frameworks. 

[^css]: Cascading Style Sheet, format de fichier permettant la mise en place du style graphique d'une page Web.

L'application se présentera sous la forme d'une page internet suivant les normes du Web Statique, meublant son contenu entièrement avec du JavaScript via des requêtes sur le back-office.   

Cette application est encore en phase de développement et il n'est donc pas possible d'en fournir des images pour l'instant.  

### JSON generator

Afin de standardiser l'entrée des deux moteurs d'affichage, il y a besoin d'une liste d'informations : 

- La taille de l'environnement
- Le nom du projet
- Les coordonnées X et Y des tuiles à afficher
- Le facteur de mise à l'échelle à appliquer sur les tuiles (cf. partie 4.1)

Celles-ci sont sérialisées et stockées dans un fichier JSON sur le serveur. Chaque moteur qui aura récupéré le fichier pourra le désérialiser et l'interpréter afin d'afficher correctement l'environnement.

En Rust, la sérialisation et la désérialisation d'une structure de données se fait avec la crate `serde`. Serde est la contraction de deux mots: `ser(ialisation)/de(serialisation)`. C'est la librairie la plus plébiscitée puisqu'elle utilise parfaitement les mécanismes de typage du langage afin d'en génériser le fonctionnement. On ajoute également la crate `serde_json`, qui ajoute la prise en charge du format JSON à Serde. 

Ce programme gère l'extraction des données de la base qui concernent un projet, puis l'écriture dans un format clair, standardisé et compréhensible par une machine.

## Moteur d'affichage

### Trivia 

Comme décrit en début de rapport, l'utilisation des modèles d'environnement génerés à partir des outils précédents se fait sur deux moteurs différents. Pour les applications de bureau et les cibles mobiles (Android et iOS) l'outil Unity, dont le fonctionnement a déjà été couvert dans le rapport 1, est la solution par défaut de l'entreprise.

Pour la partie Web, un moteur 3D développé en utilisant la technologie WebGL via la librairie `Three.js` permet d'afficher l'environnement. Ce dernier a la charge d'optimiser le chargement et l'affichage sur le Web avec les moyens à disposition.

### Unity

L'intégration au sein du moteur Unity se fait avec des **outils d'éditeur**. Ce sont des scripts C# qui héritent d'une classe particulière, la classe `Editor` qui permet à Unity de comprendre comment intégrer le script dans le workflow. Ceux-ci permettent d'automatiser certaines tâches durant la création des scènes 3D. L'outil développé suit le schéma de fonctionnement suivant :  

```{.svgbob width="70%"}


                          +-x Application utilisable
                          |
                          |
    Serveur back-end      |     Unity             Scripts d'editeur
    +-----------+         | +-----------+       +----------------------+
    |           |         | |           |       |                      |
    | Modèles   |         +-| Assets    |       | + Télécharge les     |
    | Textures  |           | Scènes 3D |       | modèles depuis le    | 
    |           |           | Scripts   |       | serveur              |
    +-----------+           |           |       | + Insère les assets  |
          ^                 +-----------+       | dans les scènes      |
          |                                     | + Gère les problèmes |
          +-------------------------------------| d'échelle            |
                      Requêtes HTTP             |                      |
                                                +----------------------+
                            
```

On télécharge dans un premier temps le fichier JSON du projet présent sur le serveur, puis on le désérialise afin de récupérer les informations sur les tuiles qui composent le projet. On peut alors lancer le téléchargement et la création des assets[^assets] au sein du moteur, avant d'insérer ceux-ci dans la scène. Il s'agit ensuite d'appliquer un facteur de mise à l'échelle pour faire correspondre les tuiles de ville, de terrain et les extras. Après avoir finalement appliqué les textures adéquates, l'intégration est alors complète et l'application est prête à être exportée et empaquetée correctement par le moteur.   

[^assets]: Artéfacts, ressources utilisables dans un projet *e.g.* Modèles 3D, sons ou textures

Couplé à quelques autres scripts, par exemple : 

- Le déplacement de la Caméra
- Le zoom et le dézoom
- L'aspect graphique de l'environnement
- La base de code pour le projet District3D

On obtient une application stable et performante, avec un temps de développement très faible et qui a l'avantage de marcher sur toutes les plateformes. Sauf sur le Web, où les performances laissent largement à désirer. 

### WebGL

L'idée de la création d'un moteur spécial pour le Web est issue du manque de performance de l'outil Unity sur le Web. De plus, une telle intégration serait utilisable pour un potentiel mode "preview" dans l'application Web. Il convient donc de trouver les techniques qui permettent l'optimisation des performances de rendu dans un contexte aux ressources limitées (mono-thread, utilisation de mémoire réduite, capacité de traitement réduite).

En plus de l'écriture manuelle de shaders[^shader] spéciaux pour ce moteur, qu'on ne détaillera pas ici, et de la résolution de la problématique de temps de chargement traitée plus bas, on compte trois optimisations principales qui permettent d'accélérer l'affichage sur le Web. 

L'utilisation de Level Of Detail (LOD) - niveau de détail en français - est la plus facile d'entre elles ; on utilise ici une mécanique qui permet de découper les géométries par niveau de zoom, et en fonction de la distance à la caméra, on décide quel niveau de détail afficher. Il s'agit ensuite de charger et décharger dynamiquement les tuiles afin de n'afficher qu'une seule fois la géometrie. En groupant les géométries par niveaux de zoom, la taille moyenne du téléchargement est réduite, et cela permet donc de meilleures performances pour le moteur.

```{.svgbob width="30%"}

    +---+---+---+---+---+
    | 2 | 1 | 0 | 0 | 0 |
    +---+---+---+---+---+
    | 2 | 1 | 0 | x | 0 |
    +---+---+---+---+---+
    | 2 | 1 | 0 | 0 | 0 |
    +---+---+---+---+---+
    | 2 | 1 | 1 | 1 | 1 |
    +---+---+---+---+---+

x caméra 
{ 0 1 2 } niveau de zoom 

```

Le niveau de zoom étant plus précis plus il est grand, le niveau de zoom $zl$ à afficher suit alors la formule suivante $$zl = zl_{max} - z$$ où z est un nombre qui grandit en fonction de la distance de la tuile à la caméra, et $zl_{max}$ est le zoom level maximum géré par le terrain. 


[^shader]: Programmes s'éxécutant directement sur la carte graphique s'intégrant dans une pipeline de rendu graphique qui permettent de gérer finement le rendu des géométries (vertex shader) puis des pixels (fragment shader)

La deuxième optimisation est l'utilisation du cache du navigateur. Il existe dans tout navigateur une implémentation d'une base de données interne appelée `Local Storage`. Cette particularité permet de garder en mémoire le contenu de nos géométries afin d'en permettre un chargement rapide dans le moteur. Afin de sauvegarder lesdits modèles, il faut d'abord les importer grâce à la librairie `Three.js`, puis sauvegarder la représentation du modèle dans le cache. Au prochain chargement, il suffira alors de vérifier si le modèle est déjà présent afin d'éviter un potentiel téléchargement.

Enfin, il existe une technologie désormais prise en charge par tous les navigateurs modernes, baptisée `WebAssembly`, ou `WASM`. C'est un format d'instruction binaire ayant pour but d'être rapide et sécurisé cf. [@wasm].  

Rust pouvant être compilé en `WASM` pour être lancé sur le Web, il a été décidé de ré-écrire le parsing de fichiers `.obj` afin d'en améliorer les performances. Par manque de temps, cette optimisation n'a pas été mise en place, mais la piste a été évoquée et nécessite d'être travaillée car elle parrait prometteuse. 

# Difficultés et solutions

## Scaling du projet 

Une des problématiques qui a été soulevée est l'utilisation d'un système d'unité unique. En effet, suivant le principe de tuiles expliqué précédemment, celles-ci sont supposées faire une taille de 256x256 unités car elles utilisent la projection `WebMercator`. Il faut donc effectuer la projection inverse pour pouvoir transformer ces unités en mètres, aussi bien pour les tuiles de ville et d'extra que pour celles de terrain. 

Une fois ce problème résolu, il a fallu se pencher sur l'intégration du travail des graphistes. Celui-ci suit des plans d'architectes, et est ainsi réglé au mètre près. Il faut donc appliquer une mise à l'échelle sur toutes les tuiles, suivant un facteur précis pour chaque axe permettant de passer du virtuel à la mesure réelle. Ce dernier est calculé de la façon suivante : $$rx = 256 / \Delta_x$$ $$ry = 256 /\Delta_y$$ où $\Delta_x$ et $\Delta_y$, sont les distance réelle en mètres d'un bout à l'autre des bounds du projet, que l'on calcule grâce à la formule de Vincenty cf. [@vincenty], qui prend en compte l'applatissement aux pôles de la terre.    

On bénéficie alors d'une intégration de la maquette 3D dans l'environnement sans souci d'échelle.

## Découpe du projet dans les tuiles

Afin d'intégrer au mieux le projet dans l'environnement, il faut placer un trou au sein de la maquette d'environnement, que le projet viendra combler.  

```{.svgbob}

                                         |            .__,
                                         |           /  /+       
                                         |          |\_/ |
                                         |          |  | |
      +---------+ <-- environnement      |          +  | +----+ <-- environnement 
     /  ,__    /                         |         /|  | +   /
    /  /  /   /                          |        / \  |/ <-+------ projet
   /   \_/ <-+------- trou               |       /   `-+   /
  /         /                            |      /         /
 +---------+                             |     +---------+

```

Dans ce but, les artistes 3D donnent aux outils une empreinte au format `.obj` que l'on va traiter afin d'en sortir un polygone de contour. La méthode est simple : à partir de la suite de triangle donnée par la surface 3D, on définit les arrêtes communes. Si une arrête est unique, c'est que c'est une arrête exterieure puisque les polygones sont considérés simples (sans trou à l'intérieur).

```{.svgbob width="38%"}

       *     *


    *  *  *      *


    *     *

        |
        | Tesselateur
        |
        v

       *-----*                          *-----* 
      / \   / \                        /       \
     /   \ /   \   Arrêtes uniques    /         \
    *--*--*-----* -----------------> *  *  *-----*
    | / \ |                          |     |
    |/   \|                          |     |
    *-----*                          *-----*
        
```

Les tuiles de ville et d'extras sont déjà adaptées puisqu'elles possèdent un système de "requêtage" du fichier OSM, permettant d'éliminer les éléments de l'environnement selon leur position géographique. Il suffit alors de faire un test d'inclusion dans le polygone définit par la forme du projet, et ainsi de ne pas rendre ces objets dans la géométrie finale. 

Pour le cas des tuiles de terrain, le problème est un peu plus complexe. Il s'agira de prendre la forme rectangulaire des tuiles, et d'utiliser un opérateur booléen de différence, avant d'appliquer un algorithme de subdivision afin d'obtenir une surface `.obj` utilisable, avec un trou à la place du projet. 

```{.svgbob width="40%"}

Différence: A \ B 

    A           B
*-------*   *-------*   *       *
|       |    \     /    |\     /|
|       | -   \   /   = | \   / |
|       |      \ /      |  \ /  |
*-------*       *       *---*---*

```

Pour résoudre cette problématique d'opérateur booléen, la première solution a été d'utiliser l'algorithme d'Hormann-Greiner [@hgalgo]. Celui-ci est une bonne base de travail bien qu'il ait ses limites ; notamment, il ne gère pas les cas que l'on appelle dégénérés, où il existe des intersections entre les polygones sur les sommets de ceux-ci, ce qui arrive fréquemment dans notre cas.

Pour pallier ce problème, il a fallu refactoriser l'implémentation de l'outil `hgt-to-obj` afin d'utiliser la crate `geo`, qui possède quelques implémentations de composantes géographiques très utiles, et notamment l'extension `geo-booleanop` qui permet d'effectuer des opérations booléennes comme expliqué précédemment. Leur implémentation se fonde sur l'algorithme de Martinez-Rueda cf. [@martinezrueda]. 

Une fois l'opération terminée, on obtient un polygone qu'il faut ensuite transformer en surface 3D, tout en ajoutant des sommets à l'intérieur pour reproduire le "maillage" fourni par l'ancienne version. Pour ce faire, on appliquons d'abord une passe de tesselation via la crate `lyon`, puis on applique l'algorithme de Subdivision de Catmull-Clark cf. [@catmullclark] afin d'ajouter des points dans le modèle 3D, répétant l'opération un nombre de fois défini par la précision du modèle.

On obtient alors des résultats moins stables qu'auparavant, mais restant exploitables.


## Réduction des temps de chargement

Il est évident que plus il y a de données de géométries à charger, plus l'application prendra du temps à charger. De plus, l'implémentation des différents parseurs de formats est facilement mesurable. Des études comparatives sur le poids des géométries et la vitesse de chargement par `three.js` de celles-ci ont donc été menées, afin de statuer sur le format à utiliser.

Ce benchmark a été effectué en prenant 4 types de modèles, en mesurant la taille du fichier en Mo, et le temps de chargement induit moyen, et se servant de l'écart-type pour mesure la stabilité du chargement. Les tests ont été effectués sur le navigateur Firefox version 66, et sur une machine haut de gamme. 

### Format DAE

| -                   | Cube    | Ico-Sphère | Modèle simple | Modèle complexe |
| ------------------- | ------- | ---------- | ------------- | --------------- |
| Poids               | 2.56 Ko | 7.14 Ko    | 66.9 Ko       | 5.68 Mo         |
| Temps moyen         | 25.2 ms | 24.7 ms    | 28.8 ms       | 491 ms          |
| Temps le plus court | 21 ms   | 21ms       | 25 ms         | 481ms           |
| Temps le plus long  | 30 ms   | 27ms       | 39ms          | 508ms           |
| Ecart-type          | 3.01 ms | 1.77 ms    | 4.73 ms       | 8.9 ms          |


\newpage

### Format FBX

| -                   | Cube     | Ico-Sphère | Modèle simple | Modèle complexe |
| ------------------- | -------- | ---------- | ------------- | --------------- |
| Poids               | 10.9 Ko  | 12.6 Ko    | 23.4 Ko       | 2.26 Mo         |
| Temps moyen         | 35.8 ms  | 26.5 ms    | 33.9 ms       | 248.5 ms        |
| Temps le plus court | 22 ms    | 23 ms      | 24 ms         | 242 ms          |
| Temps le plus long  | 106 ms   | 31 ms      | 60 ms         | 255 ms          |
| Ecart-type          | 25.35 ms | 2.88ms     | 10.64 ms      | 4.88 ms         |

\ 

### Format OBJ

| -                   | Cube    | Ico-Sphère | Modèle simple | Modèle complexe |
| ------------------- | ------- | ---------- | ------------- | --------------- |
| Poids               | 638 o   | 5.05 Ko    | 44.7 Ko       | 1.58 Mo         |
| Temps moyen         | 24.3 ms | 24.1 ms    | 25.5 ms       | 123.9 ms        |
| Temps le plus court | 18 ms   | 20 ms      | 22 ms         | 97 ms           |
| Temps le plus long  | 28 ms   | 30 ms      | 29 ms         | 186 ms          |
| Ecart-type          | 3.17 ms | 3.21 ms    | 2.17 ms       | 37.66 ms        |

Il apparaît clairement que le format `.obj` est le meilleur compromis entre le poids, la vitesse de chargement et la stabilité. C'est donc ce format qui a été retenu.

De plus, les fichiers de géométries sont des fichiers textes, ce qui implique que l'on peut appliquer la compression gzip, supportée nativement par les navigateurs. Dans le cadre des géométries, on atteint 75% de compression sans impact significatif sur la vitesse de lecture. 

Un dernier problème réside dans la taille des tuiles Extra. En effet, lors de la construction de celles-ci, le modèle d'arbre et tous ses sommets sont copiés. Ceci résulte en une géometrie extrêmement massive - près de deux tiers du poids total. Pour résoudre ce problème, il est possible par exemple d'effacer complètement les tuiles d'extra, et laisser au moteur le soin d'importer le même modèle d'arbre aux coordonnées qui seraient passées par le biais d'un fichier JSON que la suite d'outil géospatiale aurait généré.

\newpage 

# Conclusion 

Le projet consistait à l'origine à designer et développer une suite d'outil performants permettant de générer un environnement 3D complet, et de rendre le tout utilisable par une application Web interne à l'entreprise. 

\

A l'issue de cette seconde année d'alternance, mon travail a mené à un logiciel qui répond aux attentes du projet. La solution pourra être intégrée par la suite dans les projets d'application commercialisées par l'entreprise. Le résultat est satisfaisant tant dans les fonctionnalités que dans les performances, et la variété des tâches du sujet m'ont permis une bonne évolution professionnelle. 

\

Par la variété des technologies utilisées dûe à la carte blanche qui m'a été laissée, ainsi que les différentes tâches qui m'ont été attribuées, le travail sur cette itération a été globalement agréable et très complet sur le plan des compétences mises en oeuvre. J'ai senti que mon travail avait un impact sur l'entreprise dans sa globalité.   

\

Cependant, si les ambitions du projet sont grandes, il est regrettable que l'effectif de l'entreprise ne permette pas à un projet d'une telle ampleur d'aboutir entièrement. Ayant été l'unique développeur du projet sur la période de Juillet 2018 à Mai 2019, je regrette de n'avoir pas pu utiliser toutes les techniques de gestion de projet vu en cours, et de ne pas pouvoir inscrire mon travail dans une logique de groupe. 

\

Le challenge scientifique intéressant, la démarche de conception détaillée dans ce rapport ainsi que l'experience acquise sur le langage Rust et autour des technologies de rendu 3D constituent de forts apports pour ma future carrière. 

\newpage
\appendix 

# Annexes

![Groupe scolaire à Marjevols - Réalisation Asylum](img/RealAsy1.jpg)
**Annexe 1** Groupe scolaire à Marjevols - Réalisation Asylum

![Villa à Annecy - Réalisation Asylum](img/RealAsy2.jpg)
**Annexe 2** Villa à Annecy - Réalisation Asylum

![Rendu de l'intégration du quartier de la Part Dieu](img/ScreenIntegPartDieu.png)
**Annexe 3** Rendu du quartier de la Part-Dieu

![Screenshot du tableau Trello au 21 Mai 2019](img/ScreenTrello.png)
**Annexe 4** Screenshot du tableau Trello au 21 Mai 2019

![Organigramme de la société Asylum](img/organigramme.jpg)
**Annexe 5** Organigramme de la société Asylum - Mars 2019

# Bibliographie 