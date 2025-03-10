import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/services/log_service.dart';
import 'package:shop_management_system/widgets/dialogs/custom_dialog.dart';

enum NetworkStatus {
  online,
  offline,
}

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  // Observable network status
  final _status = NetworkStatus.online.obs;
  final _connectionType = ConnectivityResult.none.obs;
  
  // Stream subscription for connectivity changes
  StreamSubscription<ConnectivityResult>? _subscription;
  
  // Timer for periodic connectivity check
  Timer? _periodicCheckTimer;
  
  // Debounce timer for handling rapid connectivity changes
  Timer? _debounceTimer;
  
  // Getters
  NetworkStatus get status => _status.value;
  ConnectivityResult get connectionType => _connectionType.value;
  bool get isOnline => _status.value == NetworkStatus.online;
  bool get isOffline => _status.value == NetworkStatus.offline;
  
  // Initialize the service
  Future<ConnectivityService> init() async {
    try {
      // Get initial connectivity status
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);

      // Listen for connectivity changes
      _subscription = Connectivity().onConnectivityChanged.listen((result) {
        _handleConnectivityChange(result);
      });

      // Start periodic connectivity check
      _startPeriodicCheck();

      logger.i('Connectivity service initialized', tag: 'Connectivity');
    } catch (e, stackTrace) {
      logger.e(
        'Error initializing connectivity service',
        tag: 'Connectivity',
        error: e,
        stackTrace: stackTrace,
      );
    }

    return this;
  }

  // Handle connectivity changes with debounce
  void _handleConnectivityChange(ConnectivityResult result) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      _updateConnectionStatus(result);
    });
  }

  // Update connection status
  void _updateConnectionStatus(ConnectivityResult result) {
    _connectionType.value = result;
    final newStatus = result == ConnectivityResult.none
        ? NetworkStatus.offline
        : NetworkStatus.online;

    if (_status.value != newStatus) {
      _status.value = newStatus;
      _notifyStatusChange(newStatus);
      
      logger.i(
        'Network status changed: ${newStatus.name} (${result.name})',
        tag: 'Connectivity',
      );
    }
  }

  // Notify user about connectivity changes
  void _notifyStatusChange(NetworkStatus status) {
    if (status == NetworkStatus.offline) {
      CustomDialog.show(
        child: AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please check your internet connection and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: checkConnectivity,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  // Start periodic connectivity check
  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => checkConnectivity(),
    );
  }

  // Check connectivity manually
  Future<bool> checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
      return result != ConnectivityResult.none;
    } catch (e, stackTrace) {
      logger.e(
        'Error checking connectivity',
        tag: 'Connectivity',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // Wait for internet connection
  Future<void> waitForConnection({
    Duration timeout = const Duration(minutes: 1),
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    if (isOnline) return;

    final completer = Completer<void>();
    Timer? timeoutTimer;
    Timer? checkTimer;

    // Set timeout
    timeoutTimer = Timer(timeout, () {
      checkTimer?.cancel();
      if (!completer.isCompleted) {
        completer.completeError('Connection timeout');
      }
    });

    // Check periodically
    checkTimer = Timer.periodic(checkInterval, (_) async {
      if (await checkConnectivity()) {
        timeoutTimer.cancel();
        checkTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    try {
      await completer.future;
    } finally {
      timeoutTimer.cancel();
      checkTimer?.cancel();
    }
  }

  // Execute function with connectivity check
  Future<T> withConnectivity<T>({
    required Future<T> Function() onExecute,
    Future<T> Function()? onNoConnection,
    bool waitForConnection = false,
  }) async {
    if (!isOnline) {
      if (waitForConnection) {
        try {
          await this.waitForConnection();
          return await onExecute();
        } catch (e) {
          if (onNoConnection != null) {
            return await onNoConnection();
          }
          rethrow;
        }
      } else if (onNoConnection != null) {
        return await onNoConnection();
      } else {
        throw 'No internet connection';
      }
    }
    return await onExecute();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _periodicCheckTimer?.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }
}

// Extension for easy access
extension ConnectivityServiceExtension on GetInterface {
  ConnectivityService get connectivity => ConnectivityService.to;
}

// Extension for executing with connectivity check
extension ConnectivityFutureExtension<T> on Future<T> {
  Future<T> withConnectivity({
    Future<T> Function()? onNoConnection,
    bool waitForConnection = false,
  }) {
    return Get.find<ConnectivityService>().withConnectivity(
      onExecute: () => this,
      onNoConnection: onNoConnection,
      waitForConnection: waitForConnection,
    );
  }
}
