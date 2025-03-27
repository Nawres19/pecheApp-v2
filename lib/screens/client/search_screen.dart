import 'package:flutter/material.dart';
import 'package:peche_app/utils/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  // Données simulées pour les résultats de recherche
  final List<Map<String, dynamic>> _allFish = [
    {
      'id': '1',
      'species': 'Bar commun',
      'scientificName': 'Dicentrarchus labrax',
      'weight': 2.5,
      'length': 45.0,
      'location': 'Côte atlantique',
      'fishingMethod': 'Canne à pêche',
      'date': '15/03/2025',
      'fisherman': 'Pierre Dupont',
      'fishermanRating': 4.8,
      'fishermanCertified': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1545816250-e12bedba42ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': '2',
      'species': 'Dorade royale',
      'scientificName': 'Sparus aurata',
      'weight': 1.8,
      'length': 35.0,
      'location': 'Méditerranée',
      'fishingMethod': 'Filet',
      'date': '14/03/2025',
      'fisherman': 'Marie Laurent',
      'fishermanRating': 4.5,
      'fishermanCertified': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1579168765467-3b235f938439?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': '3',
      'species': 'Maquereau',
      'scientificName': 'Scomber scombrus',
      'weight': 0.9,
      'length': 28.0,
      'location': 'Manche',
      'fishingMethod': 'Ligne de traîne',
      'date': '13/03/2025',
      'fisherman': 'Jean Martin',
      'fishermanRating': 4.2,
      'fishermanCertified': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': '4',
      'species': 'Sole',
      'scientificName': 'Solea solea',
      'weight': 1.2,
      'length': 32.0,
      'location': 'Golfe de Gascogne',
      'fishingMethod': 'Chalut',
      'date': '12/03/2025',
      'fisherman': 'Pierre Dupont',
      'fishermanRating': 4.8,
      'fishermanCertified': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1559589290-0da9bc7d1df7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    },
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simuler un délai de recherche
    Future.delayed(const Duration(milliseconds: 500), () {
      final results =
          _allFish.where((fish) {
            return fish['species'].toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                fish['scientificName'].toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                fish['fisherman'].toLowerCase().contains(query.toLowerCase());
          }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un poisson ou un pêcheur...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _performSearch,
            ),
          ),

          // Résultats de recherche
          Expanded(
            child:
                _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? _searchController.text.isEmpty
                        ? _buildSearchSuggestions()
                        : const Center(
                          child: Text(
                            'Aucun résultat trouvé',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                    : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final fish = _searchResults[index];
                        return _buildFishResultCard(fish);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestions de recherche',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('Bar'),
              _buildSuggestionChip('Dorade'),
              _buildSuggestionChip('Maquereau'),
              _buildSuggestionChip('Sole'),
              _buildSuggestionChip('Thon'),
              _buildSuggestionChip('Sardine'),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Recherches populaires',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildPopularSearchItem(
            'Bar commun',
            'Poisson de mer très apprécié',
            Icons.trending_up,
          ),
          _buildPopularSearchItem(
            'Poissons de saison',
            'Découvrez les poissons du moment',
            Icons.calendar_today,
          ),
          _buildPopularSearchItem(
            'Pêcheurs certifiés',
            'Garantie de qualité et de fraîcheur',
            Icons.verified,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _performSearch(label);
      },
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildPopularSearchItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textColor,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: () {
        _searchController.text = title;
        _performSearch(title);
      },
    );
  }

  Widget _buildFishResultCard(Map<String, dynamic> fish) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du poisson
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              fish['imageUrl'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Informations sur le poisson
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fish['species'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Disponible',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  fish['scientificName'],
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                // Détails du poisson
                Row(
                  children: [
                    _buildDetailItem(
                      'Poids',
                      '${fish['weight']} kg',
                      Icons.monitor_weight,
                    ),
                    const SizedBox(width: 24),
                    _buildDetailItem(
                      'Taille',
                      '${fish['length']} cm',
                      Icons.straighten,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildDetailItem(
                      'Lieu',
                      fish['location'],
                      Icons.location_on,
                    ),
                    const SizedBox(width: 24),
                    _buildDetailItem(
                      'Date',
                      fish['date'],
                      Icons.calendar_today,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDetailItem(
                  'Méthode',
                  fish['fishingMethod'],
                  // Remplacer Icons.fishing par FaIcon
                  FontAwesomeIcons.fish,
                ),

                const Divider(height: 32),

                // Informations sur le pêcheur
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pêcheur:',
                      style: TextStyle(fontSize: 16, color: AppTheme.textColor),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fish['fisherman'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    if (fish['fishermanCertified']) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      fish['fishermanRating'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Contacter le pêcheur
                        },
                        icon: const Icon(Icons.message),
                        label: const Text('Contacter'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Trouver un point de vente
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Acheter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        // Si c'est une icône FontAwesome
        icon == FontAwesomeIcons.fish
            ? FaIcon(icon, size: 16, color: AppTheme.primaryColor)
            : Icon(icon, size: 16, color: AppTheme.primaryColor),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
