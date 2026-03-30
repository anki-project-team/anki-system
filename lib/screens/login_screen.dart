import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';
import 'package:ihk_ap1_prep/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      await AuthService().login(
          _emailController.text.trim(),
          _passwordController.text.trim());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll(
                'Exception: ', '')),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _loading = true);
    try {
      await AuthService().signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Oberer Dark Navy Bereich mit Logo
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    24, 48, 24, 40),
                child: Column(
                  children: [
                    // LF Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1e3a5f),
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE8813A)
                              .withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Text(
                            'LF',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 4),
                            width: 32,
                            height: 3,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFE8813A),
                              borderRadius:
                                  BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'IHK AP1 Prep',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Melde dich an, um weiterzulernen',
                      style: TextStyle(
                          color: Colors.white
                              .withOpacity(0.6),
                          fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Weißes Formular-Panel (abgerundete obere Ecken)
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                    24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // E-Mail
                    _inputLabel('E-Mail'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _emailController,
                      hint: 'deine@email.de',
                      icon: Icons.email_outlined,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Passwort
                    _inputLabel('Passwort'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _passwordController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        onPressed: () => setState(() =>
                            _obscurePassword =
                                !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF162447),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12)),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Einloggen',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Row(children: [
                      Expanded(
                          child: Divider(
                              color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        child: Text('oder',
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13)),
                      ),
                      Expanded(
                          child: Divider(
                              color: Colors.grey[300])),
                    ]),
                    const SizedBox(height: 16),

                    // Google Button
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _loading
                            ? null
                            : _googleLogin,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12)),
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            // Google G Logo
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey[300]!),
                              ),
                              child: const Center(
                                child: Text('G',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(
                                            0xFF4285F4))),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Mit Google anmelden',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF374151),
                                  fontWeight:
                                      FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Registrieren Link
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Noch kein Konto? ',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const RegisterScreen()),
                          ),
                          child: const Text(
                            'Registrieren',
                            style: TextStyle(
                                color: Color(0xFFE8813A),
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Footer
                    Center(
                      child: Text(
                        'Learn-Factory · BBQ Düsseldorf',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151)),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
            fontSize: 15, color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon,
              color: Colors.grey[400], size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
