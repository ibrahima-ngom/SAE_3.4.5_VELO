#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                        template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article')
    quantite = request.form.get('quantite')
    id_declinaison_article = request.form.get('id_declinaison_article', None)

    # Récupération des déclinaisons de l'article
    sql = '''SELECT d.id_declinaison as id_declinaison_article, d.stock, c.id_couleur, c.libelle_couleur, t.id_taille, t.libelle_taille
             FROM declinaison d
             LEFT JOIN couleur c ON d.couleur_id = c.id_couleur
             LEFT JOIN taille t ON d.taille_id = t.id_taille
             WHERE d.velo_id = %s'''
    mycursor.execute(sql, (id_article,))
    declinaisons = mycursor.fetchall()
    
    # Si l'article n'a qu'une seule déclinaison, on l'ajoute directement au panier
    if len(declinaisons) == 1:
        id_declinaison_article = declinaisons[0]['id_declinaison_article']
        # Vérification que la déclinaison a du stock
        if declinaisons[0]['stock'] >= int(quantite):
            # Décrémentation du stock
            sql = '''UPDATE declinaison SET stock = stock - %s WHERE id_declinaison = %s'''
            mycursor.execute(sql, (quantite, id_declinaison_article))
            
            # Ajout au panier
            sql = '''INSERT INTO ligne_panier (utilisateur_id, article_id, id_declinaison, quantite, date_ajout) 
                     VALUES (%s, %s, %s, %s, NOW())'''
            mycursor.execute(sql, (id_client, id_article, id_declinaison_article, quantite))
            get_db().commit()
            flash("Article ajouté au panier", "alert-success")
            return redirect('/client/article/show')
        else:
            flash("Stock insuffisant pour cette déclinaison", "alert-warning")
            return redirect('/client/article/show')
    # Si l'article n'a pas de déclinaison
    elif len(declinaisons) == 0:
        flash("Aucune déclinaison disponible pour cet article", "alert-warning")
        return redirect('/client/article/show')
    # Si l'article a plusieurs déclinaisons, on redirige vers la page de sélection
    else:
        # Si une déclinaison a été sélectionnée, on l'ajoute au panier
        if id_declinaison_article:
            # Vérification que la déclinaison existe et a du stock
            sql = '''SELECT stock FROM declinaison WHERE id_declinaison = %s AND velo_id = %s'''
            mycursor.execute(sql, (id_declinaison_article, id_article))
            declinaison = mycursor.fetchone()
            
            if declinaison and declinaison['stock'] >= int(quantite):
                # Décrémentation du stock
                sql = '''UPDATE declinaison SET stock = stock - %s WHERE id_declinaison = %s'''
                mycursor.execute(sql, (quantite, id_declinaison_article))
                
                # Ajout au panier
                sql = '''INSERT INTO ligne_panier (utilisateur_id, article_id, id_declinaison, quantite, date_ajout) 
                         VALUES (%s, %s, %s, %s, NOW())'''
                mycursor.execute(sql, (id_client, id_article, id_declinaison_article, quantite))
                get_db().commit()
                flash("Article ajouté au panier", "alert-success")
                return redirect('/client/article/show')
            else:
                flash("Stock insuffisant pour cette déclinaison", "alert-warning")
                return redirect('/client/article/show')
        else:
            # Sinon, on affiche la page de sélection de déclinaison
            sql = '''SELECT * FROM velo WHERE id_velo = %s'''
            mycursor.execute(sql, (id_article,))
            article = mycursor.fetchone()
            return render_template('client/boutique/declinaison_article.html',
                                   declinaisons=declinaisons,
                                   quantite=quantite,
                                   article=article)

    return redirect('/client/article/show')

@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article','')
    quantite = 1

    # Récupération de la ligne du panier pour l'article et l'utilisateur connecté
    sql = '''SELECT lp.quantite, lp.id_declinaison
             FROM ligne_panier lp
             WHERE lp.utilisateur_id = %s AND lp.article_id = %s'''
    mycursor.execute(sql, (id_client, id_article))
    article_panier = mycursor.fetchone()

    if article_panier:
        if article_panier['quantite'] > 1:
            # Mise à jour de la quantité dans le panier => -1 article
            sql = '''UPDATE ligne_panier SET quantite = quantite - 1 
                     WHERE utilisateur_id = %s AND article_id = %s'''
            mycursor.execute(sql, (id_client, id_article))
            
            # Incrémentation du stock de la déclinaison
            sql = '''UPDATE declinaison SET stock = stock + 1 
                     WHERE id_declinaison = %s'''
            mycursor.execute(sql, (article_panier['id_declinaison'],))
        else:
            # Suppression de la ligne de panier
            sql = '''DELETE FROM ligne_panier 
                     WHERE utilisateur_id = %s AND article_id = %s'''
            mycursor.execute(sql, (id_client, id_article))
            
            # Incrémentation du stock de la déclinaison
            sql = '''UPDATE declinaison SET stock = stock + %s 
                     WHERE id_declinaison = %s'''
            mycursor.execute(sql, (article_panier['quantite'], article_panier['id_declinaison']))
        
        get_db().commit()
        flash("Article retiré du panier", "alert-success")
    else:
        flash("Article non trouvé dans le panier", "alert-warning")
    
    return redirect('/client/article/show')





@client_panier.route('/client/panier/vider', methods=['POST'])
def client_panier_vider():
    mycursor = get_db().cursor()
    client_id = session['id_user']
    
    # Sélection des lignes de panier
    sql = '''SELECT lp.article_id, lp.quantite, lp.id_declinaison
             FROM ligne_panier lp
             WHERE lp.utilisateur_id = %s'''
    mycursor.execute(sql, (client_id,))
    items_panier = mycursor.fetchall()
    
    if items_panier:
        for item in items_panier:
            # Incrémentation du stock de la déclinaison
            sql = '''UPDATE declinaison SET stock = stock + %s 
                     WHERE id_declinaison = %s'''
            mycursor.execute(sql, (item['quantite'], item['id_declinaison']))
        
        # Suppression de toutes les lignes du panier
        sql = '''DELETE FROM ligne_panier WHERE utilisateur_id = %s'''
        mycursor.execute(sql, (client_id,))
        
        get_db().commit()
        flash("Panier vidé", "alert-success")
    else:
        flash("Panier déjà vide", "alert-warning")
    
    return redirect('/client/article/show')


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article', None)

    if id_article:
        # Récupération de la ligne du panier
        sql = '''SELECT lp.quantite, lp.id_declinaison
                 FROM ligne_panier lp
                 WHERE lp.utilisateur_id = %s AND lp.article_id = %s'''
        mycursor.execute(sql, (id_client, id_article))
        ligne_panier = mycursor.fetchone()

        if ligne_panier:
            # Suppression de la ligne du panier
            sql = '''DELETE FROM ligne_panier 
                     WHERE utilisateur_id = %s AND article_id = %s'''
            mycursor.execute(sql, (id_client, id_article))
            
            # Incrémentation du stock de la déclinaison
            sql = '''UPDATE declinaison SET stock = stock + %s 
                     WHERE id_declinaison = %s'''
            mycursor.execute(sql, (ligne_panier['quantite'], ligne_panier['id_declinaison']))
            
            get_db().commit()
            flash("Article retiré du panier", "alert-success")
        else:
            flash("Article non trouvé dans le panier", "alert-warning")
    else:
        flash("Article non spécifié", "alert-warning")
    
    return redirect('/client/article/show')


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    filter_word = request.form.get('filter_word', None)
    filter_prix_min = request.form.get('filter_prix_min', None)
    filter_prix_max = request.form.get('filter_prix_max', None)
    filter_types = request.form.getlist('filter_types', None)
    # test des variables puis
    # mise en session des variables
    return redirect('/client/article/show')


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    # suppression  des variables en session
    print("suppr filtre")
    return redirect('/client/article/show')
