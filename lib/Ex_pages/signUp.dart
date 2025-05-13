import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/Ex_pages/userlogin.dart'; // Update if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUpPage(),
  ));
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _nicController.dispose();
    _vehicleNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 🔐 Register the user in Firebase Auth
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final uid = userCredential.user?.uid;

        // 💾 Save additional user data in Firestore
        await FirebaseFirestore.instance.collection('safemate').doc(uid).set({
          'email': _emailController.text.trim(),
          'full_name': _fullNameController.text.trim(),
          'nic': _nicController.text.trim(),
          'vehicle_number': _vehicleNumberController.text.trim(),
          'created_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up successful! Redirecting...')),
        );

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      } on FirebaseAuthException catch (e) {
        String errorMsg;
        if (e.code == 'email-already-in-use') {
          errorMsg = 'Email already in use';
        } else if (e.code == 'invalid-email') {
          errorMsg = 'Invalid email address';
        } else if (e.code == 'weak-password') {
          errorMsg = 'Password is too weak';
        } else {
          errorMsg = e.message ?? 'Signup failed';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "SafeMate",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Let's create an account",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                        _emailController, "Email", TextInputType.emailAddress,
                        (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _fullNameController, "Full Name", TextInputType.text,
                        (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(_nicController, "NIC", TextInputType.text,
                        (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your NIC number';
                      } else if (!RegExp(r'^\d{12}$|^\d{9}[vV]$')
                          .hasMatch(value)) {
                        return 'Invalid NIC (12 digits or 9 digits + V)';
                      }
                      return null;
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(_vehicleNumberController, "Vehicle Number",
                        TextInputType.text, (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your vehicle number';
                      } else if (!RegExp(r'^(?=.*[A-Za-z]{2,})(?=.*\d{4,}).+$')
                          .hasMatch(value)) {
                        return 'Must contain at least 2 letters and 4 numbers';
                      }
                      return null;
                    }),
                    const SizedBox(height: 30),
                    _buildTextField(_passwordController, "Password",
                        TextInputType.visiblePassword, (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a password';
                      } else if (value.length < 6) {
                        return 'At least 6 characters';
                      } else if (!RegExp(
                              r'^(?=.*[!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]).+$')
                          .hasMatch(value)) {
                        return 'Include at least one special character';
                      }
                      return null;
                    }, obscureText: true),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _confirmPasswordController,
                        "Confirm Password",
                        TextInputType.visiblePassword, (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }, obscureText: true),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: const Text("Sign Up",
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text("Already have an account? Log In",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      TextInputType inputType, String? Function(String?)? validator,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
