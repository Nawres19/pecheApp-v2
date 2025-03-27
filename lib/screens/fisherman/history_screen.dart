import 'package:flutter/material.dart';
import 'package:peche_app/utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'Tous';
  final List<String> _filterOptions = [
    'Tous',
    'Ce mois',
    'Bar',
    'Dorade',
    'Maquereau',
  ];

  // Données simulées pour l'historique des captures
  final List<Map<String, dynamic>> _captures = [
    {
      'id': '1',
      'species': 'Bar commun',
      'weight': 2.5,
      'length': 45.0,
      'location': 'Côte atlantique',
      'fishingMethod': 'Canne à pêche',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'imageUrl':
          'https://images.unsplash.com/photo-1545816250-e12bedba42ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    },
    {
      'id': '2',
      'species': 'Dorade royale',
      'weight': 1.8,
      'length': 35.0,
      'location': 'Méditerranée',
      'fishingMethod': 'Filet',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'imageUrl':
          'https://images.unsplash.com/photo-1579168765467-3b235f938439?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    },
    {
      'id': '3',
      'species': 'Maquereau',
      'weight': 0.9,
      'length': 28.0,
      'location': 'Manche',
      'fishingMethod': 'Ligne de traîne',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'imageUrl':
          'https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    },
    {
      'id': '4',
      'species': 'Bar commun',
      'weight': 3.2,
      'length': 52.0,
      'location': 'Golfe de Gascogne',
      'fishingMethod': 'Canne à pêche',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'imageUrl':
          'https://images.unsplash.com/photo-1534043464124-3be32fe000c9?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    },
  ];

  List<Map<String, dynamic>> get _filteredCaptures {
    if (_selectedFilter == 'Tous') {
      return _captures;
    } else if (_selectedFilter == 'Ce mois') {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      return _captures
          .where(
            (capture) =>
                capture['date'].isAfter(firstDayOfMonth) ||
                capture['date'].isAtSameMomentAs(firstDayOfMonth),
          )
          .toList();
    } else {
      return _captures
          .where(
            (capture) => capture['species'].toLowerCase().contains(
              _selectedFilter.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des captures'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrer par:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _filterOptions.map((filter) {
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: AppTheme.primaryColor.withOpacity(
                                0.2,
                              ),
                              checkmarkColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.textColor,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Liste des captures
          Expanded(
            child:
                _filteredCaptures.isEmpty
                    ? const Center(
                      child: Text(
                        'Aucune capture trouvée',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredCaptures.length,
                      itemBuilder: (context, index) {
                        final capture = _filteredCaptures[index];
                        return _buildCaptureCard(capture);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureCard(Map<String, dynamic> capture) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(capture['date']);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du poisson
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                capture['imageUrl'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Informations sur la capture
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        capture['species'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildCaptureInfo(
                        'Poids',
                        '${capture['weight']} kg',
                        Icons.monitor_weight,
                      ),
                      const SizedBox(width: 16),
                      _buildCaptureInfo(
                        'Taille',
                        '${capture['length']} cm',
                        Icons.straighten,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildCaptureInfo(
                    'Lieu',
                    capture['location'],
                    Icons.location_on,
                  ),
                  const SizedBox(height: 8),
                  _buildCaptureInfo(
                    'Méthode',
                    capture['fishingMethod'],
                    FontAwesomeIcons.fish,
                  ),
                  const SizedBox(height: 12),

                  // Boutons d'action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Logique pour modifier
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Modifier'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Logique pour supprimer
                          _showDeleteConfirmation(context, capture);
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Supprimer'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> capture,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer cette capture de ${capture['species']} ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Logique pour supprimer la capture
                setState(() {
                  _captures.removeWhere((item) => item['id'] == capture['id']);
                });
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Capture supprimée avec succès'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
