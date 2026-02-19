import 'package:autoglobal_camera_app/src/services/network/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../di_injection.dart';
import '../../../../core/app/colors.dart';
import '../../../main/data/models/car/car_response_model.dart';
import '../cubit/car_damage_cubit.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

class CarDamageScreen extends StatelessWidget {
  final CarModel car;

  const CarDamageScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarDamageCubit(getIt<ApiHandler>())..fetchParts(),
      child: _CarDamageBody(car: car),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _CarDamageBody extends StatefulWidget {
  final CarModel car;

  const _CarDamageBody({required this.car});

  @override
  State<_CarDamageBody> createState() => _CarDamageBodyState();
}

class _CarDamageBodyState extends State<_CarDamageBody>
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
    return BlocConsumer<CarDamageCubit, CarDamageState>(
      listener: (context, state) {
        if (state.status == CarDamageStatus.submitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Updated successfully'),
              backgroundColor: AppColor.kSuccess,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == CarDamageStatus.failure &&
            state.status != CarDamageStatus.loadingParts) {
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
        final cubit = context.read<CarDamageCubit>();

        return Scaffold(
          backgroundColor: AppColor.kNeutral100,
          appBar: _buildAppBar(context, state, cubit),
          body: _buildBody(context, state, cubit),
        );
      },
    );
  }

  AppBar _buildAppBar(
      BuildContext ctx, CarDamageState state, CarDamageCubit cubit) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: BackButton(color: AppColor.kPrimaryMain),
      title: Column(
        children: [
          Text('Damage Report',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColor.kNeutral900)),
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
            onPressed: () => cubit.clearAll(),
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
              Tab(text: 'Outer Parts'),
              Tab(text: 'Structural'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext ctx, CarDamageState state, CarDamageCubit cubit) {
    if (state.status == CarDamageStatus.loadingParts ||
        state.status == CarDamageStatus.initial) {
      return Center(
          child: CircularProgressIndicator(color: AppColor.kPrimaryMain));
    }

    if (state.status == CarDamageStatus.failure && state.data == null) {
      return _ErrorView(onRetry: cubit.fetchParts);
    }

    final data = state.data!;
    final options = data.options;

    return Column(
      children: [
        // ── Instruction banner ──
        _InstructionBanner(),

        // ── Tab views ──
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Tab 1 – Outer parts
              _SvgPartMap(
                svgAsset: 'assets/images/car_damage_top_view.svg',
                zones: _topViewZones,
                partsLabels: data.firstParts,
                selection: state.selection,
                options: options,
                onTap: (partKey, partLabel) => _openOptionSheet(
                    context, cubit, partKey, partLabel, options),
              ),

              // Tab 2 – Structural parts
              _SvgPartMap(
                svgAsset: 'assets/images/car_damage_bottom_view.svg',
                zones: _bottomViewZones,
                partsLabels: data.secondParts,
                selection: state.selection,
                options: options,
                onTap: (partKey, partLabel) => _openOptionSheet(
                    context, cubit, partKey, partLabel, options),
              ),
            ],
          ),
        ),

        // ── Selected summary + submit ──
        _BottomPanel(
          state: state,
          partsLabels: {
            ...data.firstParts,
            ...data.secondParts,
          },
          onSubmit: () => cubit.submitReport(widget.car.id),
        ),
      ],
    );
  }

  void _openOptionSheet(
    BuildContext context,
    CarDamageCubit cubit,
    String partKey,
    String partLabel,
    Map<String, String> options,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _OptionPickerSheet(
          partKey: partKey,
          partLabel: partLabel,
          options: options,
        ),
      ),
    );
  }
}

// ─── Instruction Banner ───────────────────────────────────────────────────────

class _InstructionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColor.kPrimaryMain.withOpacity(0.06),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.touch_app_rounded, size: 16, color: AppColor.kPrimaryMain),
          const SizedBox(width: 6),
          Text(
            'Tap on a car part to mark damage',
            style: TextStyle(
                fontSize: 12,
                color: AppColor.kPrimaryMain,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ─── SVG Part Map ─────────────────────────────────────────────────────────────

class _PartZone {
  final String key;
  final double cx;
  final double cy;

  const _PartZone(this.key, {required this.cx, required this.cy});
}

class _SvgPartMap extends StatelessWidget {
  final String svgAsset;
  final List<_PartZone> zones;
  final Map<String, String> partsLabels;
  final Map<String, Set<String>> selection;
  final Map<String, String> options;
  final void Function(String partKey, String partLabel) onTap;

  /// SVG native dimensions
  static const double _svgW = 308.0;
  static const double _svgH = 269.0;
  static const double _svgAR = _svgW / _svgH; // ≈ 1.1450

  const _SvgPartMap({
    required this.svgAsset,
    required this.zones,
    required this.partsLabels,
    required this.selection,
    required this.options,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final renderW = constraints.maxWidth;
      final renderH = constraints.maxHeight;

      // Fit SVG with contain, respecting aspect ratio
      double svgRenderW, svgRenderH, offsetX, offsetY;
      if (renderW / renderH > _svgAR) {
        // Height constrained
        svgRenderH = renderH;
        svgRenderW = renderH * _svgAR;
      } else {
        // Width constrained
        svgRenderW = renderW;
        svgRenderH = renderW / _svgAR;
      }
      offsetX = (renderW - svgRenderW) / 2;
      offsetY = (renderH - svgRenderH) / 2;

      final scaleX = svgRenderW / _svgW;
      final scaleY = svgRenderH / _svgH;

      return Stack(
        children: [
          // ── SVG background ──
          Positioned.fill(
            child: SvgPicture.asset(
              svgAsset,
              fit: BoxFit.contain,
            ),
          ),
          // ── Hit zones ──
          ...zones.map((zone) {
            final label = partsLabels[zone.key] ?? zone.key;
            final isSelected = (selection[zone.key]?.isNotEmpty) ?? false;
            final optionCount = selection[zone.key]?.length ?? 0;

            final x = offsetX + zone.cx * scaleX;
            final y = offsetY + zone.cy * scaleY;
            const r = 14.0; // touch radius in pixels

            return Positioned(
              left: x - r,
              top: y - r,
              child: GestureDetector(
                onTap: () => onTap(zone.key, label),
                child: _ZoneDot(
                  isSelected: isSelected,
                  optionCount: optionCount,
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

// ─── Zone Dot (visual indicator on SVG) ──────────────────────────────────────

class _ZoneDot extends StatelessWidget {
  final bool isSelected;
  final int optionCount;
  final double size;

  const _ZoneDot({
    required this.isSelected,
    required this.optionCount,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? AppColor.kError.withOpacity(0.85)
            : AppColor.kPrimaryMain.withOpacity(0.18),
        border: Border.all(
          color: isSelected
              ? AppColor.kError
              : AppColor.kPrimaryMain.withOpacity(0.45),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColor.kError.withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Center(
        child: isSelected
            ? Text(
                '$optionCount',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700),
              )
            : Icon(Icons.add,
                size: size * 0.45,
                color: AppColor.kPrimaryMain.withOpacity(0.7)),
      ),
    );
  }
}

// ─── Option Picker Bottom Sheet ───────────────────────────────────────────────

class _OptionPickerSheet extends StatelessWidget {
  final String partKey;
  final String partLabel;
  final Map<String, String> options;

  const _OptionPickerSheet({
    required this.partKey,
    required this.partLabel,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarDamageCubit, CarDamageState>(
      builder: (context, state) {
        final cubit = context.read<CarDamageCubit>();
        final partSelected = cubit.isPartSelected(partKey);

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
                        color: AppColor.kError.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.car_repair_rounded,
                          color: AppColor.kError, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partLabel,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.kNeutral900),
                          ),
                          Text(
                            'Select all damage types',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.kNeutral400),
                          ),
                        ],
                      ),
                    ),
                    if (partSelected)
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

              // Option checkboxes
              ...options.entries.map((entry) {
                final selected = cubit.isOptionSelected(partKey, entry.key);
                return _OptionTile(
                  label: entry.value,
                  isSelected: selected,
                  onTap: () => cubit.toggleOption(partKey, entry.key),
                );
              }),

              const SizedBox(height: 12),

              // Done button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kPrimaryMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Done',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.kError : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColor.kError : AppColor.kNeutral300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isSelected ? AppColor.kNeutral900 : AppColor.kNeutral600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Panel ─────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  final CarDamageState state;
  final Map<String, String> partsLabels;
  final VoidCallback onSubmit;

  const _BottomPanel({
    required this.state,
    required this.partsLabels,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedParts =
        state.selection.entries.where((e) => e.value.isNotEmpty).toList();

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
                  Icon(Icons.warning_amber_rounded,
                      size: 16, color: AppColor.kWarning),
                  const SizedBox(width: 6),
                  Text(
                    '${selectedParts.length} part${selectedParts.length > 1 ? 's' : ''} marked',
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
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.kError.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColor.kError.withOpacity(0.25)),
                    ),
                    child: Text(
                      '$label (${e.value.length})',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColor.kError,
                          fontWeight: FontWeight.w500),
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
                    : (state.status == CarDamageStatus.submitting
                        ? null
                        : onSubmit),
                icon: state.status == CarDamageStatus.submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  state.status == CarDamageStatus.submitting
                      ? 'Submitting…'
                      : 'Submit Damage Report',
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
            Text('Failed to load damage data',
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

// ─── Part Zone Definitions ────────────────────────────────────────────────────
// Coordinates match the *-center ellipse cx/cy values extracted from the SVGs.
// SVG viewBox: 308 × 269

/// Top view — first_parts
const List<_PartZone> _topViewZones = [
  _PartZone('hood', cx: 154.87, cy: 45.64),
  _PartZone('front_fender_left', cx: 48.61, cy: 47.62),
  _PartZone('front_fender_right', cx: 259.06, cy: 46.62),
  _PartZone('front_door_left', cx: 46.69, cy: 116.67),
  _PartZone('front_door_right', cx: 263.22, cy: 113.84),
  _PartZone('rear_door_left', cx: 49.06, cy: 164.93),
  _PartZone('rear_door_right', cx: 256.70, cy: 164.66),
  _PartZone('trunk_lid', cx: 153.78, cy: 248.77),
  _PartZone('roof_panel', cx: 154.45, cy: 159.67),
  _PartZone('quarter_panel_left', cx: 50.62, cy: 226.52),
  _PartZone('quarter_panel_right', cx: 256.76, cy: 226.59),
  _PartZone('side_sill_panel_left', cx: 18.65, cy: 130.06),
  _PartZone('side_sill_panel_right', cx: 289.87, cy: 130.55),
  _PartZone('radiator_support', cx: 154.0, cy: 16.0),
];

/// Bottom view — second_parts
const List<_PartZone> _bottomViewZones = [
  _PartZone('front_panel', cx: 150.13, cy: 35.28),
  _PartZone('cross_member', cx: 149.98, cy: 94.28),
  _PartZone('inside_panel_left', cx: 115.46, cy: 59.35),
  _PartZone('inside_panel_right', cx: 183.86, cy: 59.35),
  _PartZone('rear_panel', cx: 150.51, cy: 247.31),
  _PartZone('trunk_floor', cx: 148.93, cy: 226.64),
  _PartZone('front_side_member_left', cx: 131.52, cy: 66.28),
  _PartZone('front_side_member_right', cx: 167.52, cy: 66.28),
  _PartZone('rear_side_member_left', cx: 125.86, cy: 227.35),
  _PartZone('rear_side_member_right', cx: 171.86, cy: 227.35),
  _PartZone('front_wheelhouse_left', cx: 116.05, cy: 78.85),
  _PartZone('front_wheelhouse_right', cx: 184.05, cy: 78.85),
  _PartZone('rear_wheelhouse_left', cx: 112.05, cy: 220.85),
  _PartZone('rear_wheelhouse_right', cx: 186.05, cy: 220.85),
  _PartZone('filler_panel_a_left', cx: 104.0, cy: 108.0),
  _PartZone('filler_panel_a_right', cx: 204.0, cy: 108.0),
  _PartZone('filler_panel_b_left', cx: 104.0, cy: 138.0),
  _PartZone('filler_panel_b_right', cx: 204.0, cy: 138.0),
  _PartZone('filler_panel_c_left', cx: 104.0, cy: 168.0),
  _PartZone('filler_panel_c_right', cx: 204.0, cy: 168.0),
  _PartZone('package_tray', cx: 149.48, cy: 188.45),
  _PartZone('dash_panel', cx: 149.98, cy: 104.28),
  _PartZone('floor_panel', cx: 150.54, cy: 145.67),
];
