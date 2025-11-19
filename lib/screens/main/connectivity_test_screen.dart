import 'package:flutter/material.dart';
import 'package:edugo/utils/connectivity_test.dart';

class ConnectivityTestScreen extends StatefulWidget {
  const ConnectivityTestScreen({super.key});

  @override
  State<ConnectivityTestScreen> createState() => _ConnectivityTestScreenState();
}

class _ConnectivityTestScreenState extends State<ConnectivityTestScreen> {
  final ConnectivityTest _connectivityTest = ConnectivityTest();
  bool _isTesting = false;
  String _testResults = '';
  bool _internetAvailable = false;
  bool _backendReachable = false;

  Future<void> _runConnectivityTest() async {
    setState(() {
      _isTesting = true;
      _testResults = 'Running connectivity tests...\n';
    });

    try {
      // Test internet availability
      final isInternetAvailable = await _connectivityTest.testNetworkAvailability();
      setState(() {
        _internetAvailable = isInternetAvailable;
        _testResults += isInternetAvailable 
            ? '✅ Internet connection: Available\n' 
            : '❌ Internet connection: Not available\n';
      });

      if (isInternetAvailable) {
        // Test backend connectivity
        final isBackendReachable = await _connectivityTest.testBackendConnectivity();
        setState(() {
          _backendReachable = isBackendReachable;
          _testResults += isBackendReachable 
              ? '✅ Backend server: Reachable\n' 
              : '❌ Backend server: Not reachable\n';
        });
      }

      setState(() {
        _testResults += '\n';
        if (_internetAvailable && _backendReachable) {
          _testResults += '🎉 All tests passed! Connection is working properly.';
        } else if (!_internetAvailable) {
          _testResults += '⚠️ Please check your internet connection.';
        } else if (!_backendReachable) {
          _testResults += '⚠️ Please check your backend server configuration.';
        }
      });
    } catch (e) {
      setState(() {
        _testResults += '❌ Error during testing: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Test'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Network Connectivity Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This test will check if your device can connect to the backend server.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _isTesting ? null : _runConnectivityTest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isTesting
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                          SizedBox(width: 16),
                          Text('Testing...'),
                        ],
                      )
                    : const Text(
                        'Run Connectivity Test',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_isTesting && _testResults.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _internetAvailable && _backendReachable
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _internetAvailable && _backendReachable
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _internetAvailable && _backendReachable
                          ? '✅ Connection Successful'
                          : '❌ Connection Issues Detected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _internetAvailable && _backendReachable
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _internetAvailable && _backendReachable
                          ? 'Your app should be able to communicate with the backend server.'
                          : 'Please check the troubleshooting steps below.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}