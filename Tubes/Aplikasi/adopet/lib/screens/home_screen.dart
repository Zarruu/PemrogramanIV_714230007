import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/adoption_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';
import '../widgets/pet_card.dart';
import '../utils/constants.dart';
import 'add_edit_pet_screen.dart';
import 'adoption_form_screen.dart';
import 'adoption_requests_screen.dart';
import 'user_notifications_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().fetchPets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<PetProvider>().clearSearch();
      }
    });
  }

  void _showDeleteDialog(String petId, String petName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Delete Pet'),
          ],
        ),
        content: Text('Are you sure you want to delete "$petName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<PetProvider>().deletePet(petId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Pet deleted successfully' : 'Failed to delete pet',
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _buildPetList() {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        if (petProvider.isLoading && petProvider.pets.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Loading pets...'),
              ],
            ),
          );
        }

        if (petProvider.error != null && petProvider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  'Failed to load pets',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => petProvider.fetchPets(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        if (petProvider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, size: 80, color: AppColors.primaryLight),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noPetsFound,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAdmin ? 'Tap the + button to add a pet' : 'Check back later for new pets!',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => petProvider.fetchPets(),
          color: AppColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: petProvider.pets.length,
            itemBuilder: (context, index) {
              final pet = petProvider.pets[index];
              return PetCard(
                pet: pet,
                isAdmin: isAdmin,
                onEdit: isAdmin
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditPetScreen(pet: pet),
                          ),
                        )
                    : null,
                onDelete: isAdmin ? () => _showDeleteDialog(pet.id!, pet.name) : null,
                onAdopt: !isAdmin
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdoptionFormScreen(pet: pet),
                          ),
                        )
                    : null,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildPetList();
      case 1:
        return const ProfileScreen();
      case 2:
        return const AboutScreen();
      default:
        return _buildPetList();
    }
  }

  Widget _buildNotificationBadge(int count, Widget icon, VoidCallback onPressed) {
    return Stack(
      children: [
        IconButton(icon: icon, onPressed: onPressed),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 9 ? '9+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final username = context.watch<AuthProvider>().name;
    final currentUsername = context.watch<AuthProvider>().username;
    final adoptionProvider = context.watch<AdoptionProvider>();
    
    // Get notification count based on role
    final notificationCount = isAdmin
        ? adoptionProvider.pendingCount
        : adoptionProvider.getUnreadCountForUser(currentUsername);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isAdmin ? AppColors.secondary : AppColors.primary,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                onChanged: (value) => context.read<PetProvider>().searchPets(value),
              )
            : Row(
                children: [
                  Text(
                    _currentIndex == 0
                        ? AppStrings.appName
                        : _currentIndex == 1
                            ? AppStrings.profile
                            : AppStrings.about,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  if (_currentIndex == 0 && isAdmin) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ADMIN',
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
        actions: _currentIndex == 0
            ? [
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: _toggleSearch,
                ),
                // Notification badge
                _buildNotificationBadge(
                  notificationCount,
                  const Icon(Icons.notifications),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isAdmin
                          ? const AdoptionRequestsScreen()
                          : const UserNotificationsScreen(),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'logout') _logout();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            isAdmin ? 'Administrator' : 'User',
                            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: _buildBody(),
      floatingActionButton: _currentIndex == 0 && isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditPetScreen()),
              ),
              backgroundColor: AppColors.secondary,
              icon: const Icon(Icons.add),
              label: const Text('Add Pet'),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: isAdmin ? AppColors.secondary : AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}
