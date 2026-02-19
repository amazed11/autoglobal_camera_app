import 'package:autoglobal_camera_app/src/services/network/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../di_injection.dart';
import '../../../../core/app/colors.dart';
import '../../../main/data/models/car/car_paint_model.dart';
import '../../../main/data/models/car/car_response_model.dart';
import '../cubit/car_paint_cubit.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

class CarPaintScreen extends StatelessWidget {
  final CarModel car;

  const CarPaintScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarPaintCubit(getIt<ApiHandler>())..fetchParts(),
      child: _CarPaintBody(car: car),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _CarPaintBody extends StatefulWidget {
  final CarModel car;

  const _CarPaintBody({required this.car});

  @override
  State<_CarPaintBody> createState() => _CarPaintBodyState();
}

class _CarPaintBodyState extends State<_CarPaintBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarPaintCubit, CarPaintState>(
      listener: (context, state) {
        if (state.status == CarPaintStatus.submitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Paint report updated'),
              backgroundColor: AppColor.kSuccess,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == CarPaintStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Something went wrong'),
              backgroundColor: AppColor.kError,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CarPaintCubit>();
        return Scaffold(
          backgroundColor: AppColor.kNeutral100,
          appBar: _buildAppBar(context, state, cubit),
          body: _buildBody(context, state, cubit),
        );
      },
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  AppBar _buildAppBar(
      BuildContext ctx, CarPaintState state, CarPaintCubit cubit) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: BackButton(color: AppColor.kPrimaryMain),
      title: Column(
        children: [
          Text(
            'Paint Report',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.kNeutral900),
          ),
          Text(
            widget.car.title,
            style: TextStyle(fontSize: 12, color: AppColor.kNeutral400),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        if (state.selectedPartCount > 0)
          TextButton(
            onPressed: cubit.clearAll,
            child: Text('Clear',
                style: TextStyle(color: AppColor.kError, fontSize: 13)),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColor.kPrimaryMain,
            unselectedLabelColor: AppColor.kNeutral400,
            indicatorColor: AppColor.kPrimaryMain,
            indicatorWeight: 2.5,
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Body Panels'),
              Tab(text: 'Roof Edges'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(
      BuildContext ctx, CarPaintState state, CarPaintCubit cubit) {
    if (state.status == CarPaintStatus.loadingParts ||
        state.status == CarPaintStatus.initial) {
      return Center(
          child: CircularProgressIndicator(color: AppColor.kPrimaryMain));
    }

    if (state.status == CarPaintStatus.failure && state.data == null) {
      return _ErrorView(onRetry: cubit.fetchParts);
    }

    final data = state.data!;

    return Column(
      children: [
        _PaintLegend(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Tab 1 – Body panels (top view SVG)
              _PaintSvgMap(
                svgAsset: 'assets/images/car_damage_top_view.svg',
                zones: _topViewPaintZones,
                partsLabels: data.parts,
                selection: state.selection,
                onTap: (partKey, partLabel) => _openOptionSheet(
                    context, cubit, partKey, partLabel, data.options,
                    currentOption: state.optionFor(partKey)),
              ),

              // Tab 2 – Roof edge variants (bottom view SVG)
              _PaintSvgMap(
                svgAsset: 'assets/images/car_damage_bottom_view.svg',
                zones: _bottomViewPaintZones,
                partsLabels: data.parts,
                selection: state.selection,
                onTap: (partKey, partLabel) => _openOptionSheet(
                    context, cubit, partKey, partLabel, data.options,
                    currentOption: state.optionFor(partKey)),
              ),
            ],
          ),
        ),
        _PaintBottomPanel(
          state: state,
          partsLabels: data.parts,
          onSubmit: () => cubit.submitReport(widget.car.id),
        ),
      ],
    );
  }

  void _openOptionSheet(
    BuildContext context,
    CarPaintCubit cubit,
    String partKey,
    String partLabel,
    Map<String, String> options, {
    String? currentOption,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _PaintOptionSheet(
          partKey: partKey,
          partLabel: partLabel,
          options: options,
          currentOption: currentOption,
        ),
      ),
    );
  }
}

// ─── Paint Legend ─────────────────────────────────────────────────────────────

class _PaintLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _LegendChip(
            color: AppColor.kSuccess,
            label: '≤160 µm',
            sublabel: 'Original',
          ),
          const SizedBox(width: 8),
          _LegendChip(
            color: AppColor.kWarning,
            label: '161–300 µm',
            sublabel: 'Repainted',
          ),
          const SizedBox(width: 8),
          _LegendChip(
            color: AppColor.kError,
            label: '>300 µm',
            sublabel: 'Heavy / Filler',
          ),
          const Spacer(),
          Icon(Icons.touch_app_rounded, size: 14, color: AppColor.kNeutral400),
          const SizedBox(width: 4),
          Text(
            'Tap to select',
            style: TextStyle(fontSize: 11, color: AppColor.kNeutral400),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;
  final String sublabel;

  const _LegendChip({
    required this.color,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sublabel,
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700, color: color)),
            Text(label,
                style: TextStyle(fontSize: 9, color: AppColor.kNeutral400)),
          ],
        ),
      ],
    );
  }
}

// ─── SVG Paint Map ────────────────────────────────────────────────────────────

class _PaintZone {
  final String key;
  final double cx;
  final double cy;

  const _PaintZone(this.key, {required this.cx, required this.cy});
}

class _PaintSvgMap extends StatelessWidget {
  final String svgAsset;
  final List<_PaintZone> zones;
  final Map<String, String> partsLabels;
  final Map<String, String> selection;
  final void Function(String partKey, String partLabel) onTap;

  static const double _svgW = 308.0;
  static const double _svgH = 269.0;
  static const double _svgAR = _svgW / _svgH;

  const _PaintSvgMap({
    required this.svgAsset,
    required this.zones,
    required this.partsLabels,
    required this.selection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final renderW = constraints.maxWidth;
      final renderH = constraints.maxHeight;

      double svgRenderW, svgRenderH, offsetX, offsetY;
      if (renderW / renderH > _svgAR) {
        svgRenderH = renderH;
        svgRenderW = renderH * _svgAR;
      } else {
        svgRenderW = renderW;
        svgRenderH = renderW / _svgAR;
      }
      offsetX = (renderW - svgRenderW) / 2;
      offsetY = (renderH - svgRenderH) / 2;

      final scaleX = svgRenderW / _svgW;
      final scaleY = svgRenderH / _svgH;

      return Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(svgAsset, fit: BoxFit.contain),
          ),
          ...zones.where((z) => partsLabels.containsKey(z.key)).map((zone) {
            final label = partsLabels[zone.key] ?? zone.key;
            final selectedOption = selection[zone.key];

            final x = offsetX + zone.cx * scaleX;
            final y = offsetY + zone.cy * scaleY;
            const r = 14.0;

            return Positioned(
              left: x - r,
              top: y - r,
              child: GestureDetector(
                onTap: () => onTap(zone.key, label),
                child: _PaintZoneDot(
                  selectedOption: selectedOption,
                  size: r * 2,
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}

// ─── Zone Dot ─────────────────────────────────────────────────────────────────

class _PaintZoneDot extends StatelessWidget {
  final String? selectedOption;
  final double size;

  const _PaintZoneDot({required this.selectedOption, required this.size});

  Color get _dotColor {
    switch (selectedOption) {
      case kOriginalPaint:
        return AppColor.kSuccess;
      case kRepainted:
        return AppColor.kWarning;
      case kHeavyRepairFiller:
        return AppColor.kError;
      default:
        return AppColor.kPrimaryMain;
    }
  }

  bool get _isSelected => selectedOption != null;

  @override
  Widget build(BuildContext context) {
    final color = _dotColor;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isSelected
            ? color.withOpacity(0.85)
            : AppColor.kPrimaryMain.withOpacity(0.18),
        border: Border.all(
          color: _isSelected ? color : AppColor.kPrimaryMain.withOpacity(0.45),
          width: _isSelected ? 2.0 : 1.0,
        ),
        boxShadow: _isSelected
            ? [
                BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 6,
                    spreadRadius: 1)
              ]
            : null,
      ),
      child: Center(
        child: _isSelected
            ? const Icon(Icons.check, size: 10, color: Colors.white)
            : Icon(Icons.add,
                size: size * 0.45,
                color: AppColor.kPrimaryMain.withOpacity(0.7)),
      ),
    );
  }
}

// ─── Option Picker Bottom Sheet ───────────────────────────────────────────────

class _PaintOptionSheet extends StatelessWidget {
  final String partKey;
  final String partLabel;
  final Map<String, String> options;
  final String? currentOption;

  const _PaintOptionSheet({
    required this.partKey,
    required this.partLabel,
    required this.options,
    required this.currentOption,
  });

  Color _optionColor(String key) {
    switch (key) {
      case kOriginalPaint:
        return AppColor.kSuccess;
      case kRepainted:
        return AppColor.kWarning;
      case kHeavyRepairFiller:
        return AppColor.kError;
      default:
        return AppColor.kPrimaryMain;
    }
  }

  String _optionMicron(String key) {
    switch (key) {
      case kOriginalPaint:
        return '≤ 160 µm';
      case kRepainted:
        return '161 – 300 µm';
      case kHeavyRepairFiller:
        return '> 300 µm';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarPaintCubit, CarPaintState>(
      builder: (context, state) {
        final cubit = context.read<CarPaintCubit>();
        final selected = state.optionFor(partKey);

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.kNeutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.kPrimaryMain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.format_paint_rounded,
                          color: AppColor.kPrimaryMain, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(partLabel,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.kNeutral900)),
                          Text('Select paint condition',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.kNeutral400)),
                        ],
                      ),
                    ),
                    if (selected != null)
                      TextButton(
                        onPressed: () {
                          cubit.clearPart(partKey);
                          Navigator.pop(context);
                        },
                        child: Text('Clear',
                            style: TextStyle(
                                color: AppColor.kError, fontSize: 13)),
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Radio options
              ...options.entries.map((entry) {
                final isSelected = selected == entry.key;
                final color = _optionColor(entry.key);
                final micron = _optionMicron(entry.key);
                return _PaintOptionTile(
                  optionKey: entry.key,
                  label: entry.value,
                  micron: micron,
                  color: color,
                  isSelected: isSelected,
                  onTap: () {
                    cubit.setOption(partKey, entry.key);
                    Navigator.pop(context);
                  },
                );
              }),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _PaintOptionTile extends StatelessWidget {
  final String optionKey;
  final String label;
  final String micron;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaintOptionTile({
    required this.optionKey,
    required this.label,
    required this.micron,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Radio circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : AppColor.kNeutral300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? color : AppColor.kNeutral700,
                    ),
                  ),
                  if (micron.isNotEmpty)
                    Text(
                      micron,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? color.withOpacity(0.7)
                            : AppColor.kNeutral400,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Panel ─────────────────────────────────────────────────────────────

class _PaintBottomPanel extends StatelessWidget {
  final CarPaintState state;
  final Map<String, String> partsLabels;
  final VoidCallback onSubmit;

  const _PaintBottomPanel({
    required this.state,
    required this.partsLabels,
    required this.onSubmit,
  });

  Color _chipColor(String optionKey) {
    switch (optionKey) {
      case kOriginalPaint:
        return AppColor.kSuccess;
      case kRepainted:
        return AppColor.kWarning;
      case kHeavyRepairFiller:
        return AppColor.kError;
      default:
        return AppColor.kPrimaryMain;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedParts = state.selection.entries.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Selected parts chips ──
          if (selectedParts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.format_paint_rounded,
                      size: 16, color: AppColor.kPrimaryMain),
                  const SizedBox(width: 6),
                  Text(
                    '${selectedParts.length} part${selectedParts.length > 1 ? 's' : ''} assessed',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColor.kNeutral800),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: selectedParts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  final e = selectedParts[i];
                  final label = partsLabels[e.key] ?? e.key;
                  final color = _chipColor(e.value);
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          label,
                          style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          // ── Submit button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selectedParts.isEmpty
                    ? null
                    : (state.status == CarPaintStatus.submitting
                        ? null
                        : onSubmit),
                icon: state.status == CarPaintStatus.submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  state.status == CarPaintStatus.submitting
                      ? 'Submitting…'
                      : 'Submit Paint Report',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kPrimaryMain,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColor.kNeutral200,
                  disabledForegroundColor: AppColor.kNeutral400,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColor.kError),
            const SizedBox(height: 16),
            Text('Failed to load paint data',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.kNeutral800)),
            const SizedBox(height: 8),
            Text('Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColor.kNeutral500)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kPrimaryMain,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Zone Definitions ─────────────────────────────────────────────────────────
// SVG viewBox: 308 × 269 — coordinates match the car body panel hit areas.

/// Tab 1 — top_view SVG  (all exterior body panels)
const List<_PaintZone> _topViewPaintZones = [
  _PaintZone('hood', cx: 154.87, cy: 45.64),
  _PaintZone('front_left_fender', cx: 48.61, cy: 47.62),
  _PaintZone('front_right_fender', cx: 259.06, cy: 46.62),
  _PaintZone('front_left_door', cx: 46.69, cy: 116.67),
  _PaintZone('front_right_door', cx: 263.22, cy: 113.84),
  _PaintZone('rear_left_door', cx: 49.06, cy: 164.93),
  _PaintZone('rear_right_door', cx: 256.70, cy: 164.66),
  _PaintZone('trunk', cx: 153.78, cy: 248.77),
  _PaintZone('roof', cx: 154.45, cy: 130.67),
  _PaintZone('rear_left_fender', cx: 50.62, cy: 226.52),
  _PaintZone('rear_right_fender', cx: 256.76, cy: 226.59),
  _PaintZone('left_step', cx: 18.65, cy: 130.06),
  _PaintZone('right_step', cx: 289.87, cy: 130.55),
  _PaintZone('roof_edge_left', cx: 92.0, cy: 159.67),
  _PaintZone('roof_edge_right', cx: 216.0, cy: 159.67),
];

/// Tab 2 — bottom_view SVG  (alt roof edge parts)
const List<_PaintZone> _bottomViewPaintZones = [
  _PaintZone('roof_edg_Left', cx: 115.46, cy: 108.0),
  _PaintZone('roof_edg_right', cx: 183.86, cy: 108.0),
];
