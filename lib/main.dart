
import 'package:flutter/material.dart';
import 'package:flutter_app/product.dart';
import 'package:flutter_app/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const ProductDetail(),
    );
  }
}

class ProductData extends InheritedWidget {
  final Product product;

  const ProductData({
    Key? key,
    required this.product,
    required Widget child,
  }) : super(key: key, child: child);

  static ProductData of(BuildContext context) {
    final ProductData? result =
    context.dependOnInheritedWidgetOfExactType<ProductData>();
    assert(result != null, 'No ProductData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ProductData old) {
    return product != old.product;
  }
}

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO
    final Product product = Product(
      barcode: '1234567',
      name: 'Petits pois et carottes',
      brands: ["Cassegrain"],
      quantity: '200g',
      manufacturingCountries: ["France"],
      picture:
      'https://images.openfoodfacts.org/images/products/317/568/001/1480/front_fr.139.400.jpg',
      nutriScore: ProductNutriscore.A,
    );

    return ProductData(
      product: product,
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              const ProductImage(),
              Positioned.fill(
                child: ProductContainer(
                  child: Column(
                    children: [
                      const ProductHeader(),
                      const ProductScores(),
                      ProductInfo(
                        title: 'Quantité',
                        value: product.quantity!.toString(),
                        divider: true,
                      ),
                      ProductInfo(
                        title: 'Vendu',
                        value: product.manufacturingCountries!
                            .toList(growable: false)
                            .join(", "),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductHeader extends StatelessWidget {
  const ProductHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = ProductData.of(context).product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name!),
        Text(product.brands!.toList(growable: false).join(", ")),
        if (product.altName != null) Text(product.altName!)
      ],
    );
  }
}

class ProductScores extends StatelessWidget {
  const ProductScores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = ProductData.of(context).product;

    return Container(
      color: AppColors.gray1,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: ProductNutriscoreWidget(score: product.nutriScore!),
              ),
              Container(
                width: 1,
                height: 100,
                color: AppColors.gray2,
              ),
              Expanded(
                flex: 6,
                child: ProductNutriscoreWidget(score: product.nutriScore!),
              ),
            ],
          ),
          const Divider(
            height: 1,
            color: AppColors.gray2,
          ),
          ProductNutriscoreWidget(score: product.nutriScore!),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Image.network(
        ProductData.of(context).product.picture!,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  final Widget? child;

  const ProductContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const BorderRadiusDirectional radius = BorderRadiusDirectional.only(
      topStart: Radius.circular(16.0),
      topEnd: Radius.circular(16.0),
    );
    return SingleChildScrollView(
      child: Scrollbar(
        child: Container(
          height: 10000,
          margin: const EdgeInsets.only(
            top: 150,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: child,
          ),
        ),
      ),
    );
  }
}

class ProductNutriscoreWidget extends StatelessWidget {
  final ProductNutriscore score;

  const ProductNutriscoreWidget({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nutri-Score'),
          Image.asset(
            'res/drawables/nutriscore_${score.letter}.png',
            width: 78,
            height: 42,
          )
        ],
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final String title;
  final String value;
  final bool divider;

  const ProductInfo({
    Key? key,
    required this.title,
    required this.value,
    this.divider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title),
              const Spacer(),
              Text(value),
            ],
          ),
          if (divider)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(
                height: 1,
                color: AppColors.gray2,
              ),
            )
        ],
      ),
    );
  }
}
