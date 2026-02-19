import 'package:autoglobal_camera_app/src/core/app/colors.dart';
import 'package:autoglobal_camera_app/src/features/main/data/models/car/car_permission_model.dart';
import 'package:autoglobal_camera_app/src/features/main/data/models/car/car_response_model.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/cubit/car_permission_cubit.dart';
import 'package:autoglobal_camera_app/src/services/network/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di_injection.dart';

class CarPermissionScreen extends StatelessWidget {
  final CarModel car;
  const CarPermissionScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CarPermissionCubit(getIt<ApiHandler>())..fetchPermission(car.id),
      child: _CarPermissionView(car: car),
    );
  }
}

class _CarPermissionView extends StatelessWidget {
  final CarModel car;
  const _CarPermissionView({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kNeutral50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Car Permissions',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.kNeutral800),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _CarSummaryHeader(car: car),
          Expanded(
            child: BlocBuilder<CarPermissionCubit, CarPermissionState>(
              builder: (context, state) {
                if (state.status == CarPermissionStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == CarPermissionStatus.failure) {
                  return _ErrorView(
                    message: state.message,
                    onRetry: () => context
                        .read<CarPermissionCubit>()
                        .fetchPermission(car.id),
                  );
                }
                if (state.status == CarPermissionStatus.success &&
                    state.data != null) {
                  return _PermissionList(data: state.data!);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Car summary header ───────────────────────────────────────────────────────

class _CarSummaryHeader extends StatelessWidget {
  final CarModel car;
  const _CarSummaryHeader({required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: car.image != null && car.image!.isNotEmpty
                ? Image.network(
                    car.image!,
                    width: 72,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imgFallback(),
                  )
                : _imgFallback(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.title.isEmpty ? 'Car #${car.id}' : car.title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.qr_code_2_rounded,
                      size: 13, color: AppColor.kNeutral500),
                  const SizedBox(width: 4),
                  Text(car.chasissNumber ?? 'N/A',
                      style:
                          TextStyle(fontSize: 12, color: AppColor.kNeutral600)),
                  const SizedBox(width: 10),
                  Icon(Icons.pin_rounded,
                      size: 13, color: AppColor.kNeutral500),
                  const SizedBox(width: 4),
                  Text(car.carNumber ?? 'N/A',
                      style:
                          TextStyle(fontSize: 12, color: AppColor.kNeutral600)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgFallback() => Container(
        width: 72,
        height: 56,
        decoration: BoxDecoration(
          color: AppColor.kNeutral100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.directions_car_filled_rounded,
            size: 28, color: AppColor.kNeutral300),
      );
}

// ─── Permission list ──────────────────────────────────────────────────────────

class _PermissionList extends StatelessWidget {
  final CarPermissionData data;
  const _PermissionList({required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      _PermissionItem(
        label: 'Upload Images',
        description: 'Capture & upload car photos',
        icon: Icons.camera_alt_rounded,
        color: const Color(0xFF0b1e6d),
        allowed: data.canUploadImages,
      ),
      _PermissionItem(
        label: 'Damage Report',
        description: 'Submit damage assessments',
        icon: Icons.car_crash_rounded,
        color: const Color(0xFFFF9800),
        allowed: data.canUploadDamage,
      ),
      _PermissionItem(
        label: 'Paint Report',
        description: 'Submit paint work details',
        icon: Icons.format_paint_rounded,
        color: const Color(0xFF9C27B0),
        allowed: data.canUploadPaint,
      ),
      _PermissionItem(
        label: 'Documents',
        description: 'Upload car documents',
        icon: Icons.description_rounded,
        color: const Color(0xFF4CAF50),
        allowed: data.canUploadDocument,
      ),
      _PermissionItem(
        label: 'Car Options',
        description: 'Update car options & features',
        icon: Icons.tune_rounded,
        color: const Color(0xFF607D8B),
        allowed: data.canUploadOptions,
      ),
    ];

    final allowedCount = items.where((i) => i.allowed).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: allowedCount == items.length
                        ? const Color(0xFF4CAF50).withOpacity(0.12)
                        : AppColor.kWarning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    allowedCount == items.length
                        ? Icons.verified_rounded
                        : Icons.security_rounded,
                    color: allowedCount == items.length
                        ? const Color(0xFF4CAF50)
                        : AppColor.kWarning,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$allowedCount of ${items.length} permissions granted',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        allowedCount == items.length
                            ? 'This car has full access'
                            : 'Some actions are restricted',
                        style: TextStyle(
                            fontSize: 13, color: AppColor.kNeutral500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'PERMISSION DETAILS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColor.kNeutral500,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, indent: 72, color: AppColor.kNeutral100),
              itemBuilder: (_, i) => _PermissionTile(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final _PermissionItem item;
  const _PermissionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(item.description,
                    style:
                        TextStyle(fontSize: 12, color: AppColor.kNeutral500)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatusBadge(allowed: item.allowed),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool allowed;
  const _StatusBadge({required this.allowed});

  @override
  Widget build(BuildContext context) {
    final color = allowed ? const Color(0xFF4CAF50) : AppColor.kError;
    final bg = allowed
        ? const Color(0xFF4CAF50).withOpacity(0.1)
        : AppColor.kError.withOpacity(0.1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            allowed ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            allowed ? 'Allowed' : 'Denied',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _ErrorView({this.message, required this.onRetry});

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
            const Text('Failed to Load Permissions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              message ?? 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.kNeutral600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data class ───────────────────────────────────────────────────────────────

class _PermissionItem {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final bool allowed;

  const _PermissionItem({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.allowed,
  });
}
