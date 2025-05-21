import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateTicket extends StatelessWidget {
  const GenerateTicket({
    super.key,
    required this.eventTitle,
    required this.uid,
  });
  final String eventTitle;
  final String uid;

  @override
  Widget build(BuildContext context) {
    double qrsize = 240;
    return Scaffold(
      appBar: AppBar(title: Text('Generate Ticket')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),

          child: Center(
            child: Card(
              color: const Color.fromARGB(255, 243, 243, 255).withOpacity(0.55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Your Ticket',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Event Name: $eventTitle',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: QrImageView(
                          data: uid,
                          size: qrsize,
                          gapless: false,
                          version: QrVersions.auto,
                          backgroundColor: Colors.white,
                          embeddedImage: const AssetImage(
                            'assets/images/ircircle2.png',
                          ),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(qrsize * 0.2083, qrsize * 0.2083),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Let the volunteers scan the above QR code during the event when asked.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
