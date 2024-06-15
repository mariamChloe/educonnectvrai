// enseignantsController.js
const express = require('express');
const EnseignantsServices = require("../services/enseignants.services");
const { validationResult } = require('express-validator');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Enseignants = require('../models/enseignants'); // Assurez-vous que le chemin du modèle est correct
const dbClient = require ('../config/db');

// Endpoint pour l'authentification des enseignants
router.post('/login', async (req, res) => {
  const { matricule, password } = req.body;

  try {
    // Vérifier si l'enseignant existe avec le matricule donné1

    const enseignant = await Enseignants.findOne({ matricule,password });

    if (!enseignant) {
      return res.status(401).json({ error: 'Matricule incorrect' });
    }

    // Vérifier si le mot de passe est correct
    const passwordMatch = await bcrypt.compare(password, enseignant.password);

   if (passwordMatch) {
      return res.status(401).json({ error: 'Mot de passe incorrect' });
    }

    // Générer un jeton d'authentification
    const token = jwt.sign({ id: enseignant._id, matricule: enseignant.matricule }, 'secret_key'); // Remplacez 'secret_key' par une clé secrète robuste

    res.json({ token });
  } catch (error) {
    console.error('Erreur d\'authentification :', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});
exports.login = async(req,res,next)=>{
    try {
        const { matricule,password} = req.body;
        const enseignants = EnseignantsServices.cheickenseignants(matricule);
        if(!enseignants) {
            throw new Error ('Enseignats n existe pas');
        }

    } catch(error) {
        throw error
    }
}
router.post('/register-enseignant-by-admin', async (req, res) => {
  try {
    const { matricule, password, otherEnseignantData } = req.body;

    // You may want to add validation for matricule, password, and other data

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create the teacher
    const enseignant = await Enseignants.create({
      matricule,
      password: hashedPassword,
      otherEnseignantData,
    });

    res.json({ message: 'Enseignant registered successfully', enseignant });
  } catch (error) {
    console.error('Error registering enseignant by admin:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ... (existing code)


// Autres routes et opérations CRUD pour les enseignants

module.exports = router;
