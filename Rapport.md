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

**Impero A/S** est une société **Danoise** basée à **Aarhus**, dont l'activité réside dans le développement d'une solution logicielle permettant à ses clients de s'assurer du bon suivi en ce qui concerne la **compliance**, c'est à dire les **obligations légales** de celles-ci. Par sa fléxibilité, l'outil permet notamment de suivre : 

* La déclarations des taxes,
* La gestion des risques liés à l'activité de l'entreprise, 
* L'application de processus internes à l'entreprise, notamment : 
	* Le processus de production 
	* Le contrôle de qualité
	* La logistique
* La gestion des ressources humaines, notamment :
	* Congés
	* Processus de recrutement
* L'application correcte de la RGPD[^rgpd] 

L'entreprise a été crée en 2014 ... chiffres 

Les clients de l'entreprise sont en général de **grandes** (voire **très grandes**) entreprises, telles **Siemens** ou **Volkswagen**, qui mettent en place des processus complexes et bénéficient donc du logiciel de manière acrue. Depuis plus d'un an, l'entreprise a revu son fonctionnement pour acquérir de nouveaux clients, et a opté pour un partenariat avec une grosse entreprise de consulting / audit: **KPMG**.

Ce partenariat vise à pousser l'entreprise à répondre aux attentes de gros groupes qui choisissent KPMG comme consultant, permettant à Impero d'être **utilisé et éprouvé par des clients sérieux** - qui de plus sont en général très satisfaits de la solution proposée - et ainsi d'avoir une **bonne image**, et des clients qui lui rapportent un chiffre d'affaires relativement (par rapport à la taille de l'entreprise) conséquent.  

[^rgpd]: Règlement Général sur la Protection des Données, règlement visant à renforcer et unifier la protection des données pour les individus au sein de l'UE 

## Logiciel Impero

Le logiciel se présente sous la forme d'une application web. Le principe de la solution est d'être très générique dans sa résolution des besoins, de sorte que le client puisse utiliser le produit comme il l'entend pour correspondre aux contraintes propres à son entreprise.    

> Note: Afin de ne pas polluer le document avec trop de captures d'écran, seules 2 sont présentées ici. Il s'agit de parties de l'application qui ont été développées durant l'alternance. D'autres écrans du logiciel sont disponibles en Annexes de ce rapport. 

Afin de comprendre l'intérêt du logiciel, il faut d'abord voir comment il résoud le problème de gestion des risques dans une entreprise. 

![Capture d'écran Impero - RiskMap](img/ScreenImpero1.png)

Ceci est la **Risk Map**, ou "Carte des risques". Elle permet de lister certains risques auxquels l'entreprise cliente doit faire face. Par exemple, un des risques de l'entreprise X qui produit des bateaux pourrait être d'avoir un fournisseur qui n'a pas pu honorer sa commande. Comme on peut le voir, un risque est placé sur la carte par deux caractéristiques : 

* Son **impact** (s'il s'avère que l'évènement a réellement eu lieu, *e.g.* le fournisseur n'a pas livré sa commande, au combien est-ce grave pour l'entreprise sur une échelle de 1 à 5), et 
* Sa **probabilité** (combien de chances cet évènement a-t-il d'arriver, sur une échelle de 1 à 5). 

Il va de soi que plus un risque inhérent à l'entreprise a un fort impact et une grande probabilité d'arriver, plus c'est un risque critique pour celle-ci. Il convient alors de mettre en place un processus face à celui-ci pour en limiter les effets. On parle alors d'**atténuation de risque**, et le risque une fois atténué est dénommé "risque résiduel", qu'on peut observer en cliquant sur le bouton de séléction en haut à droite. Lorsque l'on cherche à appliquer un processus en face d'un risque, c'est là qu'interviennent les **contrôles** et les **programmes de contrôle**.

Un contrôle est une partie d'un processus que l'on met en oeuvre. L'outil Impero permet à l'utilisateur de personnaliser ceux-ci, dans le but qu'il puisse coller au mieux à son processus interne. Concrètement, un contrôle est un formulaire qui peut contenir : 

* Des champs de textes, qu'ils soient numériques ou non.
* Des réponses par bouton radio (une seule réponse possible parmis n choix)
* Des réponses par checkbox (plusieurs réponses possible parmis n choix)
* Un choix via un dropdown (une seule réponse possible parmis n choix)
* Des fichiers associés (PDF comme un bon de livraison, Image comme une photo témoignant du bon déroulé de l'opération)

Chaque utilisateur de l'application peut être assigné au remplissage d'un contrôle, générant alors un **résultat de contrôle**. Celui-ci sera stocké sur les serveurs d'Impero, et pourra être relu *a posteriori* par un utilisateur ayant les droits afin qu'il puisse attester à tout moment de la réalisation correcte de toutes les étapes du processus. Optionellement, on peut paramétrer des **contrôles récurrents**. Par exemple, les paies sont à gérer tous les mois. On peut assigner tous les employés au remplissage du contrôle "Saisie des congés et heures supplémentaires" tous les 20 du mois, ce qui permet d'éviter un suivi individuel autrement plus fastidieux. On pourra également appliquer des rappels sur ces contrôles (X heures ou Y jours avant une date, par exemple). 

Voici par exemple le contrôle que l'entreprise utilise pour le suivi des congés de ses employés. (Il faut noter que la confiance est de mise : aucun contrôle des horaires individuel n'est mis en place car chacun sait quel objectif il a à remplir dans la semaine, et il appartient à la personne d'arranger ses horaires de manière adéquate - en évitant toutefois de subir trop de pression). 

Capture d'écran ...

L'outil étant en développement constant depuis 5 ans, il est actuellement en cours de restructuration au niveau de son interface et de son ergonomie, mais également en cours de ré-écriture côté serveur afin d'effacer la dette technique sur la couche logicielle existante (dite "legacy") que nous évoquerons plus loin. 

Le but actuel de l'entreprise est de prendre en compte les remarques des clients et d'engager la ré-écriture des modules existants sur une nouvelle technologie, afin de repartir sur des bases saines pour l'évolution du logiciel.  

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

Le travail à distance (pas seulement en contexte de pandémie mondiale!) a été intégré dans la culture de l'entreprise depuis quelques années. Chaque employé est autorisé au télétravail, ce qui permet à celle-ci de ne pas s'encombrer de recrutements conditionnés par la situation géographique des candidats. Le recrutement est donc parfaitement équitable puisqu'il s'effectue donc sur les **compétences** du candidat, et non sur d'autres critères arbitraires. 

L'équipe de développement est intégralement décentralisée (sur le même fuseau horaire tout de même), avec trois ingénieurs en France (dont je fais partie), un en Allemagne, un en Hongrie, et le CTO[^cto] au siège de l'entreprise, à Aarhus. 

A titre personnel, cette méthode de travail dite "**remote**" (comprendre: à distance) était très nouvelle, mais j'y ai pris goût pour la liberté d'action qu'elle me laisse. Elle implique cependant d'avoir une organisation correcte de son temps afin de ne pas mixer vie professionelle et personnelle.  

[^cto]: Chief Technical Officer, Directeur Technique.

## Méthode de travail 

Impero met en valeur son organisation jeune et dynamique, d'entreprise de type Startup ; elle applique une méthode de gestion de projet agile. Si l'entreprise emprunte certains principes et met en place la plupart des artéfacts agiles, elle ne définit pas son fonctionnement par un méthode précise type Scrum ou Kanban. On notera notamment : 

* Des réunions nommées "**Dev Meeting**" se tiennent tous les lundis et mercredis à 10h, elles servent à la fois de rétrospection sur la semaine passée, et de planning pour la semaine à suivre, permettant au passage de vérifier que personne n'est bloqué sur le travail d'un autre.
* Un outil de suivi de tâches est utilisé quasi-quotidiennement par toute l'équipe. Il s'agit de Clubhouse, qui offre certains avantages comme la possibilité d'être intégré à Slack et à Bitbucket pour faciliter le flux de travail de tout un chacun. A l'heure actuelle, le CTO de l'entreprise gère la rédaction de la majorité des tickets, nous verrons par la suite que ceci est en train de changer. 
* L'évolution des tâches est suivie par l'un des co-fondateurs, Morten Balle, Product Owner du logiciel Impero, qui veille à ce que le produit reste dans sa vision et atteigne l'objectif définit par la stratégie d'entreprise.

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
  (Slack - MS Teams)     (Clubhouse)      |             relire le code d'une personne       |
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

# Recherche - Couche d'abstraction pour Framework Web

## Contexte et objectif 

Afin de résoudre la problématique d'ouverture de l'API que nous venons d'énoncer, il est important de comprendre le contexte dans lequel le backend est développé, et quels objectifs ce projet de recherche se propose d'atteindre. 

Le travail s'articule autour de l'outil Diesel que nous qualifierons d'ORM[^orm]. Cette librairie ajoute de la sureté lorsque l'on travaille avec du SQL[^sql], uniquement sur les systèmes de gestion de base de données relationnelles, au prix de l'écriture d'un code un peu plus verbeux. Cette sureté se traduit concrètement de la façon suivante : 

* La requête SQL que l'on écrit est vérifiée **statiquement** (comprendre: à la compilation), et est garantie d'être valide. Il n'y a **aucune** possibilité de faire une faute de frappe, de requêter des champs d'une autre table par mégarde, mais surtout lorsqu'une modification est apportée à la structure de la base de données, si la requête devenait invalide, le compilateur en avertirait aussitôt le programmeur ce qui représente un gain de temps et de sécurité non-négligeable. 
* Les structures de données qu'un programmeur écrit sont également vérifiées pour qu'elle puisse accueillir le résultat d'une requête, sans quoi le compilateur bloquera l'éxécution également. 

Comme indiqué précédemment, cet outil a un prix: les structures et les requêtes à écrire sont plutôt verbeuses, et écrire plus de code amènera immédiatement des problèmes de maintenabilité. De plus, il faut également écrire le code de glue entre le serveur HTTP et l'outil Diesel, afin de mettre des actions en face d'une requête HTTP.  

Le projet de recherche s'appelle **PEWS**. C'est un anagramme récursif pour **PEWS: Easy Web Services**. Son but est de faciliter, voire retirer la nécéssité d'écrire cette glue, ce qui permet d'exposer l'interface en écrivant moins de code, et donc d'obtenir une meilleure maintenabilité, et de la rapidité de développement sans pour autant sacrifier les performances de Rust ni la sûreté de Diesel. Il faut voir PEWS comme **une surcouche à un framework Web**, qui aura pour tâche d'écrire l'intégration nécéssaire à la place du développeur. 

Dans un soucis de pérennité, il est prévu de publier la librairie sous une licence Open-Source (type **MIT**), puisqu'il nous a semblé que PEWS correspondait à un besoin de la communauté Rust de manière générale. Afin de favoriser l'utilisation au sein de ladite communauté, et de rendre l'outil le plus flexible et correct possible, il s'agit de faire en sorte que PEWS puisse faire abstraction du framework Web qu'il décore. 

Afin de comprendre comment nous pouvons aborder ce problème, il faut d'abord comprendre le fonctionnement d'un framework web.

[^orm]: Object Relational Mapping, couche logicielle permettant de faciliter l'intéraction avec la base de données.
[^sql]: Structured Query Language, language utilisé pour effectuer des requêtes sur des bases de données relationelles.

## Etat de l'art

### Qu'est ce qu'un Framework Web

Un Framework Web est une brique logicielle permettant d'exposer des fonctionnalités sur un serveur, dans le but de répondre à des requêtes utilisant le protocole de communication client-serveur HTTP (et HTTPS, si celui-ci le supporte), standards du Web.

Le framework a pour but d'exposer des routes, que l'on appelle communément des Endpoints. Par exemple, le site de CPE contient l'article suivant: `https://www.cpe.fr/actualite/actu-chimie-nouveau-diplome-en-chimie/`. Le endpoint qui pourrait être exposé pour accéder à cet article est le suivant: `GET /actualite/<nom_article>`. Elle se décompose de la façon suivante : 

* `GET` est le Verbe HTTP. Il en existe 9 cf. doc mozilla, nous en utilisons communément 5 :  
	* GET - pour récupérer la définition d'une ressource
	* POST - pour créer une ressource 
	* PUT - pour remplacer la ressource par la nouvelle définition que l'on donne 
	* PATCH - pour appliquer des modifications partielles sur une ressource 
	* DELETE - pour supprimer la ressource 
* `/actualite/` est la suite de la route, ou le chemin, auquel l'utilisateur souhaite avoir accès. 
* `<nom_article>` est une notation qui permet d'indiquer que ce qui est à cet endroit de la route est une variable que l'on va devoir traîter côté serveur. Ici, `nom_article = actu-chimie-nouveau-diplome-en-chimie` pourraît être un identifiant qui permettrait de signaler au serveur à quel post du blog nous souhaitons accéder. 

Un Framework web expose donc un moyen de déclarer à quelle "route", ou plutôt "format de route" comme expliqué ci-dessus, nous pouvons répondre. En face de cette route, le serveur doit mettre une logique associée. Dans le cadre de notre exemple, il pourrait s'agir d'aller chercher le titre du blog et son contenu associé dans une base de données, de formatter le contenu, puis de retourner au client une page web valide à afficher sur son navigateur. 

```{.svgbob name="UML - Diagramme de séquence montrant le fonctionnement d'un Endpoint"}

Base de données           Framework Web                           Client 
     _                          _                                    _
     |                          |    GET / actualite / actuXXX       |
     |                        +-+<-----------------------------------|
     |                Routing | |                                    |
     |                        +>|                                    |
     | SELECT ... FROM articles |--+-+----------------+              | 
     | WHERE name = 'actuXXX'   |  |/ Logique interne |              | 
     |<-------------------------+  +------------------+              | 
     | Ok(article)              |                                    | 
     |- - - - - - - - - - - - ->|    Ok(page internet)               | 
     |                          |- - - - - - - - - - - - - - - - - ->| 
     |                          |                                    | 
      
```

Dans ce cas, la logique interne peut valider l'accès d'un client via un cookie ou un header HTTP, puis initier une connection à la base de données, récupérer le contenu de l'article, le formatter et l'afficher. 

Le formattage de la donnée peut varier selon l'architecture du backend, comme dans les cours vus en 4ème année : 

* En Web dynamique, le serveur gèrera le rendu de la page et retournera une page HTML valide,
* En Web statique, la donnée est retournée telle qu'elle, après l'avoir **sérialisée** dans un format compréhensible par le client. 

En Rust, un Framework expose un **Trait** (contrainte similaire à une interface en POO[^poo]) ou une **Structure** qu'il sait transformer en réponse HTTP à renvoyer au client. De cette façon, l'utilisateur du Framework peut retourner ses propres types dont il a défini la conversion en réponse HTTP, ce qui lui donne un contrôle total.  

[^poo]: Programmation Orientée Objet, paradigme de programmation centré sur la définition et l'interaction de briques logicielles appelées objets (Wikipédia). 

Un Framework Web va le plus souvent définir un moyen permettant d'accéder à des ressources internes qu'il pourra partager entre plusieurs requêtes. Par exemple: 
* Un établisseur de connexion à une base de données (comme PostgreSQL), ou à un cache (comme Redis),
* Une variable dont le contenu peut être utilisé par les routes, comme une constante par exemple, ou le contenu d'un fichier de configuration, 
* Un accès à un système de journalisation (logs),
* Une brique logicielle permettant de gérer l'autorisation ou l'authentification d'un utilisateur. 

Pour comprendre le travail d'abstraction, de PEWS il s'agit ensuite d'étudier au cas par cas les différents Framework Web existants dans l'écosystème Rust, dans le but de comprendre comment chacun gère : 

* La déclaration d'une route et le routing, 
* La réponse à un client,
* Le partage de ressources en interne,

Et ainsi de savoir comment exposer les fonctionnalités de chacun. Nous étudierons donc le fonctionnement des deux frameworks majeurs, et d'un troisième dont l'approche plus proche du paradigme de programmation fonctionnelle est intéressante. 

### Premier cas d'étude : Rocket

Rocket est un framework qu'on peut considérer comme l'un des plus matures de l'écosystème Rust. C'est celui que l'entreprise utilise pour développer le backend de la solution Impero. 

Selon son site internet : 

> Rocket est un framework web écrit avec Rust, qui permet d'écrire des applications Web rapides et sécurisées sans sacrifier la flexibilité, l'utilisabilité ni la sûreté.

La particularité de Rocket est qu'il utilise la chaine de compilation Rust **nightly** (comprendre: instable), qui lui permet d'accéder à certaines fonctionnalités des macros procédurales du langage, au prix de l'utilisation d'un chaîne Rust qui peut potentiellement casser d'une semaine à l'autre. Ce n'est pas nécéssairement un désavantage, il n'y a pas eu de problème de ce genre pour l'instant, et celui-ci serait de toute façon contournable simplement.  

L'utilisation des macros procédurales permet à l'utilisateur d'être très expressif dans la définition des routes : 

```rust
#[get("/hello/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}
```
Note pour la compréhension:

* u8 est un entier non-signé codé sur 8 bits (valeurs dans l'intervalle 0 -> 255).
* `format!()` est une macro formattant le contenu comme une variable de type String. 
* Ici, pour un client qui envoie une requête sur `GET /hello/Olivier/22`, on retourne `Hello, 22 year old named Olivier!`.

Comme on peut le constater, on trouve ici la définition du verbe HTTP, de la route, et de la logique interne associée, ici le formattage de la réponse en String. 

Rocket définit un système de "Gardes de requête" pour accéder à des ressources internes. Ceux-ci permettent de tirer avantage de la sureté apportée par Rust pour écrire des services Web qui seront plus résistants aux erreurs. Dans l'exemple précédent, l'âge est de type `u8`. Si un client envoyait la requête `GET /hello/Olivier/abc`, abc n'étant pas transformable en un nombre compris entre 0 et 255, la requête doit échouer. Rocket effectue cette analyse tout seul, se rend compte que la transformation a échoué, et continue à chercher une autre route qui correspond à ce que l'utilisateur a demandé. Eventuellement, si le serveur ne définit pas de route qui correspond, il retournera le code d'erreur HTTP `404 Not Found`.

Les gardes sont appellés sous la forme d'un type que l'on donne en paramètre d'une fonction, puis grâce à ses macros procédurales, Rocket se charge d'écrire tout seul le code permettant d'appliquer le comportement de ceux-ci. 

### Second cas d'étude : Actix-Web

### Troisième cas d'étude : Warp

### Comparaison 

Suite à ces trois études de cas, on peut tirer le tableau suivant : 

| Framework | Création de route                    | Type de réponse   | Partage de ressource | Synchrone            |
|:---------:|:------------------------------------:|:-----------------:|:--------------------:|:--------------------:|
| Rocket    | Macro procédurale                    | Trait "Responder" | Gardes de requête    | Oui (pour l'instant) |
| Actix-web | Manuelle ou Macro procédurale        | Trait "Responder" | Gardes de requête    | Non                  |
| Warp      | Manuelle ou Macro                    | Struct Reply      | Filtre associé       | Non                  |

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


