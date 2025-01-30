#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/velo/show')              # remplace /client
def client_velo_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']

    # Récupérer la liste des types de vélos pour les filtres
    sql_type_velo = "SELECT * FROM type_velo"
    mycursor.execute(sql_type_velo)
    type_velo = mycursor.fetchall()

    # Vérifier s'il y a des filtres actifs en session
    filter_word = session.get('filter_word')
    filter_prix_min = session.get('filter_prix_min')
    filter_prix_max = session.get('filter_prix_max')
    filter_types = session.get('filter_types')

    # Construire la requête SQL pour filtrer les vélos
    sql = "SELECT * FROM velo WHERE 1=1"
    params = []

    if filter_word:
        sql += " AND nom_velo LIKE %s"
        params.append(f"%{filter_word}%")

    if filter_prix_min:
        sql += " AND prix_velo >= %s"
        params.append(float(filter_prix_min))

    if filter_prix_max:
        sql += " AND prix_velo <= %s"
        params.append(float(filter_prix_max))

    if filter_types:
        placeholders = ','.join(['%s'] * len(filter_types))
        sql += f" AND type_velo_id IN ({placeholders})"
        params.extend(filter_types)

    mycursor.execute(sql, params)
    velos = mycursor.fetchall()

    # Récupérer les articles du panier
    sql_articles_panier = '''
        SELECT velo.*, ligne_panier.quantite
        FROM velo
        JOIN ligne_panier ON velo.id_velo = ligne_panier.velo_id
        WHERE ligne_panier.utilisateur_id = %s
    '''
    mycursor.execute(sql_articles_panier, (id_client,))
    articles_panier = mycursor.fetchall()

    # Calculer le prix total du panier
    prix_total = sum(velo['prix_velo'] * velo['quantite'] for velo in articles_panier)

    return render_template('client/boutique/panier_velo.html',
                           velos=velos,
                           articles_panier=articles_panier,
                           prix_total=prix_total,
                           items_filtre=type_velo)
