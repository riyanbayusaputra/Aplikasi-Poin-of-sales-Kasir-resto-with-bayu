import 'package:apps_kasir_resto/presentation/setting/bloc/add_discount/add_discount_bloc.dart';
import 'package:apps_kasir_resto/presentation/setting/bloc/discount/discount_bloc.dart';
import 'package:flutter/material.dart';
import 'package:apps_kasir_resto/core/components/custom_text_field.dart';
import 'package:apps_kasir_resto/core/extensions/build_context_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../home/models/product_category.dart';
import '../models/discount_model.dart';

class FormDiscountDialog extends StatefulWidget {
  final DiscountModel? data;
  const FormDiscountDialog({super.key, this.data});

  @override
  State<FormDiscountDialog> createState() => _FormDiscountDialogState();
}

class _FormDiscountDialogState extends State<FormDiscountDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final discountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
          const Text('Tambah Diskon'),
          const Spacer(),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: context.deviceWidth / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: nameController,
                label: 'Nama Diskon',
                onChanged: (value) {},
              ),
              const SpaceHeight(24.0),
              CustomTextField(
                controller: descriptionController,
                label: 'Deskripsi (Opsional)',
                onChanged: (value) {},
              ),
              const SpaceHeight(24.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: CustomTextField(
                      controller: TextEditingController(text: 'Presentase'),
                      label: 'Nilai',
                      suffixIcon: const Icon(Icons.chevron_right),
                      onChanged: (value) {},
                      readOnly: true,
                    ),
                  ),
                  const SpaceWidth(14.0),
                  Flexible(
                    child: CustomTextField(
                      showLabel: false,
                      controller: discountController,
                      label: 'Percent',
                      prefixIcon: const Icon(Icons.percent),
                      onChanged: (value) {},
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SpaceHeight(24.0),
              BlocConsumer<AddDiscountBloc, AddDiscountState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    success: () {
                      context
                          .read<DiscountBloc>()
                          .add(const DiscountEvent.getDiscounts());
                      context.pop();
                    },
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(orElse: () {
                    return Button.filled(
                      onPressed: () {
                        context.read<AddDiscountBloc>().add(
                              AddDiscountEvent.addDiscount(
                                name: nameController.text,
                                description: descriptionController.text,
                                value: int.parse(discountController.text),
                              ),
                            );
                      },
                      label: 'Simpan Diskon',
                    );
                  }, loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
