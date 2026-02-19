import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app/colors.dart';
import '../../data/models/car/car_response_model.dart';
import '../cubit/car_document_cubit.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

class CarDocumentScreen extends StatelessWidget {
  final CarModel car;

  const CarDocumentScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarDocumentCubit(),
      child: _CarDocumentBody(car: car),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _CarDocumentBody extends StatelessWidget {
  final CarModel car;

  const _CarDocumentBody({required this.car});

  // Pretty icon for each field
  IconData _fieldIcon(DocField field) {
    switch (field) {
      case DocField.carCertificate:
        return Icons.verified_rounded;
      case DocField.malso:
        return Icons.article_rounded;
      case DocField.pl:
        return Icons.list_alt_rounded;
      case DocField.expLicence:
        return Icons.card_membership_rounded;
    }
  }

  Color _fieldColor(DocField field) {
    switch (field) {
      case DocField.carCertificate:
        return const Color(0xFF2196F3);
      case DocField.malso:
        return const Color(0xFF9C27B0);
      case DocField.pl:
        return const Color(0xFFFF9800);
      case DocField.expLicence:
        return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarDocumentCubit, CarDocumentState>(
      listener: (context, state) {
        if (state.status == CarDocumentStatus.submitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Documents uploaded successfully'),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == CarDocumentStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Failed to upload documents'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CarDocumentCubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: _buildAppBar(),
          body: _buildBody(context, state, cubit),
          bottomNavigationBar: _buildBottomBar(context, state, cubit),
        );
      },
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.kPrimaryMain,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Car Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Quicksand',
            ),
          ),
          Text(
            car.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Quicksand',
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    CarDocumentState state,
    CarDocumentCubit cubit,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(state),
          const SizedBox(height: 16),
          ...DocField.values.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DocumentTile(
                  field: field,
                  icon: _fieldIcon(field),
                  color: _fieldColor(field),
                  fileName: state.fileNames[field],
                  isPicked: state.hasFile(field),
                  onPick: () => cubit.pickFile(field),
                  onRemove: () => cubit.removeFile(field),
                  isSubmitting: state.status == CarDocumentStatus.submitting,
                ),
              )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeader(CarDocumentState state) {
    final count = state.totalFiles;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColor.kPrimaryMain, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              count == 0
                  ? 'Pick files to upload. Accepted formats: PDF, JPG, PNG.'
                  : '$count file${count == 1 ? '' : 's'} ready to upload.',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Quicksand',
                color: count == 0 ? Colors.black54 : AppColor.kPrimaryMain,
                fontWeight: count > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom bar ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar(
    BuildContext context,
    CarDocumentState state,
    CarDocumentCubit cubit,
  ) {
    final isSubmitting = state.status == CarDocumentStatus.submitting;
    final hasFiles = state.totalFiles > 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (!hasFiles || isSubmitting)
                ? null
                : () => cubit.submitDocuments(car.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.kPrimaryMain,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Upload Documents',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Quicksand',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Document tile ────────────────────────────────────────────────────────────

class _DocumentTile extends StatelessWidget {
  final DocField field;
  final IconData icon;
  final Color color;
  final String? fileName;
  final bool isPicked;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final bool isSubmitting;

  const _DocumentTile({
    required this.field,
    required this.icon,
    required this.color,
    required this.fileName,
    required this.isPicked,
    required this.onPick,
    required this.onRemove,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPicked ? color.withOpacity(0.5) : Colors.grey.shade200,
          width: isPicked ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPicked
                ? color.withOpacity(0.08)
                : Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPicked
                        ? (fileName ?? 'File selected')
                        : field.description,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Quicksand',
                      color: isPicked ? color : Colors.black45,
                      fontWeight:
                          isPicked ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Action buttons
            if (!isPicked)
              _ActionChip(
                label: 'Pick',
                icon: Icons.upload_file_rounded,
                color: color,
                onTap: isSubmitting ? null : onPick,
              )
            else
              Row(
                children: [
                  _ActionChip(
                    label: 'Change',
                    icon: Icons.swap_horiz_rounded,
                    color: color,
                    onTap: isSubmitting ? null : onPick,
                  ),
                  const SizedBox(width: 6),
                  _ActionChip(
                    label: 'Remove',
                    icon: Icons.close_rounded,
                    color: Colors.red.shade400,
                    onTap: isSubmitting ? null : onRemove,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
