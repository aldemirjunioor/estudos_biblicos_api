import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'study_detail_screen.dart';

class StudiesLibraryScreen extends StatelessWidget {
  const StudiesLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Estudos')),
        body: const Center(child: Text('Faça login para ver seus estudos.')),
      );
    }

    final studiesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('studies')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Estudos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: studiesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum estudo salvo encontrado.'));
          }

          final studies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: studies.length,
            itemBuilder: (context, index) {
              final study = studies[index];
              final data = study.data() as Map<String, dynamic>;
              final date = (data['createdAt'] as Timestamp).toDate();
              final formattedDate = DateFormat('dd/MM/yyyy').format(date);

              return ListTile(
                title: Text(data['verse']),
                subtitle: Text(formattedDate),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudyDetailScreen(studyData: data),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
