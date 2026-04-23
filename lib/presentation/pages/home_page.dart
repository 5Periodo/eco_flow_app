import 'package:flutter/material.dart';
import '../../../colors/app_colors.dart';
import '../../../presentation/controllers/home_controller.dart';
import '../../../presentation/widgets/category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  void _openCollectionFlow(String category, IconData icon, Color color) {
    _controller.startCollection(category, icon, color);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        insetPadding:    const EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(_controller.categoryIcon, color: _controller.categoryColor, size: 28),
                        const SizedBox(width: 8),
                        Text(category,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ]),
                      IconButton(
                        icon:      const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_controller.currentStep == 0) _buildStep1(),
                  if (_controller.currentStep == 1) _buildStep2(),
                  if (_controller.currentStep == 2) _buildStep3(),
                  if (_controller.currentStep == 3) _buildStep4(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text('Área de Coleta',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Selecione o resíduo ou escaneie o QR\nCode do contentor',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          const SizedBox(height: 30),
          Container(
            padding:    const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:        AppColors.primaryButton,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Container(
                  padding:    const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.qr_code_scanner, size: 40),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Escanear',        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('QR Code',         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Descarte rápido', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GridView.count(
            shrinkWrap:     true,
            physics:        const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing:  15,
            childAspectRatio: 0.85,
            children: [
              GestureDetector(
                onTap: () => _openCollectionFlow('Plástico', Icons.delete_outline, Colors.red),
                child: const CategoryCard(title: 'Plástico',       points: '10', icon: Icons.delete_outline,        iconColor: Colors.red),
              ),
              GestureDetector(
                onTap: () => _openCollectionFlow('Papel', Icons.description_outlined, Colors.blue),
                child: const CategoryCard(title: 'Papel',          points: '8',  icon: Icons.description_outlined,  iconColor: Colors.blue),
              ),
              GestureDetector(
                onTap: () => _openCollectionFlow('Vidro', Icons.local_bar_outlined, Colors.teal),
                child: const CategoryCard(title: 'Vidro',          points: '15', icon: Icons.local_bar_outlined,    iconColor: Colors.teal),
              ),
              GestureDetector(
                onTap: () => _openCollectionFlow('Metal', Icons.build_outlined, Colors.orange),
                child: const CategoryCard(title: 'Metal',          points: '12', icon: Icons.build_outlined,        iconColor: Colors.orange),
              ),
              GestureDetector(
                onTap: () => _openCollectionFlow('Óleo', Icons.opacity_outlined, Colors.amber),
                child: const CategoryCard(title: 'Óleo de Cozinha', points: '20', icon: Icons.opacity_outlined,    iconColor: Colors.amber),
              ),
              GestureDetector(
                onTap: () => _openCollectionFlow('Pilhas', Icons.battery_alert_outlined, Colors.black),
                child: const CategoryCard(title: 'Pilhas',         points: '25', icon: Icons.battery_alert_outlined, iconColor: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() => Column(
        children: [
          const Icon(Icons.qr_code, size: 60, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Escanear Contentor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Digite o código do contentor para validar.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          TextField(
            controller: _controller.containerCodeController,
            decoration: InputDecoration(
              hintText: 'EX: ECO-123',
              border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _controller.nextStep,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Continuar ->', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );

  Widget _buildStep2() => Column(
        children: [
          const Icon(Icons.camera_alt_outlined, size: 60, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Foto do Resíduo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Fotografe o material para validar a coleta.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black54), onPressed: _controller.previousStep),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _controller.takePhoto,
                    icon:  const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text('Abrir Câmera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildStep3() => Column(
        children: [
          const Text('Volume do Descarte',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Selecione a quantidade para calcular seus pontos.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Container(
            padding:    const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint:       const Text('Escolha o volume', style: TextStyle(color: Colors.grey)),
                value:      _controller.selectedVolume,
                icon:       const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: const [
                  DropdownMenuItem(value: 'Sacola Pequena', child: Text('Sacola Pequena', style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(value: 'Sacola Grande',  child: Text('Sacola Grande',  style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(value: 'Unidade',        child: Text('Unidade',        style: TextStyle(color: Colors.black))),
                ],
                onChanged: (v) { if (v != null) _controller.setVolume(v); },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black54), onPressed: _controller.previousStep),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _controller.selectedVolume == null || _controller.isLoading
                        ? null
                        : _controller.submitCollection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:         const Color(0xFF00C853),
                      disabledBackgroundColor: Colors.green.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _controller.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Confirmar Descarte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildStep4() => Column(
        children: [
          const Icon(Icons.star_border_purple500, size: 60, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Mandou bem!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Obrigado por fazer a sua parte e ajudar a salvar o planeta!',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Concluir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
}