// import 'package:flutter/material.dart';
// import 'package:ircell/main.dart';
// import 'package:ircell/screens/tabs_screen.dart';
// class Onboarding extends StatelessWidget {
//   Onboarding({super.key});

//   final fullNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Complete Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: fullNameController,
//               decoration: const InputDecoration(labelText: 'Full Name'),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () async {
//                 final user = supabase.auth.currentUser;
//                 await supabase.from('profiles').insert({
//                   'id': user!.id,
//                   'full_name': fullNameController.text.trim(),
//                 });
//                 if (context.mounted) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (ctx) => const TabsScreen()),
//                   );
//                 }
//               },
//               child: const Text('Continue'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
