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

* définition de tous les pôles
* focus pôle développement 
* le télétravail 

## Méthode de travail 

* Méthode agile
* Outils de gestion de projet
* tâche de spécification avec PO et UX 

## Environnement technique

L'entreprise Impero déploie sa solution Web sur un serveur à l'aide d'`Ansible`, un outil open-source permettant la mise en production, qui est gérée manuellement par le CTO et le lead développeur. 

L'architecture du logiciel est composée d'un serveur, que nous appelerons "backend" et qui héberge une application Web, que nous appelerons "frontend". 

Le backend est implémenté avec le langage de programmation **Rust**, qui vise à permettre à tout développeur de fournir des programmes sécurisés et performants, tirant avantage des technologies modernes (comme le multithreading) tout en leur offrant beaucoup d'outils pour se faciliter la tâche. Rust est un langage dit "système" capable de cibler toutes les plateformes allant d'Android au Web (via WebAssembly) en passant par les OS plus conventionnels, et même l'embarqué. Celui-ci est multi-paradigme (on peut s'en servir comme d'un language fonctionnel, impératif, voire même orienté objet sur certains aspects). A titre personnel, c'est une technologie avec laquelle j'ai beaucoup de plaisir à travailler car son compilateur strict empêche beaucoup d'erreurs avant qu'elles n'arrivent en production, ou qu'elles ne proviennent d'une mauvaise architecture du programme que j'écris. 

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

* afin de résoudre la problématique d'API
* utilisation Diesel 
* but: 
	* abstraire la logique de fonctionnement des frameworks = flexibilité + open-source 
	* réduire le code à écrire = meilleure maintenabilité + rapidité 

## Etat de l'art

### Qu'est ce qu'un Framework Web

### Solutions existantes

* Rocket: approche avec guards. sync.
* actix-web: guards + acteurs en interne. async.
* warp: filters. async.
* Autres = références

## Abstraction de Framework Web 

### L'abstraction de Route - Endpoint

### L'abstraction Repository

### Le montage des routes  

## L'interface utilisateur de la librairie

ref: Guidelines Rust

```{.svgbob}
+------+   +------+
| Tes  |---| Good |
+------+   +------+
```

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


