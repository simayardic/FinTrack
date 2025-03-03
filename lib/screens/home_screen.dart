import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double exchangeRateUSD = 0.0; // USD to TRY rate
  late double exchangeRateEUR = 0.0; // EUR to TRY rate

  @override
  void initState() {
    super.initState();
    fetchExchangeRates(); // API'den döviz kuru bilgisi al
  }

  // API'den döviz kuru bilgisini çekme
  Future<void> fetchExchangeRates() async {
    final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));

    if (response.statusCode == 200) {
      // API'den gelen veriyi çözümle
      var data = json.decode(response.body);
      setState(() {
        exchangeRateUSD = data['rates']['TRY']; // USD'den TRY'ye döviz kuru
        exchangeRateEUR = data['rates']['EUR'] * exchangeRateUSD; // EUR to TRY = EUR to USD * USD to TRY
      });
    } else {
      throw Exception('Veri çekilemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Döviz kuru bilgisi
            const Text("Döviz Kurları", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // USD to TRY
            exchangeRateUSD > 0
                ? Text(
                    "1 USD = ${exchangeRateUSD.toStringAsFixed(2)} TRY",
                    style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 10),
            // EUR to TRY
            exchangeRateEUR > 0
                ? Text(
                    "1 EUR = ${exchangeRateEUR.toStringAsFixed(2)} TRY",
                    style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            // Aylık ve Yıllık Gelir-Gider
            const Text("Aylık Gelir: \$3000", style: TextStyle(fontSize: 18)),
            const Text("Aylık Gider: \$1500", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            // Kategorilere Göre Gelir ve Gider
            ElevatedButton(
              onPressed: () {
                // Kategorilere gitmek için nav açılır
              },
              child: const Text("Kategorilere Göre Görüntüle"),
            ),
            const SizedBox(height: 20),
            // Grafik (örneğin PieChart) ekleyebiliriz
          ],
        ),
      ),
    );
  }
}
