import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modeles/annonce.dart';

class EcranDetail extends StatefulWidget {
  final Annonce annonce;
  const EcranDetail({super.key, required this.annonce});

  @override
  State<EcranDetail> createState() => _EcranDetailState();
}

class _EcranDetailState extends State<EcranDetail> {
  int _pageActuelle = 0;

  
  Future<void> _passerAppel() async {
    final Uri url = Uri(
      scheme: 'tel',
      path: widget.annonce.numeroTelephone,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de passer l\'appel.')),
        );
      }
    }
  }

  
  Future<void> _ouvrirWhatsApp() async {
    
    String numeroPuce = widget.annonce.numeroTelephone.replaceAll(RegExp(r'[^\d]'), '');
    
    
    if (numeroPuce.length == 9 && (numeroPuce.startsWith('77') || numeroPuce.startsWith('78') || numeroPuce.startsWith('76') || numeroPuce.startsWith('70') || numeroPuce.startsWith('75'))) {
      numeroPuce = '221$numeroPuce';
    }

    final String message = 'Bonjour, je suis intéressé par votre annonce "${widget.annonce.titre}" sur SunuMarché.';
    final Uri url = Uri.parse('https://wa.me/$numeroPuce?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp.')),
        );
      }
    }
  }

  Widget _construireImage(String cheminImage) {
    if (cheminImage.startsWith('http')) {
      return Image.network(cheminImage, height: 280, width: double.infinity, fit: BoxFit.cover);
    } else {
      return Image.file(File(cheminImage), height: 280, width: double.infinity, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.annonce.images;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.annonce.titre),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone des images (Carrousel)
            if (images.isNotEmpty)
              Stack(
                children: [
                  SizedBox(
                    height: 280,
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _pageActuelle = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _construireImage(images[index]);
                      },
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_pageActuelle + 1}/${images.length}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              )
            else
              Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image_not_supported, size: 60)),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.annonce.prix.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text(widget.annonce.localisation, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.annonce.description, style: const TextStyle(fontSize: 16, height: 1.4)),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _passerAppel,
                          icon: const Icon(Icons.phone),
                          label: const Text('Appeler'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _ouvrirWhatsApp,
                          icon: const Icon(Icons.chat),
                          label: const Text('WhatsApp'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
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