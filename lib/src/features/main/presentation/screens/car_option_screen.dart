import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../di_injection.dart';
import '../../../../core/app/colors.dart';
import '../../../../services/network/api_handler.dart';
import '../../data/models/car/car_response_model.dart';
import '../cubit/car_option_cubit.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

class CarOptionScreen extends StatelessWidget {
  final CarModel car;

  const CarOptionScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarOptionCubit(getIt<ApiHandler>())..fetchOptions(),
      child: _CarOptionBody(car: car),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _CarOptionBody extends StatelessWidget {
  final CarModel car;

  const _CarOptionBody({required this.car});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarOptionCubit, CarOptionState>(
      listener: (context, state) {
        if (state.status == CarOptionStatus.submitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Car options updated successfully'),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == CarOptionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Failed to update options'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CarOptionCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: _buildAppBar(context, state, cubit, car),
          body: _buildBody(context, state, cubit),
          bottomNavigationBar: _buildBottomBar(context, state, cubit),
        );
      },
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    CarOptionState state,
    CarOptionCubit cubit,
    CarModel car,
  ) {
    return AppBar(
      backgroundColor: AppColor.kPrimaryMain,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Car Options',
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
      actions: [
        if (state.status == CarOptionStatus.loaded) ...[
          TextButton(
            onPressed: cubit.selectAll,
            child: const Text(
              'All',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand',
              ),
            ),
          ),
          TextButton(
            onPressed: cubit.clearAll,
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand',
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    CarOptionState state,
    CarOptionCubit cubit,
  ) {
    switch (state.status) {
      case CarOptionStatus.initial:
      case CarOptionStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case CarOptionStatus.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 56, color: Colors.red.shade300),
              const SizedBox(height: 12),
              Text(
                state.message ?? 'Failed to load options',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Quicksand',
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: cubit.fetchOptions,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kPrimaryMain,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        );

      case CarOptionStatus.loaded:
      case CarOptionStatus.submitting:
      case CarOptionStatus.submitted:
        return Column(
          children: [
            _buildSelectionBanner(context, state),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: state.options.length,
                itemBuilder: (context, index) {
                  final option = state.options[index];
                  final isSelected = state.isSelected(option.id);
                  return _OptionCard(
                    option: option,
                    isSelected: isSelected,
                    onTap: () => cubit.toggleOption(option.id),
                  );
                },
              ),
            ),
          ],
        );
    }
  }

  Widget _buildSelectionBanner(BuildContext context, CarOptionState state) {
    final count = state.selectedIds.length;
    return Container(
      width: double.infinity,
      color: AppColor.kPrimaryMain.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        count == 0
            ? 'Tap options to select'
            : '$count option${count == 1 ? '' : 's'} selected',
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          color: AppColor.kPrimaryMain,
        ),
      ),
    );
  }

  // ── Bottom bar ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar(
    BuildContext context,
    CarOptionState state,
    CarOptionCubit cubit,
  ) {
    final isSubmitting = state.status == CarOptionStatus.submitting;
    final hasSelection = state.selectedIds.isNotEmpty;
    final isLoaded = state.status == CarOptionStatus.loaded ||
        state.status == CarOptionStatus.submitting;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (isLoaded && hasSelection && !isSubmitting)
                ? () => cubit.submitOptions(car.id)
                : null,
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
                    'Update Options',
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

// ─── Option card ──────────────────────────────────────────────────────────────

class _OptionCard extends StatelessWidget {
  final dynamic option; // CarOption
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColor.kPrimaryMain.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColor.kPrimaryMain : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColor.kPrimaryMain.withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OptionIcon(icon: option.icon, isSelected: isSelected),
                  const SizedBox(height: 10),
                  Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? AppColor.kPrimaryMain : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColor.kPrimaryMain,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionIcon extends StatelessWidget {
  final String icon;
  final bool isSelected;

  const _OptionIcon({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (icon.isEmpty) {
      return Icon(
        Icons.settings_rounded,
        size: 36,
        color: isSelected ? AppColor.kPrimaryMain : Colors.grey,
      );
    }
    return SizedBox(
      height: 36,
      width: 36,
      child: Image.network(
        icon,
        fit: BoxFit.contain,
        color: isSelected ? AppColor.kPrimaryMain : Colors.grey.shade700,
        errorBuilder: (_, __, ___) => Icon(
          Icons.settings_rounded,
          size: 36,
          color: isSelected ? AppColor.kPrimaryMain : Colors.grey,
        ),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          );
        },
      ),
    );
  }
}
