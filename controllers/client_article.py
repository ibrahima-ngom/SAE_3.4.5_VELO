#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')              # remplace /client
def client_article_show():                                 # remplace client_index
    mycursor = get_db().cursor()
    id_client = session['id_user']

    sql = '''SELECT v.id_velo AS id_article, v.nom_velo AS nom, v.prix_velo AS prix,
            v.taille_id, v.type_velo_id, v.matiere, v.description, v.fournisseur, v.marque, v.image,
            COUNT(d.id_declinaison) as nb_declinaisons,
            GROUP_CONCAT(
                CONCAT(
                    d.id_declinaison, '|',
                    COALESCE(c.libelle, ''), '|',
                    COALESCE(t.libelle, ''), '|',
                    d.stock
                ) SEPARATOR ';;'
            ) as declinaisons_info
            FROM velo v
            LEFT JOIN declinaison d ON v.id_velo = d.velo_id
            LEFT JOIN couleur c ON d.couleur_id = c.id_couleur
            LEFT JOIN taille t ON d.taille_id = t.id_taille
            GROUP BY v.id_velo, v.nom_velo, v.prix_velo, v.taille_id, v.type_velo_id, v.matiere, v.description, v.fournisseur, v.marque, v.image'''
    mycursor.execute(sql)
    articles = mycursor.fetchall()
    list_param = []
    condition_and = ""
    # utilisation du filtre
    sql3=''' prise en compte des commentaires et des notes dans le SQL    '''

    sql = '''SELECT DISTINCT t.id_type_velo AS id_type_article, t.libelle_type_velo AS libelle 
             FROM type_velo t
             INNER JOIN velo v ON t.id_type_velo = v.type_velo_id'''
    mycursor.execute(sql)

    # pour le filtre
    types_article = mycursor.fetchall()


    articles_panier = []

    if len(articles_panier) >= 1:
        sql = ''' calcul du prix total du panier '''
        prix_total = None
    else:
        prix_total = None
    return render_template('client/boutique/panier_article.html'
                           , articles=articles
                           , articles_panier=articles_panier
                           #, prix_total=prix_total
                           , items_filtre=types_article
                           )