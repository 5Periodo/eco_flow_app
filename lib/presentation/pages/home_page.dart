import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../colors/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/categoria_material.dart';
import '../../presentation/controllers/home_controller.dart';
import '../../presentation/widgets/category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeController>().loadCategories();
      }
    });
  }

  // Mapeia o nome da categoria para um ícone Material
  IconData _iconFor(String nome) {
    final n = nome.toLowerCase();
    if (n.contains('plástico') || n.contains('plastico')) return Icons.delete_outline;
    if (n.contains('papel') || n.contains('papelão'))     return Icons.description_outlined;
    if (n.contains('vidro'))                              return Icons.local_bar_outlined;
    if (n.contains('metal') || n.contains('alumínio'))   return Icons.build_outlined;
    if (n.contains('óleo')  || n.contains('oleo'))       return Icons.opacity_outlined;
    if (n.contains('pilha') || n.contains('bateria'))    return Icons.battery_alert_outlined;
    if (n.contains('eletr'))                             return Icons.devices_outlined;
    return Icons.recycling;
  }

  // Converte hex "#RRGGBB" para Color
  Color _colorFor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.green;
    }
  }

  // Entrada via card de categoria → abre modal no passo "escanear QR"
  void _openFromCategory(BuildContext context, CategoriaMaterial cat) {
    context.read<HomeController>().startFromCategory(cat);
    _showModal(context);
  }

  // Entrada via banner QR → navega para o scanner antes de abrir o modal
  Future<void> _openFromQrBanner(BuildContext context) async {
    final hash =
        await Navigator.pushNamed(context, AppRoutes.qrScanner) as String?;
    if (hash != null && context.mounted) {
      context.read<HomeController>().startFromQrScan(hash);
      _showModal(context);
    }
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape:        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        insetPadding: const EdgeInsets.all(20),
        child: Consumer<HomeController>(
          builder: (ctx, controller, _) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Cabeçalho ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.selectedCategory?.nome ?? 'Selecionar Material',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      IconButton(
                        icon:      const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Passos ──
                  // Passo 0a: escanear QR (veio de card de categoria)
                  if (controller.currentStep == 0 && controller.qrCodeHash == null)
                    _buildQrScanStep(ctx, controller),

                  // Passo 1: inserir peso
                  if (controller.currentStep == 1)
                    _buildWeightStep(controller),

                  // Passo 2: sucesso
                  if (controller.currentStep == 2)
                    _buildSuccessStep(ctx),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Step 0a: botão para abrir o scanner ──
  Widget _buildQrScanStep(BuildContext context, HomeController controller) =>
      Column(children: [
        const Icon(Icons.qr_code_scanner, size: 64, color: Colors.green),
        const SizedBox(height: 16),
        const Text('Escanear Contentor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        const Text('Aponte a câmera para o QR Code do contentor.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () async {
              final hash = await Navigator.pushNamed(
                  context, AppRoutes.qrScanner) as String?;
              if (hash != null) controller.setQrHash(hash);
            },
            icon:  const Icon(Icons.qr_code_scanner, color: Colors.white),
            label: const Text('Escanear QR Code',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ]);

  Widget _buildWeightStep(HomeController controller) =>
      Column(children: [
        Icon(
          _iconFor(controller.selectedCategory?.nome ?? ''),
          size:  56,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        Text(
          controller.selectedCategory?.nome ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          '${controller.selectedCategory?.multiplicadorPontos.toStringAsFixed(1)}x pontos por kg',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 24),
        TextField(
          controller:  controller.pesoKgController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText:   'Peso (kg)',
            hintText:    'Ex: 1.5',
            suffixText:  'kg',
            border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
        if (controller.errorMessage != null) ...[
          const SizedBox(height: 10),
          Text(controller.errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width:  double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isLoading ? null : controller.submitDescarte,
            style: ElevatedButton.styleFrom(
              backgroundColor:         const Color(0xFF00C853),
              disabledBackgroundColor: Colors.green.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: controller.isLoading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Confirmar Descarte',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ]);

  // ── Step 2: sucesso ──
  Widget _buildSuccessStep(BuildContext context) =>
      Column(children: [
        const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
        const SizedBox(height: 16),
        const Text('Descarte registrado!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        const Text(
            'Obrigado por fazer sua parte\ne ajudar a salvar o planeta!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 15)),
        const SizedBox(height: 30),
        SizedBox(
          width:  double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Concluir',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        if (controller.isLoadingCats) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryButton));
        }

        if (controller.categoriesError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_outlined, color: Colors.white54, size: 48),
                const SizedBox(height: 12),
                Text(controller.categoriesError!,
                    style: const TextStyle(color: Colors.white54)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:  controller.loadCategories,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryButton),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

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

              // ── Banner QR ──
              GestureDetector(
                onTap: () => _openFromQrBanner(context),
                child: Container(
                  padding:    const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:        AppColors.primaryButton,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Row(
                    children: [
                      _QrBannerIcon(),
                      SizedBox(width: 20),
                      Column(
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
              ),
              const SizedBox(height: 30),

              // ── Grid de categorias (da API) ──
              GridView.builder(
                shrinkWrap:  true,
                physics:     const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:   2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing:  15,
                  childAspectRatio: 0.85,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (_, i) {
                  final cat = controller.categories[i];
                  return GestureDetector(
                    onTap: () => _openFromCategory(context, cat),
                    child: CategoryCard(
                      title:     cat.nome,
                      points:    '${cat.multiplicadorPontos.toStringAsFixed(1)}x',
                      icon:      _iconFor(cat.nome),
                      iconColor: _colorFor(cat.cor),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QrBannerIcon extends StatelessWidget {
  const _QrBannerIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(15)),
      child: const Icon(Icons.qr_code_scanner, size: 40),
    );
  }
}
