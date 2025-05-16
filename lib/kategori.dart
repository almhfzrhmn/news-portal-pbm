import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Constants for styling
const _kSectionPadding = EdgeInsets.all(8.0);
const _kSectionBorder = BorderSide(color: Colors.blue, width: 3.0);
const _kSectionBorderRadius = BorderRadius.all(Radius.circular(10.0));
const _kDividerHeight = 1.5;
const _kSectionSpacing = 16.0;
const _kToastDuration = Duration(seconds: 2);
const _kToastMargin = EdgeInsets.only(bottom: 20.0);
const _kToastPadding = EdgeInsets.all(10.0);
const _kToastBorderRadius = BorderRadius.all(Radius.circular(25.0));

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // Initialize FToast with context in didChangeDependencies or build
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fToast.init(context); // Bind FToast to the current context
  }

  // Reusable toast widget
  Widget _buildToast(String tag) {
    return Container(
      margin: _kToastMargin,
      padding: _kToastPadding,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: _kToastBorderRadius,
      ),
      child: Text('Anda memilih kategori $tag'),
    );
  }

  // Reusable icon button
  Widget _iconTag({required Icon icon, required String tag, required Key key}) {
    return IconButton(
      key: key,
      icon: icon,
      tooltip: 'Kategori $tag', // Accessibility
      onPressed: () {
        fToast.removeQueuedCustomToasts(); // Cancel previous toasts
        fToast.showToast(
          toastDuration: _kToastDuration,
          child: _buildToast(tag),
        );
      },
    );
  }

  // Reusable category section
  Widget _categorySection({
    required String title,
    required List<Widget> children,
    Key? key,
  }) {
    return Container(
      key: key,
      padding: _kSectionPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: _kSectionBorder.color,
          width: _kSectionBorder.width,
        ),
        borderRadius: _kSectionBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4.0),
          Container(height: _kDividerHeight, color: Colors.grey),
          const SizedBox(height: 8.0),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        key: const Key('kategoriAppBar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _categorySection(
                key: const Key('generalSection'),
                title: 'General',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconTag(
                        icon: const Icon(Icons.attach_money),
                        tag: 'General',
                        key: const Key('generalMoneyIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.card_travel),
                        tag: 'General',
                        key: const Key('generalTravelIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.local_hospital),
                        tag: 'General',
                        key: const Key('generalHospitalIcon'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: _kSectionSpacing),
              _categorySection(
                key: const Key('entertainmentSection'),
                title: 'Entertainment',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconTag(
                        icon: const Icon(Icons.fastfood),
                        tag: 'Entertainment',
                        key: const Key('entertainmentFoodIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.hotel),
                        tag: 'Entertainment',
                        key: const Key('entertainmentHotelIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.local_grocery_store),
                        tag: 'Entertainment',
                        key: const Key('entertainmentGroceryIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.local_movies),
                        tag: 'Entertainment',
                        key: const Key('entertainmentMoviesIcon'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: _kSectionSpacing),
              _categorySection(
                key: const Key('transportasiSection'),
                title: 'Transportasi',
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconTag(
                        icon: const Icon(Icons.directions_bike),
                        tag: 'Transportasi',
                        key: const Key('transportasiBikeIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.motorcycle),
                        tag: 'Transportasi',
                        key: const Key('transportasiMotorcycleIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.directions_car),
                        tag: 'Transportasi',
                        key: const Key('transportasiCarIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.local_shipping),
                        tag: 'Transportasi',
                        key: const Key('transportasiShippingIcon'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconTag(
                        icon: const Icon(Icons.directions_bus),
                        tag: 'Transportasi',
                        key: const Key('transportasiBusIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.directions_boat),
                        tag: 'Transportasi',
                        key: const Key('transportasiBoatIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.train),
                        tag: 'Transportasi',
                        key: const Key('transportasiTrainIcon'),
                      ),
                      _iconTag(
                        icon: const Icon(Icons.airplanemode_active),
                        tag: 'Transportasi',
                        key: const Key('transportasiAirplaneIcon'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
