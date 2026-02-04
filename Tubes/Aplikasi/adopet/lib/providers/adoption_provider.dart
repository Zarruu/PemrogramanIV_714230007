import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/adoption.dart';
import '../models/user_notification.dart';

class AdoptionProvider with ChangeNotifier {
  List<Adoption> _adoptions = [];
  List<UserNotification> _notifications = [];
  int _idCounter = 1;
  int _notifIdCounter = 1;

  List<Adoption> get adoptions => _adoptions;
  List<UserNotification> get notifications => _notifications;
  
  List<Adoption> get pendingAdoptions => 
      _adoptions.where((a) => a.status == 'pending').toList();
  
  int get pendingCount => pendingAdoptions.length;

  // Get user's notifications
  List<UserNotification> getNotificationsForUser(String username) =>
      _notifications.where((n) => n.username == username).toList();
  
  int getUnreadCountForUser(String username) =>
      _notifications.where((n) => n.username == username && !n.isRead).length;

  AdoptionProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load adoptions
    final adoptionsJson = prefs.getString('adoptions');
    if (adoptionsJson != null && adoptionsJson.isNotEmpty) {
      _adoptions = Adoption.decode(adoptionsJson);
      if (_adoptions.isNotEmpty) {
        _idCounter = int.parse(_adoptions.first.id ?? '0') + 1;
      }
    }
    
    // Load notifications
    final notifsJson = prefs.getString('notifications');
    if (notifsJson != null && notifsJson.isNotEmpty) {
      _notifications = UserNotification.decode(notifsJson);
      if (_notifications.isNotEmpty) {
        _notifIdCounter = int.parse(_notifications.first.id) + 1;
      }
    }
    
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adoptions', Adoption.encode(_adoptions));
    await prefs.setString('notifications', UserNotification.encode(_notifications));
  }

  void addAdoption(Adoption adoption) {
    final newAdoption = adoption.copyWith(id: (_idCounter++).toString());
    _adoptions.insert(0, newAdoption);
    _saveData();
    notifyListeners();
  }

  void approveAdoption(String id) {
    final index = _adoptions.indexWhere((a) => a.id == id);
    if (index != -1) {
      final adoption = _adoptions[index];
      _adoptions[index] = adoption.copyWith(status: 'approved');
      
      // Create notification for user
      _createNotification(
        adoption.applicantUsername,
        'Adoption Approved! 🎉',
        'Congratulations! Your request to adopt ${adoption.petName} has been approved. Please contact us for next steps.',
        'approved',
        adoption.petName,
      );
      
      _saveData();
      notifyListeners();
    }
  }

  void rejectAdoption(String id) {
    final index = _adoptions.indexWhere((a) => a.id == id);
    if (index != -1) {
      final adoption = _adoptions[index];
      _adoptions[index] = adoption.copyWith(status: 'rejected');
      
      // Create notification for user
      _createNotification(
        adoption.applicantUsername,
        'Adoption Request Update',
        'We\'re sorry, your request to adopt ${adoption.petName} was not approved at this time. Please consider adopting another pet!',
        'rejected',
        adoption.petName,
      );
      
      _saveData();
      notifyListeners();
    }
  }

  void _createNotification(String username, String title, String message, String type, String petName) {
    final notif = UserNotification(
      id: (_notifIdCounter++).toString(),
      username: username,
      title: title,
      message: message,
      type: type,
      petName: petName,
    );
    _notifications.insert(0, notif);
  }

  void markNotificationAsRead(String notifId) {
    final index = _notifications.indexWhere((n) => n.id == notifId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _saveData();
      notifyListeners();
    }
  }

  void markAllAsReadForUser(String username) {
    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].username == username && !_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _saveData();
    notifyListeners();
  }

  List<Adoption> getAdoptionsByStatus(String status) {
    return _adoptions.where((a) => a.status == status).toList();
  }

  List<Adoption> getAdoptionsForUser(String username) {
    return _adoptions.where((a) => a.applicantUsername == username).toList();
  }
}
