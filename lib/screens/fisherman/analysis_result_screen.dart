import 'dart:io';
import 'package:flutter/material.dart';
import 'package:peche_app/utils/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnalysisResultScreen extends StatefulWidget {
  final File imageFile;
  final String species;

  const AnalysisResultScreen({
    super.key,
    required this.imageFile,
    required this.species,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour les champs de formulaire
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedFishingMethod = 'Canne à pêche';
  final List<String> _fishingMethods = [
    'Canne à pêche',
    'Filet',
    'Ligne de traîne',
    'Palangre',
    'Autre'
  ];
  
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat de l\'analyse'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image et espèce identifiée
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.file(
                        widget.imageFile,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Espèce identifiée:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.species,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Informations générales sur l'espèce
              const Text(
                'Informations sur cette espèce',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Taille moyenne',
                        '40-65 cm',
                        Icons.straighten,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Habitat',
                        'Eaux côtières, estuaires',
                        Icons.water,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Réglementation',
                        'Taille min: 36 cm',
                        Icons.gavel,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Formulaire pour ajouter des détails
              const Text(
                'Ajouter des détails sur votre capture',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Champ de poids
                        TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Poids (kg)',
                            prefixIcon: Icon(Icons.monitor_weight),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer le poids';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Champ de taille
                        TextFormField(
                          controller: _lengthController,
                          decoration: const InputDecoration(
                            labelText: 'Taille (cm)',
                            prefixIcon: Icon(Icons.straighten),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer la taille';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Champ de localisation
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Localisation',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer la localisation';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Méthode de pêche (dropdown)
                        DropdownButtonFormField<String>(
                          value: _selectedFishingMethod,
                          decoration: InputDecoration(
                            labelText: 'Méthode de pêche',
                            // Remplacer Icon par FaIcon
                            prefixIcon: FaIcon(FontAwesomeIcons.fish),
                          ),
                          items: _fishingMethods.map((String method) {
                            return DropdownMenuItem<String>(
                              value: method,
                              child: Text(method),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFishingMethod = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bouton d'enregistrement
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSubmitting
                        ? 'Enregistrement...'
                        : 'Enregistrer et partager',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simuler un délai d'enregistrement
      await Future.delayed(const Duration(seconds: 2));

      // Dans une application réelle, vous enverriez ces données à votre backend
      // pour les enregistrer dans une base de données

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capture enregistrée avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      // Retourner à l'écran principal
      Navigator.popUntil(
        context,
        ModalRoute.withName('/'), // Retour à la racine
      );
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lengthController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}

