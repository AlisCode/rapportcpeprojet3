---
author: 
    - Olivier Pinon - 5IRC - Promotion 2017/2020 
    - \newline Grégory Obanos - Maître d'apprentissage 
    - \newline Marion Foare - Tutrice école
date: Année universitaire 2019/2020
title: Conception et implémentation d'une suite d'outils géospatiaux 3D
subtitle: Designing and implementing a 3D geospatial toolchain
caption: Projet 3 - Informatique et Réseaux de Communication 
lang: "fr-FR"
keywords: [Rust, API, REST, Framework Web, Open-Source]
titlepage: true
logo: img/LogoAll.png
logo-width: 350
#bibliography: biblio.bib
header-left: ITII Lyon
fontsize: 10pt
header-center: Impero
header-right: CPE Lyon
footer-left: Olivier PINON - 5IRC
toc: true
---

\newpage 

**Remerciements**: 

Blablabla

\newpage

# Contexte en entreprise 

## Société Impero 

* Chiffres 
* Situation géographique
* Présentation logiciel Impero
* Clients

## Organisation interne 

L'entreprise est composée de 14 collaborateurs dont 6 ont des compétences techniques permettant le développement du produit. 

```{.svgbob name="Organigramme de la société Impero"}

                  +-------------------+
                  | Rikke Stampe Skov | Présidente Directrice Générale
                  +-------------------+

       +--    Pôle commercial   --+            |  Pôle relation clients | Directeur artistique
       |                          |            |                        |
+------+----------+ +-------------+----------+ | +--------------+       |  +----------------+
| Karsten Mayland | | Jacob Engedal Sørensen | | | Morten Balle |       |  | Thomas Norsted |
+-----------------+ +------------------------+ | +--------------+       |  +----------------+
                                               |  Product Owner         |
                                               |                        |-----------------------------
                                               | +---------------+      | Responsable de communication
                                               | | Thomas Aagard |      | +-----------------+
                                               | +---------------+      | | Lise Kildsgaard |
                                               |                        | +-----------------+
                                               | +--------------------+ |
                                               | | Morten Christensen | |
                                               | +--------------------+ |


                                 Pôle DevOps : Développement + Infra
 +-------------------------------------------------------------------------------------------------+
 |                                                                                                 | 
 | +------------------+                                 +-----------------------+                  | 
 | | Emmanuel Surleau | Directeur technique             | Arnaud de Bossoreille | Lead Développeur | 
 | +------------------+                                 +-----------------------+                  | 
 |                                                                                                 | 
 | +-----------------+  +-------------+ +--------------+ +---------------+                         | 
 | | Grégory Obanos  |  | Oliver Hoog | | Mateus Costa | | Olivier Pinon |                         | 
 | +-----------------+  +-------------+ +--------------+ +---------------+                         | 
 |                                                                                                 | 
 +-------------------------------------------------------------------------------------------------+


```

La société favorise le travail à distance (pas seulement en contexte de pandémie), chaque employé est autorisé au télétravail, ce qui permet à l'entreprise de ne pas s'encombrer de recrutements conditionnés par la situation géographiques des candidats.  

L'équipe de développement est intégralement décentralisée (sur le même fuseau horaire tout de même), avec 3 développeurs en France, deux en Allemagne, et le CTO[^cto] au siège de l'entreprise, à Aarhus. 

A titre personnel, cette méthode de travail qualifiée de "remote" (comprendre: à distance) était très nouvelle, mais j'y ai pris goût pour la liberté d'action qu'elle me laisse. Elle implique cependant d'avoir une organisation correcte de son temps afin de ne pas mixer vie professionelle et vie personnelle. 

[^cto]: Chief Technical Officer, Directeur Technique.

## Méthode de travail 

Impero met en valeur son organisation jeune et dynamique, d'entreprise de type Startup. Il est donc logique qu'elle applique une méthode de gestion de projet agile. Si l'entreprise en applique certains principes et met en place la plupart des artéfacts agiles, elle ne se définit pas par un méthode précise type Scrum ou Kanban.

* Des réunions "**Dev Meeting**" se tiennent tous les lundis et mercredis à 10h, elles servent à la fois de rétrospection sur la semaine passée, et de planning pour la semaine à suivre, permettant au passage de vérifier que personne n'est bloqué sur le travail d'un autre.
* Un outil de suivi de tâches est utilisé quotidiennement par toute l'équipe. Il s'agit de Clubhouse, qui offre certains avantages comme la possibilité d'être intégré à Slack et à Bitbucket pour faciliter le flux de travail de tout un chacun. A l'heure actuelle, le CTO de l'entreprise gère la rédaction de la majorité des tickets, nous verrons par la suite que ceci est en train de changer. 
* L'évolution des tâches est suivie par l'un des co-fondateurs, Morten Balle, Product Owner du logiciel Impero.

Le processus de développement suit le schéma suivant  

```{.svgbob name="Cycle de développement d'une fonctionnalité chez Impero"}
                                          |
           Phase de rafinement            |               Phase de développement
                                          |
 +----------------+     +---------------+ | +----------------+   +--------+     Validation
 | Identification |---->| Spécification |-+-| Développement  |-->| Revue  |-----------------+
 +-+--------------+     +-+-------------+ | +----------------+   ++-------+                 |
   |                      |               |                       |                         |
  "Refinement meeting"   Rédaction du     |             Chaque développeur peut             |
                         (Clubhouse)      |             revoir le code d'une personne       |
                                          |             et demander des changements pour    |
                                          |             améliorer la qualité de celui-ci    |
                                          |                                                 |
   +--------------------------------------+-------------------------------------------------+
   |                                      |
   |      Phase de pré-production         |                                
   v                                                +---------------------+
 +-+--------------+      +------+    Validation     |  Fonctionnalité en  |
 | Pré-production |----->| Test |---------+-------->|      production     |
 +----------------+      +------+         |         +---------------------+
  |                                       |
 La fonctionnalité est mise à             |    La fonctionnalité est  
 disposition sur le serveur "staging".    |    utilisable par les clients d'Impero
 Elle est prête à être testée             |
                                          |
```

La phase de rafinement correspond à l'identification du problème, suite à un besoin remonté par un client ou une volonté d'évolution du logiciel. Au cours de nombreuses réunions, appellées **refinement meeting**, le besoin client est analysé. Elle a lieu avec le Product Owner de l'entreprise qui a la vision du produit, le directeur artistique qui garde en tête l'experience utilisateur de l'application, et le directeur technique de qui connaît l'architecture de la solution et estime la faisabilité des demandes. On cherche à définir une fonctionnalité qui comblera le besoin identifié de la façon la plus générique possible (en évitant par exemple d'avoir une fonctionnalité qui ne servira qu'à un seul client).

## Environnement technique

L'entreprise Impero déploie sa solution Web sur un serveur à l'aide d'`Ansible`, un outil open-source permettant la mise en production, qui est gérée manuellement par le CTO et le lead développeur. 

L'architecture du logiciel est composée d'un serveur, que nous appelerons "backend" et qui héberge une application Web, que nous appelerons "frontend". 

Le backend est implémenté avec le langage de programmation **Rust**, qui vise à permettre à tout développeur de fournir des programmes sécurisés et performants, tirant avantage des technologies modernes (comme le multithreading) tout en leur offrant beaucoup d'outils pour se faciliter la tâche. Rust est un langage dit "système" capable de cibler toutes les plateformes allant d'Android au Web (via WebAssembly) en passant par les OS plus conventionnels, et même l'embarqué. Celui-ci est multi-paradigme (on peut s'en servir comme d'un language fonctionnel, impératif, voire même orienté objet sur certains aspects). A titre personnel, c'est une technologie avec laquelle j'ai beaucoup de plaisir à travailler car son compilateur strict empêche beaucoup d'erreurs avant qu'elles n'arrivent en production, ou qu'elles ne proviennent d'une mauvaise architecture du programme que j'écris.

Dans le cadre du logiciel Impero, le serveur Web est implémenté à l'aide de Rocket, un framework web très complet dont nous détaillerons le fonctionnement plus tard. 

Le frontend est implémenté avec **TypeScript**, un surensemble de JavaScript apportant plus de garanties statiques[^staticguarantees] permettant également de faire moins d'erreur et de rendre le refactoring plus aisé. Le Framework **React** est utilisé afin de se faciliter la tâche et de rendre le tout maintenable. Enfin, le framework d'interface **antd** sert de cadre à l'application pour lui donner une touche moderne et un peu d'esthétisme. 

L'entreprise laisse carte blanche à ses employés en ce qui concerne leur environnement de travail personnel: un budget est donné à chacun pour qu'il/elle achète un ordinateur qu'il/elle garde pendant son contrat. Ainsi, le collaborateur est libre de choisir son système d'exploitation, l'IDE[^ide] qu'il utilise, et ainsi d'avoir un poste de travail vraiment personnel. Cette particularité implique cependant de standardiser l'environnement de développement, afin d'éviter les problèmes liés aux différentes plateformes. **Docker**, le système de containerisation devenu standard de l'industrie, est donc tout indiqué. Ce dernier offre également le bénéfice de pouvoir travailler facilement avec des systèmes à l'installation complexe et sensible aux erreurs comme **Redis** et **PostgreSQL**, sur lesquels le backend s'appuie. 

Afin de garder une trace des différentes versions du logiciel et de permettre le travail collaboratif, Bitbucket a été mis en place. Impero bénéficie du système d'Intégration Continue (CI) de ce dernier, ce qui est d'ailleurs grandement facilité par l'utilisation de Docker sus-mentionné, dans le but d'empêcher la mise en production d'un système qui n'aurait pas été testé, et de faire travailler d'autres personnes avec un programme qui ne compile pas. 

[^staticguarantees]: Garanties apportées par le compilateur permettant notamment d'être sûr que le programmeur n'a pas fait d'erreur de type.
[^ide]: Integrated Development Environment, logiciel pour écrire du code.

## Problématiques en tant qu'Ingénieur Développement

L'entreprise cherchant à devenir de plus en plus importante, elle a augmenté sa capacité de production. Le nombre de développeurs est passé de 3 à 6 sur l'année 2019. Cela implique des tâches de gestion plus complexes, notamment dans la rédaction des spécifications techniques décrites plus tôt. A cet effet, le processus de spécification est en train d'évoluer pour permettre aux DevOps d'être impliqué dans la rédaction de tickets. J'ai donc été amené à participer - voire animer par moment - des **refinement meeting**. Nous développerons cela dans la troisième partie du rapport : **Développement et spécifications de nouvelles fonctionnalités**.

Toujours dans sa politique d'expansion, Impero a cherché à rentrer en partenariat avec des entreprises de plus en plus grandes, comme Volkswagen. Avoir des clients d'une telle taille implique d'apporter un soin particulier au développement de l'interfaçage de sa solution avec son client, ces derniers ayant tendance à vouloir recréer des outils internes utilisant les fonctionnalités et les données proposées par les outils externes, dont le logiciel Impero fait partie. Il est donc apparu clairement qu'il faudrait trouver un moyen pour l'entreprise de : 

* Mettre en place un accès exterieur sur son API[^api] publique. 
* Documenter celui-ci 
* Faire en sorte qu'il respecte au maximum les standards de l'industrie du logiciel, dans le cas présent, une API REST

L'objectif du projet de recherche que j'ai mené était de faciliter l'écriture et le maintien de nouveaux services avancés exposés directement au client. 

[^api]: Application Programming Interface, ou interface logicielle permettant d'intéragir avec notre système.

~~ Page 8

# Recherche - Couche d'abstraction pour Framework Web

## Contexte et objectif 

Afin de résoudre la problématique d'ouverture de l'API que nous venons d'énoncer, il est important de comprendre le contexte dans lequel le backend est développé, et quels objectifs ce projet de recherche se propose d'atteindre. 

Le travail s'articule autour de l'outil Diesel que nous qualifierons d'ORM[^orm]. Cette librairie ajoute de la sureté lorsque l'on travaille avec du SQL[^sql], uniquement sur les systèmes de gestion de base de données relationnelles, au prix de l'écriture d'un code un peu plus verbeux. Cette sureté se traduit concrètement de la façon suivante : 

* La requête SQL que l'on écrit est vérifiée **statiquement** (comprendre: à la compilation), et est garantie d'être valide. Il n'y a **aucune** possibilité de faire une faute de frappe, de requêter des champs d'une autre table par mégarde, mais surtout lorsqu'une modification est apportée à la structure de la base de données, si la requête devenait invalide, le compilateur en avertirait aussitôt le programmeur ce qui représente un gain de temps et une sécurité non-négligeables. 
* Les structures de données qu'un programmeur écrit sont également vérifiées pour qu'elle puisse accueillir le résultat d'une requête, sans quoi le compilateur bloquera l'éxécution également. 

Comme indiqué précédemment, cet outil a un prix: les structures et les requêtes à écrire sont plutôt verbeuses, et écrire plus de code amènera immédiatement des problèmes de maintenabilité. De plus, il faut également écrire le code de glue entre le serveur HTTP et l'outil Diesel, afin de mettre des actions en face d'une requête HTTP.  

Le projet de recherche s'appelle **PEWS**. C'est un anagramme récursif pour **PEWS: Easy Web Services**. Son but est de faciliter, voire retirer la nécéssité d'écrire cette glue, ce qui permet d'exposer l'interface en écrivant moins de code, et donc d'obtenir une meilleure maintenabilité, et de la rapidité de développement sans pour autant sacrifier les performances de Rust ni la sûreté de Diesel. Il faut voir celui-ci comme une surcouche à un framework Web, qui aura pour tâche d'écrire l'intégration nécéssaire à la place du développeur. 

Dans un soucis de pérennité, il est prévu de publier la librairie sous licence Open-Source, puisqu'il nous a semblé qu'elle correspondait à un besoin de la communauté Rust de manière générale. Afin de favoriser l'utilisation au sein de ladite communauté, et de rendre l'outil le plus flexible et correct possible, il s'agit de faire en sorte que PEWS puisse faire abstraction du framework Web qu'il décore. 

Afin de comprendre comment nous pouvons aborder ce problème, il faut d'abord comprendre le fonctionnement d'un framework web.

[^orm]: Object Relational Mapping, couche logicielle permettant de faciliter l'intéraction avec la base de données.
[^sql]: Structured Query Language, language utilisé pour effectuer des requêtes sur des bases de données relationelles.

## Etat de l'art

### Qu'est ce qu'un Framework Web

Un Framework Web est une couche logicielle permettant d'exposer des fonctionnalités sur un serveur, le plus souvent dans le but de répondre à des requêtes utilisant le protocole de communication Client-Serveur HTTP.

Le framework a pour but d'exposer des routes, que l'on appelle communément des Endpoints. Par exemple, le site de CPE contient l'article suivant: `https://www.cpe.fr/actualite/actu-chimie-nouveau-diplome-en-chimie/`. Le endpoint qui pourrait être exposé pour accéder à cet article est le suivant: `GET /actualite/<nom_article>`. Elle se décompose de la façon suivante : 

* `GET` est le Verbe HTTP. Il en existe 9 cf. doc mozilla, nous en utilisons communément 5 :  
	* GET - pour récupérer la définition d'une ressource
	* POST - pour créer une ressource 
	* PUT - pour remplacer la ressource par la nouvelle définition que l'on donne 
	* PATCH - pour appliquer des modifications partielles sur une ressource 
	* DELETE - pour supprimer la ressource 



### Premier cas d'étude : Rocket

### Second cas d'étude : Actix-Web

### Troisième cas d'étude : Warp

## Abstraction de Framework Web 

### L'abstraction de Route - Endpoint

### L'abstraction Repository

### Le montage des routes  

## L'interface utilisateur de la librairie

ref: Guidelines Rust

### Les macros procédurales  

## La gestion d'un projet de recherche

### Suivi du projet 

* Premières tentatives d'écriture de spécifications
* Réunions
* Démonstration

### Difficultés rencontrées

* Estimer une tâche quand on ne connait pas les solutions à appliquer
* Indicateurs de développement

# Développement et spécification de nouvelles fonctionnalités

## Contexte et objectif

* Module d'administration des utilisateurs
* Meetings
* Organisation via notes 
* Tickets CH

## Ecriture d'une spécification 

### Définition de la fonctionnalité 

### Objectif technique 

### Rédaction de ticket 

# Conclusion 


