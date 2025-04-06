import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/transaction_provider.dart';
import '../utils/utils.dart';
import 'transaction_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FinTrack',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final totalBalance = provider.getTotalBalance();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toplam Bakiye',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Utils.formatCurrency(totalBalance),
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: totalBalance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Son İşlemler',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionFormScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni İşlem'),
                    ),
                  ],
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 16),
                if (provider.transactions.isEmpty)
                  Center(
                    child: Text(
                      'Henüz işlem bulunmuyor',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                      ),
                    ),
                  ).animate().fadeIn()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = provider.transactions[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transaction.type == 'income'
                                ? Colors.green[100]
                                : Colors.red[100],
                            child: Icon(
                              transaction.type == 'income'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            transaction.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            transaction.category,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            Utils.formatCurrency(transaction.amount),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: transaction.type == 'income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideX();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
