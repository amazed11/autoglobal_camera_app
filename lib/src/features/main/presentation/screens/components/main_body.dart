import 'package:autoglobal_camera_app/src/core/app/colors.dart';
import 'package:autoglobal_camera_app/src/core/configs/route_config.dart';
import 'package:autoglobal_camera_app/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autoglobal_camera_app/src/services/local/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../di_injection.dart';
import '../../../data/models/car/car_response_model.dart';
import '../../cubit/main_cubit.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<MainCubit>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      cubit.fetchMoreCars();
    }
  }

  void _openCarActions(BuildContext context, CarModel car) {
    context.read<MainCubit>().selectCar(car);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<MainCubit>(),
        child: _CarActionsSheet(
          car: car,
          onActionTap: (key) => _handleAction(context, car, key),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, CarModel car, String actionKey) {
    Navigator.pop(context); // close sheet first
    if (actionKey == 'camera') {
      context.pushNamed(RouteConfig.carWasherRoute, extra: car);
      return;
    }
    if (actionKey == 'permission') {
      context.pushNamed(RouteConfig.carPermissionRoute, extra: car);
      return;
    }
    if (actionKey == 'damage') {
      context.pushNamed(RouteConfig.carDamageRoute, extra: car);
      return;
    }
    if (actionKey == 'options') {
      context.pushNamed(RouteConfig.carOptionRoute, extra: car);
      return;
    }
    if (actionKey == 'paint') {
      context.pushNamed(RouteConfig.carPaintRoute, extra: car);
      return;
    }
    if (actionKey == 'documents') {
      context.pushNamed(RouteConfig.carDocumentRoute, extra: car);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Car #${car.id} · $actionKey'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child:
                Text('Cancel', style: TextStyle(color: AppColor.kNeutral600)),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              getIt<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.kError,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kNeutral50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Camera Cars',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.kPrimaryMain.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: AppColor.kPrimaryMain, size: 20),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      SharedPreference.getEmail ?? 'user@example.com',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.kNeutral800),
                    ),
                    const SizedBox(height: 2),
                    Text('Camera Operator',
                        style: TextStyle(
                            fontSize: 11, color: AppColor.kNeutral500)),
                    const SizedBox(height: 8),
                    Divider(height: 1, color: AppColor.kNeutral200),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(children: [
                  Icon(Icons.person_outline,
                      size: 20, color: AppColor.kNeutral700),
                  const SizedBox(width: 12),
                  const Text('My Profile',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ]),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(children: [
                  Icon(Icons.logout, size: 20, color: AppColor.kError),
                  const SizedBox(width: 12),
                  Text('Logout',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kError)),
                ]),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                context.pushNamed(RouteConfig.profileRoute);
              } else if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by chassis, model, or car number...',
                hintStyle: TextStyle(color: AppColor.kNeutral400, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: AppColor.kNeutral400),
                filled: true,
                fillColor: AppColor.kNeutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state.status == MainStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MainStatus.failure && state.cars.isEmpty) {
            return _buildErrorState(context, state);
          }
          if (state.cars.isEmpty) {
            return _buildEmptyState();
          }
          return Column(
            children: [
              _buildStatsBar(state),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<MainCubit>().fetchInitialCars(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: state.cars.length +
                        (state.status == MainStatus.loadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.cars.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final car = state.cars[index];
                      final isSelected = state.selectedCar?.id == car.id;
                      return _buildCarCard(context, car, isSelected);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsBar(MainState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.directions_car, size: 18, color: AppColor.kPrimaryMain),
          const SizedBox(width: 6),
          Text(
            '${state.cars.length} of ${state.total ?? state.cars.length} cars',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.kNeutral700),
          ),
          const Spacer(),
          Text(
            'Tap a car to see actions',
            style: TextStyle(fontSize: 12, color: AppColor.kNeutral400),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarModel car, bool isSelected) {
    return GestureDetector(
      onTap: () => _openCarActions(context, car),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColor.kPrimaryMain : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColor.kPrimaryMain.withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: car.image != null && car.image!.isNotEmpty
                      ? Image.network(
                          car.image!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imageFallback(),
                        )
                      : _imageFallback(),
                ),
                if (isSelected)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.kPrimaryMain,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.kPrimaryMain.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 18),
                    ),
                  ),
                if (car.favorite)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.favorite,
                          color: AppColor.kError, size: 18),
                    ),
                  ),
                // Tap hint badge
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text('Tap for actions',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.title.isEmpty ? 'Car #${car.id}' : car.title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _infoRow(Icons.qr_code_2_rounded, 'Chassis',
                      car.chasissNumber ?? 'N/A'),
                  const SizedBox(height: 6),
                  _infoRow(Icons.pin_rounded, 'Plate', car.carNumber ?? 'N/A'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (car.city != null)
                        _detailChip(Icons.location_city, car.city!),
                      if (car.fuelType != null)
                        _detailChip(Icons.local_gas_station, car.fuelType!),
                      if (car.transmissionType != null)
                        _detailChip(Icons.settings, car.transmissionType!),
                      if (car.mileage != null)
                        _detailChip(Icons.speed, '${car.mileage} km'),
                      if (car.exteriorColor != null)
                        _detailChip(Icons.palette, car.exteriorColor!),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.kNeutral500),
        const SizedBox(width: 6),
        Text('$label: ',
            style: TextStyle(
                fontSize: 13,
                color: AppColor.kNeutral500,
                fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColor.kNeutral800,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _detailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.kNeutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.kNeutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColor.kNeutral600),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.kNeutral700)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, MainState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColor.kError),
            const SizedBox(height: 16),
            const Text('Unable to Load Cars',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              state.message ?? 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.kNeutral600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<MainCubit>().fetchInitialCars(),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined,
                size: 80, color: AppColor.kNeutral300),
            const SizedBox(height: 16),
            const Text('No Cars Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('There are no camera cars in the system yet.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColor.kNeutral600)),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      width: double.infinity,
      height: 180,
      color: AppColor.kNeutral100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_filled_rounded,
              size: 56, color: AppColor.kNeutral300),
          const SizedBox(height: 8),
          Text('No Image',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColor.kNeutral400,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Car Actions Bottom Sheet
// ─────────────────────────────────────────────

class _CarActionsSheet extends StatelessWidget {
  final CarModel car;
  final void Function(String) onActionTap;

  const _CarActionsSheet({
    required this.car,
    required this.onActionTap,
  });

  static const _actions = [
    _ActionItem(
      key: 'camera',
      label: 'Open Camera',
      subtitle: 'Capture car photos & videos',
      icon: Icons.camera_alt_rounded,
      color: Color(0xFF0b1e6d),
    ),
    _ActionItem(
      key: 'permission',
      label: 'Permission',
      subtitle: 'View car permissions detail',
      icon: Icons.verified_user_rounded,
      color: Color(0xFF2196F3),
    ),
    _ActionItem(
      key: 'damage',
      label: 'Damage Report',
      subtitle: 'Submit damage assessment',
      icon: Icons.car_crash_rounded,
      color: Color(0xFFFF9800),
    ),
    _ActionItem(
      key: 'paint',
      label: 'Paint Report',
      subtitle: 'Submit paint work details',
      icon: Icons.format_paint_rounded,
      color: Color(0xFF9C27B0),
    ),
    _ActionItem(
      key: 'documents',
      label: 'Documents',
      subtitle: 'Upload car documents',
      icon: Icons.description_rounded,
      color: Color(0xFF4CAF50),
    ),
    _ActionItem(
      key: 'options',
      label: 'Car Options',
      subtitle: 'Update car options & features',
      icon: Icons.tune_rounded,
      color: Color(0xFF607D8B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.kNeutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // ── Car summary ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: car.image != null && car.image!.isNotEmpty
                      ? Image.network(
                          car.image!,
                          width: 72,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _thumbFallback(),
                        )
                      : _thumbFallback(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.title.isEmpty ? 'Car #${car.id}' : car.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.qr_code_2_rounded,
                              size: 13, color: AppColor.kNeutral500),
                          const SizedBox(width: 4),
                          Text(car.chasissNumber ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.kNeutral600)),
                          const SizedBox(width: 10),
                          Icon(Icons.pin_rounded,
                              size: 13, color: AppColor.kNeutral500),
                          const SizedBox(width: 4),
                          Text(car.carNumber ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.kNeutral600)),
                        ],
                      ),
                      if (car.city != null) ...[
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.location_on_rounded,
                              size: 13, color: AppColor.kNeutral400),
                          const SizedBox(width: 4),
                          Text(car.city!,
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.kNeutral500)),
                        ]),
                      ],
                    ],
                  ),
                ),
                // Selected badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColor.kPrimaryMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 14, color: AppColor.kPrimaryMain),
                      const SizedBox(width: 4),
                      Text('Selected',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColor.kPrimaryMain)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: AppColor.kNeutral100),
          // ── Section header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  'Actions',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColor.kNeutral500,
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          // ── Action list ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _actions.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, indent: 72, color: AppColor.kNeutral100),
            itemBuilder: (context, i) {
              final action = _actions[i];
              return Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () => onActionTap(action.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 13),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: action.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              Icon(action.icon, color: action.color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(action.label,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(action.subtitle,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.kNeutral500)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: AppColor.kNeutral400, size: 22),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // ── Bottom safe area ──
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _thumbFallback() {
    return Container(
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
}

class _ActionItem {
  final String key;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ActionItem({
    required this.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
