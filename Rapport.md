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
footer-left: Olivier PINON - 4IRC
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

## Environnement technique, problématique à résoudre

* Rust + Rocket 
* TypeScript / React
* Docker
* Ansible
* Problématique APIs 

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

## Abstraction d'un Framework Web 

### L'abstraction de Route - Endpoint

### L'abstraction Repository

### Le montage des routes  

## L'interface utilisateur d'une librairie

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


