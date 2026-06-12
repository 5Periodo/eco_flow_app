import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/app_colors.dart';
import '../../presentation/controllers/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HistoryController>().loadHistories();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<HistoryController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: const Text(
                'Histórico',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primaryButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white70,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontSize: 14),
                    tabs: const [
                      Tab(text: 'Descartes'),
                      Tab(text: 'Resgates'),
                    ],
                  ),
                ),
              ),
            ),
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryButton))
                : controller.errorMessage != null
                    ? Center(
                        child: Text(
                          controller.errorMessage ?? 'Erro ao carregar histórico.',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _DescartesList(descartes: controller.descartes),
                          _ResgatesList(resgates: controller.resgates),
                        ],
                      ),
          );
        },
      ),
    );
  }
}

class _DescartesList extends StatelessWidget {
  final List<dynamic> descartes;

  const _DescartesList({required this.descartes});

  IconData _iconForCategory(String icon) {
    switch (icon.toLowerCase()) {
      case 'metal':
        return Icons.build_outlined;
      case 'vidro':
        return Icons.local_bar_outlined;
      case 'plastico':
        return Icons.delete_outline;
      case 'papel':
        return Icons.description_outlined;
      case 'organico':
        return Icons.eco_outlined;
      default:
        return Icons.recycling;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APROVADO':
        return Colors.greenAccent;
      case 'PENDENTE':
        return Colors.orangeAccent;
      case 'NEGADO':
        return Colors.redAccent;
      default:
        return Colors.white54;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (descartes.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, color: Colors.white54, size: 48),
              SizedBox(height: 16),
              Text(
                'Nenhum descarte registrado.',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Comece a descartar materiais para acumular pontos!',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: descartes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final descarte = descartes[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _statusColor(descarte.status).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _statusColor(descarte.status).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForCategory(descarte.categoryIcon),
                  color: _statusColor(descarte.status),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      descarte.categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${descarte.weightKg.toStringAsFixed(1)} kg • ${_formatDate(descarte.date)}',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    if (descarte.ecopointName != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white54, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              descarte.ecopointName!,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (descarte.fotoUrls.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: AppColors.primaryButton, size: 14),
                          const SizedBox(width: 4),
                          const Text('Com foto anexada', style: TextStyle(color: AppColors.primaryButton, fontSize: 11)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${descarte.points}',
                    style: const TextStyle(
                      color: AppColors.primaryButton,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(descarte.status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      descarte.status,
                      style: TextStyle(
                        color: _statusColor(descarte.status),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResgatesList extends StatelessWidget {
  final List<dynamic> resgates;

  const _ResgatesList({required this.resgates});

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'RESGATADO':
        return Colors.greenAccent;
      case 'PENDENTE':
        return Colors.orangeAccent;
      case 'EXPIRADO':
        return Colors.redAccent;
      default:
        return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (resgates.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard_outlined, color: Colors.white54, size: 48),
              SizedBox(height: 16),
              Text(
                'Nenhum resgate registrado.',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Resgate recompensas com seus pontos!',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: resgates.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final resgate = resgates[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _statusColor(resgate.status).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _statusColor(resgate.status).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.card_giftcard_outlined,
                      color: _statusColor(resgate.status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resgate.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tipo: ${resgate.type}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Código de Verificação',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(
                          resgate.verificationCode,
                          style: const TextStyle(
                            color: AppColors.primaryButton,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pontos',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(
                          '${resgate.pointsCost} pts',
                          style: const TextStyle(
                            color: AppColors.primaryButton,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Resgatado em',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(
                          _formatDate(resgate.redeemedAt),
                          style: const TextStyle(
                            color: AppColors.primaryButton,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _statusColor(resgate.status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  resgate.status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(resgate.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
